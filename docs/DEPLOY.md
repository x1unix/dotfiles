# How the Deploy Script Works

The `deploy.sh` script is a tool for managing and deploying dotfiles and system configurations across different environments. It uses a "target-based" system, where each target represents a specific configuration set for a machine or operating system (e.g., `darwin` for macOS, `arch` for Arch Linux).

## What is a Target?

A target is a directory that contains all the necessary files and a special recipe file named `target.sh`. This recipe file defines the steps required to set up a particular environment.

For example, the `darwin` target has the following structure:

```
darwin/
├── Brewfile
├── target.sh
└── config/
    └── ...
```

*   `target.sh`: The recipe file containing the deployment steps. This file also declares metadata via comment directives such as `#description`, `#require`, and `#variants`.
*   Other files (`Brewfile`, `config/`): Resources used by the recipe, like package lists or configuration files to be symlinked.

## The `target.sh` Recipe File

The `target.sh` file is the core of a target. It's a shell script that calls a series of predefined functions to perform actions. This creates a declarative, "no-code-like" format for defining a deployment process.

These functions, or commands, are provided by the main `deploy.sh` script. For a complete list of all available commands and how to use them, please see the [**Commands Reference**](./COMMANDS.md).

A simple `target.sh` might look like this:

```shell
# description: My macOS setup
# require: os=darwin
# variants: laptop|desktop

# Include the 'common' target which has shared configs
require "common"

# Define a function for an optional step
install_packages() {
  brewfile "Brewfile"
}

# Create a step that can be run with '--pkgs'
step install_packages flag:pkgs
```

### Declaring Parameters

Targets can declare typed input parameters that are passed through long flags (for example, `./deploy.sh apply darwin --hostname mini`). Parameters are declared with the [`param`](./COMMANDS.md#param) command and accessed later via `get_param`/`has_param`. This allows a recipe to request user input (such as hostnames, API tokens, or layout selections) in a consistent and documented way. Parameter documentation is surfaced automatically in `deploy.sh info <target>`.

## Target Variants

Targets can offer multiple variants that tweak behavior without duplicating whole recipes. Declare supported variants in `target.sh` via the `#variants:` pragma:

```shell
#variants: desktop|laptop|server
```

Run a particular variant by appending `#<variant>` to the target when calling the CLI, e.g. `./deploy.sh apply arch#desktop`. Inside a recipe you can detect the currently selected variant with the `current_variant` helper and branch logic accordingly (for example, rendering template values based on the variant). Targets that declare variants cannot be applied without providing a variant name—`./deploy.sh apply arch` would fail if `arch/target.sh` contains `#variants`.

Targets can also collect typed inputs in addition to variant selection through the [`param`](./COMMANDS.md#param) command. Parameters appear as long flags when running `apply`/`rollback`, so you can combine both concepts: `./deploy.sh apply arch#desktop --hostname=mini`.

Variant-aware targets can provide per-variant hooks by defining functions named `variant_<target>_<variant>`. These functions run automatically when the matching variant is selected. Optional rollback logic follows the same naming scheme with a `_rollback` suffix.

```shell
# variants declared at the top of target.sh
#variants: desktop|laptop|server

# Runs only for `arch#desktop`
variant_arch_desktop() {
  # setup desktop extras
}

# Revert logic for the desktop variant
variant_arch_desktop_rollback() {
  # undo desktop extras
}

# Runs only for `arch#server`
variant_arch_server() {
  # setup server-specific bits
}
```

## Using the `deploy.sh` Script

The script is straightforward to use. Here are the main commands:

### `list`

Lists all available targets and shows which ones are runnable on the current system based on their constraints.

**Example Output:**

```
$ ./deploy.sh list
Available targets:
  - common
  - darwin

Targets not available due to #require constraints:
  - arch
  - mbp-arch
  - termux
```

### `info`

Shows detailed information about a specific target, including its description, constraints, dependencies, and any optional flags it accepts.

**Example Output:**

```
$ ./deploy.sh info darwin
Target Name:      darwin
Description:      dotfiles and packages for macOS machines
Variants:         laptop desktop
Runnable:         True
Constraints:      os=darwin
Source File:      darwin/target.sh
Resources Dir:    /Users/x1unix/dotfiles/darwin
Dependencies:     common
Flags:
  --pkgs       - Runs optional 'darwin_brew_install' step
  --all        - Runs flagged optional steps
```

### `apply`

Applies a target's configuration. This executes the `target.sh` recipe file for the specified target.

**Usage:**

```shell
# Apply the 'darwin' target
./deploy.sh apply darwin

# Apply the 'arch' target using the 'desktop' variant
./deploy.sh apply arch#desktop

# Apply the 'darwin' target and run the optional 'pkgs' step
./deploy.sh apply darwin --pkgs

# Apply a target, selecting a variant and supplying a parameter
./deploy.sh apply target_name#variant --your_param_name=value
```

### `rollback`

Reverts the actions taken by the `apply` command. This is useful for uninstalling or removing symlinks.

**Usage:**

```shell
./deploy.sh rollback darwin
```
