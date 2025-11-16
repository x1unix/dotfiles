# Dotfiles Deploy Script Commands

This document outlines the public functions (commands) available for use within `target.sh` recipe files. These commands are provided by the main `deploy.sh` script to perform common setup tasks in a declarative, no-code-like format.

## Core Commands

These are the main commands for controlling the flow and structure of a recipe.

### `step`

Defines a step in the deployment process. A step is typically a shell function defined within the same `target.sh` file. Steps can also be made optional and executed only when a specific command-line flag is provided.

**Usage:**

1.  **Standard Step:**
```shell
step <function_name>
```
This runs the specified function unconditionally.

2.  **Flag-based Step:**
    ```shell
    step <function_name> flag:<flag_name>
    ```
    This makes the step optional. It will only run if the user executes the deploy script with the `--<flag_name>` or `--all` flag.

**Parameters:**

*   `function_name`: The name of the shell function to execute.
*   `flag:<flag_name>`: (Optional) A binding that ties the step to a command-line flag.

**Example:**

```shell
# This function will be a step
install_apps() {
  pacmanfile "packages.list"
}

# This function is an optional step
install_extra_apps() {
  aurpkg "google-chrome"
}

# This step always runs
step install_apps

# This step only runs with 'deploy apply <target> --extra'
step install_extra_apps flag:extra
```

When `./deploy.sh rollback ...` runs, the framework looks for a sibling function named `<function_name>_rollback`. If present, that rollback function is executed to undo the step:

```shell
install_apps() {
  # install logic
}

install_apps_rollback() {
  # uninstall logic
}

step install_apps
```

### `require`

Includes one or more other target recipes into the current one. This is useful for composing configurations from shared, common recipes.

**Usage:**

```shell
require <target_name> [another_target...]
```

**Parameters:**

*   `target_name`: The name of another target directory to include.

**Example:**

```shell
# This will first execute the 'common/target.sh' recipe
require "common"

# ... rest of the current target's steps
```

## Symlinking (Stow Wrappers)

These commands use `stow` to create symlinks from files in your target directory to various locations on the system.

### `link_dot`

Symlinks a package's contents as dotfiles in the user's home directory (`$HOME`).

**Usage:** `link_dot <package_name>`
**Parameters:**
*   `package_name`: The name of the directory within the current target to link from.

### `link_home`

Symlinks a package's contents into the user's home directory (`$HOME`) or a subdirectory within it.

**Usage:**
*   `link_home <package_name>` (links to `$HOME`)
*   `link_home <subdir> <package_name>` (links to `$HOME/<subdir>`)

**Parameters:**
*   `package_name`: The name of the directory within the current target to link from.
*   `subdir`: (Optional) The subdirectory under `$HOME` to link into.

### `link_local_bin`

Symlinks a package's contents into `$HOME/.local/bin`.

**Usage:** `link_local_bin <package_name>`
**Parameters:**
*   `package_name`: The name of the directory (e.g., `bin`) to link from.

### `link_xdg_config`

Symlinks a package into the XDG config directory (`$XDG_CONFIG_HOME`, typically `~/.config`).

**Usage:** `link_xdg_config <package_name>`
**Parameters:**
*   `package_name`: The name of the directory to link (e.g., `nvim`, `alacritty`).

### `link_xdg_data`

Symlinks a package into the XDG data directory (`$XDG_DATA_HOME`, typically `~/.local/share`).

**Usage:** `link_xdg_data <package_name>`
**Parameters:**
*   `package_name`: The name of the directory to link.

### `link_xdg_state`

Symlinks a package into the XDG state directory (`$XDG_STATE_HOME`, typically `~/.local/state`).

**Usage:** `link_xdg_state <package_name>`
**Parameters:**
*   `package_name`: The name of the directory to link.

## Package Management

Commands below are grouped by the platform(s) where they work. Each command reads package names from either arguments or files in the target directory.

### Arch Linux / pacman-based distros

#### `pacmanfile`

Installs packages using `pacman` from a list in a file.

**Usage:** `pacmanfile <filename>`
**Parameters:**
*   `filename`: Path to a file within the target directory containing a space-separated list of packages to install.

#### `aurpkg`

Builds one or more AUR packages manually using `git` + `makepkg`, without relying on a helper. This is primarily used to bootstrap an AUR helper that `aurfile` can later use.

**Usage:** `aurpkg <package_name> [another_package...]`
**Parameters:**
*   `package_name`: One or more AUR package names to build/install directly.

#### `aurfile`

Installs AUR packages listed in a file using the detected helper (install one via `aurpkg` if needed).

**Usage:** `aurfile <filename>`
**Parameters:**
*   `filename`: Path to a file within the target directory; blank lines and comments (`# ...`) are ignored and the remaining package names are installed via the helper. Rollback is not supported.

### macOS (Homebrew)

#### `brewfile`

Installs packages on macOS using Homebrew from a `Brewfile`.

**Usage:** `brewfile <filename>`
**Parameters:**
*   `filename`: Path to a Brewfile within the target directory.

### Debian/Ubuntu and Termux (APT/pkg)

#### `aptfile`

Installs packages on Debian/Ubuntu-based systems using `apt-get` from a list in a file. On Android (Termux), it uses `pkg` instead.

**Usage:** `aptfile <filename>`
**Parameters:**
*   `filename`: Path to a file within the target directory containing a space-separated list of packages to install.

## File Operations

### `sops_decrypt`

Decrypts a file encrypted with SOPS (Secrets OPerationS).

**Usage:** `sops_decrypt <source_file.enc> <destination_path>`
**Parameters:**
*   `source_file.enc`: The path to the encrypted file, relative to the target directory.
*   `destination_path`: The absolute path where the decrypted file will be saved.

### `file_append_once`

Appends a given line of text to a file, but only if the line does not already exist in the file.

**Usage:** `file_append_once <file_path> <text_to_append>`
**Parameters:**
*   `file_path`: The absolute path to the file.
*   `text_to_append`: The line of text to add.

### `ssh_config_include`

A specialized wrapper around `file_append_once` to add an `Include` directive to the user's SSH configuration (`~/.ssh/config`).

**Usage:** `ssh_config_include <path_to_ssh_config>`
**Parameters:**
*   `path_to_ssh_config`: The absolute path to the SSH configuration file you want to include.

## Parameters

Targets can declare and consume structured input parameters. Parameters are exposed as CLI flags (`--<name>`) during `apply`/`rollback`, documented via `deploy.sh info`, and evaluated in recipes using the helpers below.

### `param`

Declares a parameter with optional metadata.

**Usage:**
```shell
param <name> [description:<text>] [required:1] [default:<value>] [validate:<regex>]
```

**Options:**
* `description:<text>` – Shown in `deploy.sh info` output.
* `required:<any>` – Fails execution when the flag is missing (the value itself is ignored, but the `:value` suffix is required).
* `default:<value>` – Default value when the flag is not passed.
* `validate:<regex>` – Regular expression (without outer slashes) to validate user input.

**Example:**
```shell
param hostname description:"Target hostname" required:1 validate:'[a-z0-9-]+'
```

### `get_param`

Returns the value of a previously declared parameter.

**Usage:** `get_param <name>`

**Example:**
```shell
deploy_host="$(get_param hostname)"
```

### `has_param`

Returns success (exit code 0) when a value was supplied for a parameter, even if it is optional.

**Usage:** `has_param <name>`

**Example:**
```shell
if has_param monitor_layout; then
  configure_monitors "$(get_param monitor_layout)"
fi
```

## Template Generation

### `expand_template`

Renders a template file by replacing `{{KEY}}` placeholders with provided key-value pairs. On rollback (`./deploy.sh rollback ...`) the generated file is removed automatically.

**Usage:**
```shell
expand_template <source_template> <destination_path> [key=value ...]
```

**Parameters:**
* `source_template`: Path to the template file relative to the target directory.
* `destination_path`: Absolute path for the rendered file.
* `key=value`: One or more replacement pairs; nested braces are not supported.

**Example:**
```shell
expand_template \
  'templates/hyprland-vars.conf' \
  "$XDG_CONFIG_HOME/hypr/hyprland.d/platform.conf" \
  "target=$(current_variant)" \
  "hostname=$(get_param hostname)"
```

## Context Helpers

### `current_target`

Returns the name of the target whose `target.sh` is currently executing. Helpful for logging or building target-relative paths.

### `current_variant`

Returns the selected variant (if any) for the current target. Use this to branch logic or feed values into templates when the target supports the `#variants:` pragma.
