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

These commands help manage system packages on different operating systems.

### `pacmanfile`

Installs packages on Arch Linux using `pacman` from a list in a file.

**Usage:** `pacmanfile <filename>`
**Parameters:**
*   `filename`: Path to a file within the target directory containing a space-separated list of packages to install.

### `aurpkg`

Installs packages from the Arch User Repository (AUR) on Arch Linux.

**Usage:** `aurpkg <package_name> [another_package...]`
**Parameters:**
*   `package_name`: One or more AUR package names to install.

### `brewfile`

Installs packages on macOS using Homebrew from a `Brewfile`.

**Usage:** `brewfile <filename>`
**Parameters:**
*   `filename`: Path to a Brewfile within the target directory.

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
