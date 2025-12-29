# Nix Adoption Plan

This plan outlines a gradual migration from stow-based dotfiles to a single
Nix flake that supports home-manager, NixOS, and nix-darwin.

## Roadmap

### Phase 0: Inventory and carve-out
- Identify what is "dotfiles" vs "system state" (udev rules, services, kernel params).
- Split into:
  - Cross-platform user config.
  - OS-specific user config.
  - System-level config.

### Phase 1: Introduce Nix without changing behavior
- Install Nix on Arch/macOS/termux.
- Create a minimal flake with home-manager only.
- Mirror existing dotfiles via home-manager.
- Keep stow for anything not yet migrated.

### Phase 2: Migrate user packages and dotfiles
- Move package lists into home-manager `home.packages`.
- Migrate shell/editor/tmux/git configs into home-manager modules.
- Keep stow as a fallback during migration.

### Phase 3: Add system modules
- Linux: add modules for udev rules, sysctl, systemd services.
- macOS: add nix-darwin modules for defaults and launchd.
- Keep system-specific bits in small, host-focused modules.

### Phase 4: Optional NixOS conversion
- Convert one Linux machine to NixOS.
- Reuse the home-manager config inside NixOS.
- Keep repo structure consistent across hosts.

### Phase 5: Termux
- Use home-manager where possible (dotfiles + packages).
- Keep termux-specific constraints in a separate module.

## Repository layout (suggested)

- `flake.nix`
- `home/` shared home-manager modules
- `home/hosts/` per-host home overrides
- `nixos/` NixOS modules
- `darwin/` nix-darwin modules
- `hosts/` per-host system definitions
- `lib/` helpers (optional)

## Universal flake skeleton

```nix
{
  description = "Universal dotfiles: NixOS + nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, home-manager, darwin, ... }:
  let
    mkPkgs = system: import nixpkgs { inherit system; config.allowUnfree = true; };
    mkDarwinPkgs = system: import nixpkgs-darwin { inherit system; config.allowUnfree = true; };

    hmModules = [
      ./home/common.nix
    ];

    mkHome = { system, username, host ? null, extraModules ? [ ] }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs system;
        modules = hmModules
          ++ extraModules
          ++ (if host != null then [ ./home/hosts/${host}.nix ] else [ ]);
        extraSpecialArgs = { inherit username host; };
      };
  in {
    nixosConfigurations = {
      arch-laptop-1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/common.nix
          ./hosts/arch-laptop-1.nix
          home-manager.nixosModules.home-manager
          { home-manager.users.user = import ./home/hosts/arch-laptop-1.nix; }
        ];
        specialArgs = { host = "arch-laptop-1"; };
      };
    };

    darwinConfigurations = {
      macbook-1 = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin/common.nix
          ./hosts/macbook-1.nix
          home-manager.darwinModules.home-manager
          { home-manager.users.user = import ./home/hosts/macbook-1.nix; }
        ];
        specialArgs = { host = "macbook-1"; };
      };
    };

    homeConfigurations = {
      "user@arch-laptop-2" = mkHome {
        system = "x86_64-linux";
        username = "user";
        host = "arch-laptop-2";
      };

      "user@termux" = mkHome {
        system = "aarch64-linux";
        username = "user";
        host = "termux";
        extraModules = [ ./home/termux.nix ];
      };
    };
  };
}
```
