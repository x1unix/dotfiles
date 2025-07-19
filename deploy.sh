#!/usr/bin/env sh
set -e

__BINNAME="$0"
__FILE="$(readlink -f -- "$0")"
__DIR="$(dirname -- "$__FILE")"

TARGET_EXT=.target.sh
TARGETS_DIR="$__DIR/targets"

# XDG defaults
export XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-"$HOME/.local/state"}"

ESC=$(printf '\033')
BOLD="${ESC}[1m"
RESET="${ESC}[0m"
RED="${ESC}[31m"
CYAN="${ESC}[36m"
YELLOW="${ESC}[33m"
WHITE="${ESC}[37m"
GRAY="${ESC}[90m"

die() {
	printf "%s%sError:%s %s%s%s\n" "$BOLD" "$RED" "$RESET" "$BOLD" "$WHITE" "$1" >&2
	exit 1
}

notify_err() {
	printf "%s%sError:%s %s%s%s%s\n" "$BOLD" "$RED" "$RESET" "$BOLD" "$WHITE" "$1" "$RESET" >&2
}

notify_step() {
	printf "%s%s:: %s%s\n" "$BOLD" "$WHITE" "$*" "$RESET"
}

notify_info() {
	printf "%s%sNOTE:%s %s\n" "$BOLD" "$CYAN" "$RESET" "$*"
}

notify_warn() {
	printf "%s%sWARNING:%s %s%s%s%s\n" "$BOLD" "$YELLOW" "$RESET" "$BOLD" "$WHITE" "$*" "$RESET"
}

debug_log() {
	if [ -n "$DEBUG" ]; then	
		printf "%s[dbg] %s%s\n" "$GRAY" "$*" "$RESET" >&2
	fi
}

assert_in_target() {
	if [ -z "$CURRENT_TARGET" ]; then
		die 'should be inside a target'
	fi
}

assert_command() {
	if ! command -v "$1" >/dev/null 2>&1; then
		die "$1 is not installed"
		return
	fi
}

assert_def() {
	if [ -z "$1" ]; then
		die "$2"
	fi
}

link_dot() {
	__private_stow 'link_dot' "$HOME" "$pkg" --dotfiles
}

link_home() {
	dst="$HOME"
	pkg="$1"
	if [ -n "$2" ]; then
		dst="$HOME/$1"
		pkg="$2"
		mkdir -p "$dst"
	fi

	__private_stow 'link_home' "$dst" "$pkg"
}

link_local_bin() {
	bindir="$HOME/.local/bin"
	mkdir -p "$bindir"
	__private_stow 'link_local_bin' "$bindir" "$1"
}

link_xdg_config() {
	__private_stow 'link_xdg_config' "$XDG_CONFIG_HOME" "$1"
}

link_xdg_data() {
	__private_stow 'link_xdg_data' "$XDG_DATA_HOME" "$1"
}

link_xdg_state() {
	__private_stow 'link_xdg_state' "$XDG_STATE_HOME" "$1"
}

pad_right() {
    str=$1
    width=$2
    padchar=${3:-" "}  # default to space if not provided

    while [ "${#str}" -lt "$width" ]; do
        str="$str$padchar"
    done
    printf "%s" "$str"
}

# @param $1 operation name
# @param $2 dest path
# @param $3 target package (target/package)
# @param $4 raw stow opts
__private_stow() {
	assert_in_target
	assert_def "$2" "$1: missing dir name"
	assert_def "$3" "$1: missing package name"

	dst="$2"
	pkg="$3"
	if [ -n "$G_DRY_RUN" ]; then
		return
	fi

	if [ -n "$G_REVERT" ]; then
		notify_step "Removing '$CURRENT_TARGET/$pkg' symlinks..."
		__private_stow_unlink "$1" "$dst" "$pkg"
		return
	fi

	notify_step "Symlink item from '$CURRENT_TARGET/$pkg' to '$dst' ..."
	__private_stow_link "$1" "$dst" "$pkg"
}

# @param $1 operation name
# @param $2 dest path
# @param $3 target package (target/package)
# @param $4 raw stow opts
__private_stow_link() {
	if [ -n "$G_DRY_RUN" ]; then
		return
	fi

	assert_command stow
	mkdir -p "$2"

	recipes_dir="$__DIR/$CURRENT_TARGET"
	cmd="stow -v -t '$2' -d '$recipes_dir' '$3' $4"
	echo "$cmd"
	sh -c "$cmd"
}

# @param $1 operation name
# @param $2 dest path
# @param $3 target package (target/package)
# @param $4 raw stow opts
__private_stow_unlink() {
	if [ -n "$G_DRY_RUN" ]; then
		return
	fi

	assert_command stow
	if [ ! -d "$1" ]; then
		return
	fi

	recipes_dir="$CURRENT_TARGET"
	if [ ! -d "$recipes_dir/$3" ]; then
		die "$1: directory '$recipes_dir/$3' doesn't exist"
	fi

	stow -v -D -t "$2" -d "$recipes_dir" "$3" "$4"
}

# @param $1 target
require() {
	assert_in_target
	if [ "$#" -eq 0 ]; then
		die 'require: missing target'
	fi

	while [ $# -gt 0 ]; do
		target_name="$1"
		target_file="$TARGETS_DIR/$target_name$TARGET_EXT"
		shift

		if [ ! -f "$target_file" ]; then
			die "require: '$target_file' doesn't exist"
			return
		fi
		
		if [ -n "$G_DRY_RUN" ]; then
			_DOC_EXTENDS="$_DOC_EXTENDS $target_name"
			return
		fi

		notify_step "Processing parent target '$target_name' ..."
		__private_eval_target "$target_name" 1
	done
}

# @param $1 func_name
# @param $2 optional, flag or var name
step() {
	assert_in_target
	assert_def "$1" 'step: missing function name'

	func_name="$1"
	binding="$2"

	if [ -n "$binding" ]; then
		__private_step_with_flag "$func_name" "$binding"
		return
	fi
	
	if [ -n "$G_DRY_RUN" ]; then
		return
	fi

	if [ -n "$G_REVERT" ]; then
		rollback_func="$1_rollback"
		if ! command -v "$rollback_func" >/dev/null 2>&1; then
			notify_warn "missing rollback function for $func_name. Implement $rollback_func to support rollback."	
			return
		fi

		notify_step "Rollback step '$func_name'..."
		func_name="$rollback_func"
	else
		notify_step "Running step '$func_name' ..."
	fi

	"$func_name" "$CURRENT_TARGET"
}

__private_step_with_flag() {
	assert_in_target
	func_name="$1"
	bind_opt="$(printf '%s' "$2" | cut -d':' -f1)"
	bind_val="$(printf '%s' "$2" | cut -d':' -f2)"
	assert_def "$func_name" 'step: missing func name'
	assert_def "$bind_opt" 'step: missing binding option'
	assert_def "$bind_val" 'step: missing binding value'
	if [ "$bind_opt" != 'flag' ]; then
		die "step: unsupported step binding: $bind_opt (at '$2')"
	fi
	
	if [ -n "$G_DRY_RUN" ]; then
		# Just assembly doc
		_DOC_FLAGS="$_DOC_FLAGS $bind_val:$func_name"
		_TARGET_EXPECT_FLAGS="$_TARGET_EXPECT_FLAGS $bind_val"
		return
	fi

	eval "flag_value=\"\$G_FLAG_$bind_val\""
	debug_log "condition: $func_name - flag:'$bind_val'; value:'$flag_value'"
	if [ -z "$flag_value" ] && [ -z "$G_FLAG_all" ]; then
		notify_info "step '$func_name' skipped as $bind_opt --$bind_val is missing"
		return
	fi
	
	if [ -n "$G_REVERT" ]; then
		rollback_func="${func_name}_rollback"
		if ! command -v "$rollback_func" >/dev/null 2>&1; then
			notify_warn "missing rollback function for $func_name. Implement $rollback_func to support rollback."	
			return
		fi

		notify_step "Rollback step '$func_name'..."
		func_name="$rollback_func"
	else
		notify_step "Running step '$func_name' ..."
	fi


	"$func_name" "$flag_value"
	unset flag_value
}

__private_get_target_name() {
	basename "$1" | sed "s|$TARGET_EXT\$||"
}

__private_help() {
	cat << EOF
Usage: $0 <command> [flags]

Applies or rollback a set of actions declared in a target file.

Target file is a file with '.target.sh' extension stored in 'targets' directory.
Files used by a target are stored in 'target/<target_name>' directory.

Commands:
  list                  Print list of available targets.
  apply <target>        Apply changes declared in a target file.
  rollback <target>     Rollback changes done by 'apply' command.
  info <target>         Show information about target and its allowed command-line flags.
  help                  Display this help.
EOF

}

# @param $1 key
__private_get_os_release_field() {
	line="$(grep -E "^$1=" /etc/os-release | head -n 1)"
	if [ -z "$line" ]; then
		return
	fi

	value="${line#*=}"
	case "$value" in
		\"*\")
			value="${value#\"}";
			value="${value%\"}";
			;;
	esac
	echo "$value"
}

__private_init_build_constraints() {
	export G_OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
	export G_ARCH="$(uname -m | tr '[:upper:]' '[:lower:]')"	
	export G_DISTRO='unknown'
	export G_DISTRO_VERSION='unknown'

	if [ "$G_OS" = 'darwin' ]; then
		G_DISTRO="$(sw_vers --productName)"
		G_DISTRO_VERSION="$(sw_vers --productVersion)"
		debug_log 'os-release: using values from sw_vers'
		return
	fi

  if [ -n "$ANDROID_DATA" ]; then
    G_DISTRO='android'
    G_DISTRO_VERSION="$ANDROID__BUILD_VERSION_SDK"
    debug_log "os-release: detected distro='$G_DISTRO' version='$G_DISTRO_VERSION'"
  fi

	if [ ! -f /etc/os-release ]; then
		debug_log 'os-release: not found'
		return
	fi

	G_DISTRO="$(__private_get_os_release_field ID)"
	if [ -z "$G_DISTRO" ]; then
		G_DISTRO='unknown'
	fi

	G_DISTRO_VERSION="$(__private_get_os_release_field VERSION_CODENAME)"
	if [ -z "$G_DISTRO_VERSION" ]; then
		debug_log 'os-release: VERSION_CODENAME is missing, trying VERSION_ID'
		G_DISTRO_VERSION="$(__private_get_os_release_field VERSION_ID)"
	fi

	if [ -z "$G_DISTRO_VERSION" ]; then
		debug_log 'os-release: VERSION_ID is missing, trying BUILD_ID'
		G_DISTRO_VERSION="$(__private_get_os_release_field BUILD_ID)"
	fi

	debug_log "os-release: detected distro='$G_DISTRO' version='$G_DISTRO_VERSION'"
}

# @param $1 pragma name
# @param $1 script path
__private_get_target_pragma() {
	pragma_name="$1"
	script_path="$2"
	
	if [ ! -r "$script_path" ]; then
		die "file $script_path doesn't exist"
	fi

	grep_str="$(printf '^#%s:' "$pragma_name")"
	require_line="$(grep -E "$grep_str" "$script_path" | head -n 1)"
	if [ -z "$require_line" ]; then
		# no constraints
		return
	fi

	sed_line="$(printf 's/%s[[:space:]]*//' "$grep_str")"
	echo "$require_line" | sed "$sed_line"
}

# @param $1 target name
# @param $2 absolute file path
# @param $3 is silent
__private_check_target_constraints() {
	target_name="$1"
	script_path="$2"
	is_silent="$3"
	
	constraints="$(__private_get_target_pragma 'require' "$script_path")"
	if [ -z "$constraints" ]; then
		return 0
	fi
	
	current_key=''	
	current_value=''
	unsatisfied_constraints=''
	
	for token in $constraints; do
		debug_log "constraints: check token '$token' (at: '$script_path')"
		case "$token" in
			*=*)
				current_key="$(echo "$token" | cut -d= -f1)"
				current_value="$(echo "$token" | cut -d= -f2)"
				debug_log "constraints: check key:'$current_key' value:'$current_value'"
				want_value=''
				case "$current_key" in
					'os')
						want_value="$G_OS"
						;;
					'arch')
						want_value="$G_ARCH"
						;;
					'distro')
						want_value="$G_DISTRO"
						;;
					'version' | 'distro_version')
						want_value="$G_DISTRO_VERSION"
						;;
					*)
						if [ -z "$is_silent" ]; then
							notify_warn "unknown constraint key '$current_key' in '$script_path'"
						else
							debug_log "constraints: unknown key '$current_key', skip"
						fi
						continue
						;;
				esac

				if [ "$current_value" = "$want_value" ]; then
					debug_log "constraints: satisfied: '$current_key'"
					continue
				fi

				debug_log "constraints: not sasisfied: '$current_key' ('$current_value' != '$want_value')"
				if [ -z "$is_silent" ]; then
					echo "Target '$target_name' has unsatisfied constraints: $constraints"
					echo "Current values: os=$G_OS arch=$G_ARCH distro=$G_DISTRO version=$G_DISTRO_VERSION"
					die "cannot continue due to unsatisfied target constraints"
				fi	

				return 1
				;;
			*)
				;;
		esac
	done

	return 0
}

__private_show_target() {
	target_name="$1"
	target_file="${TARGETS_DIR}/${1}${TARGET_EXT}"
	availability='True'

	if [ -z "$target_name" ]; then
		echo "Usage: $__BINNAME show <target_name>"
		die 'missing target name'
	fi

	if [ ! -f "$target_file" ]; then
		die "file '$target_file' doesn't exist. Use '$__BINNAME list' to show available targets."
		return
	fi
	
	if ! __private_check_target_constraints "$target_name" "$target_file" 1; then
		availability='False'
		notify_warn 'this target cannot be executed due to #require constraints!'
	fi

	echo "Target Name:      $target_name"
	
	description="$(__private_get_target_pragma 'description' "$target_file")"
	if [ -n "$description" ]; then
		echo "Description:      $description"
	fi

	echo "Runnable:         $availability"
	constraints="$(__private_get_target_pragma 'require' "$target_file")"
	if [ -n "$constraints" ]; then
		echo "Constraints:      $constraints"
	fi

	echo "Source File:      $target_file"
	echo "Resources Dir:    $__DIR/$target_name"

	# Dry run target to collect declarations.
	G_DRY_RUN=1
	__private_eval_target "$target_name" 1

	if [ -n "$_DOC_EXTENDS" ]; then
		echo "Dependencies:    $_DOC_EXTENDS"
	fi

	if [ -n "$_DOC_FLAGS" ]; then
		echo "Flags:"
		for val in $_DOC_FLAGS; do
			flagname="$(printf '%s' "$val" | cut -d':' -f1)"
			func_name="$(printf '%s' "$val" | cut -d':' -f2)"
			flagstr="$(pad_right "$flagname" 10)"
			echo "  --$flagstr - Runs optional '$func_name' step"
		done

		flagstr="$(pad_right 'all' 10)"
		echo "  --$flagstr - Runs flagged optional steps"
	fi 
}

__private_list_targets() {
	#__private_check_target_constraints
	unavailable_targets=''
	available_targets=''
	if [ ! -d "$TARGETS_DIR" ]; then
		echo "no targets available in '$targets_dir' directory"
		return
	fi

	for f in "$TARGETS_DIR"/*"$TARGET_EXT"; do 
		target_name="$(__private_get_target_name "$f")"
		if __private_check_target_constraints "$target_name" "$f" 1; then
			available_targets="$available_targets $target_name"
		else
			unavailable_targets="$unavailable_targets $target_name"
		fi
	done

	echo "Available targets:"
	if [ -z "$available_targets" ]; then
		echo "  No targets available in '$TARGETS_DIR' directory"
	else
		for value in $available_targets; do
			echo "  - $value"
		done
	fi

	if [ -n "$unavailable_targets" ]; then
		printf "\nTargets not available due to #require constraints:\n"
		for value in $unavailable_targets; do
			echo "  - $value"
		done
	fi
}

__private_parse_flags() {
	while [ $# -gt 0 ]; do
		case "$1" in
			--*=*)
				# Handle --flag=value format
				flag="${1%%=*}"
				value="${1#*=}"
				flag="${flag#--}"
				eval "G_FLAG_${flag}=\"${value}\""
				;;
			-*=*)
				# Handle -flag=value format
				flag="${1%%=*}"
				value="${1#*=}"
				flag="${flag#-}"
				eval "G_FLAG_${flag}=\"${value}\""
				;;
			--*)
				# Handle --flag format or --flag value format
				flag="${1#--}"
				if [ $# -gt 1 ] && [ "${2#-}" = "$2" ]; then
						# Next argument doesn't start with -, so it's a value
						eval "G_FLAG_${flag}=\"$2\""
						shift
				else
						# No value, set to 1
						eval "G_FLAG_${flag}=1"
				fi
				;;
			-*)
				# Handle -flag format or -flag value format
				flag="${1#-}"
				if [ $# -gt 1 ] && [ "${2#-}" = "$2" ]; then
						# Next argument doesn't start with -, so it's a value
						eval "G_FLAG_${flag}=\"$2\""
						shift
				else
						# No value, set to 1
						eval "G_FLAG_${flag}=1"
				fi
				;;
			*)
				# Not a recognized flag or option, store as positional argument
				positional_args="${positional_args:+$positional_args }\"$1\""
				;;
			esac
			shift
	done

	# Set positional arguments in a variable if there are any
	if [ -n "$positional_args" ]; then
		eval "G_ARGS=$positional_args"
	fi
}

# @param $1 target name
# @param $2 is silent?
__private_eval_target() {
	assert_def "$1" "empty target name (at: $CURRENT_TARGET)"
	if [ -r "$MAIN_TARGET" ]; then
		debug_log "set MAIN_TARGET='$1'"
		MAIN_TARGET="$1"
	fi

	is_silent="$2"
	new_target="$1"
	script_file="${TARGETS_DIR}/${new_target}${TARGET_EXT}"
	if [ -z "$G_DRY_RUN" ]; then
		if ! __private_check_target_constraints "$new_target" "$script_file"; then
			die 'Aborting due to unsatisfied constraints'	
		fi
	fi


	PREV_TARGET="$CURRENT_TARGET"
	CURRENT_TARGET="$new_target"
	TARGET_DIR="${__DIR}/${CURRENT_TARGET}"
	if [ ! -f "$script_file" ]; then
		die "Target file '$script_file' doesn't exist"
		return
	fi

	if [ -z "$is_silent" ]; then
		notify_step "Processing target '$CURRENT_TARGET'..."
	fi

	. "$script_file"

	# Restore env
	# FIXME: use stack to avoid undefined behavior during nesting
	CURRENT_TARGET="$PREV_TARGET"
	TARGET_DIR="${__DIR}/${CURRENT_TARGET}"
}

__private_deploy_cmd() {
	if [ -z "$1" ]; then
		opt='apply'
		if [ -n "$G_REVERT" ]; then
			opt='rollback'
		fi

		echo "Usage: $__BINNAME $opt target_name [flags]"
		die "missing target name."
	fi

	target_name="$1"
	shift

	__private_parse_flags "$@"
	__private_eval_target	"$target_name"
}

__private_main() {
	if [ -z "$1" ]; then
		__private_help
		exit 0
	fi

	__private_init_build_constraints
	cmd="$1"
	shift

	case "$cmd" in
		'apply' | 'a')
			__private_deploy_cmd "$@"
			;;
		'rollback' | 'u' | 'r')
			export G_REVERT=1
			__private_deploy_cmd "$@"
			;;
		'list' | 'ls')
			__private_list_targets "$@"
			;;
		'info' | 'i')
			export G_DRY_RUN=1
			__private_show_target "$@"
			;;
		'help' | 'h' | '')
			__private_help
			;;
		*)
			if [ -n "$cmd" ]; then
				notify_err 'unknown sub-command "$cmd"'
				echo ''
			fi

			__private_help
			exit 1
			;;
	esac
}

__private_main "$@"
