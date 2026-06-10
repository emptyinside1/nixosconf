{
  description = "Добавляю в свой конфиг flakes и home-manager.";

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Главный источник пакетов
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Источник пакетов unstable.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    
    # Home Manager для управления пользовательским окружением
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, zen-browser, ... } @inputs:
  let
    # Переменные для удобства
    system = "x86_64-linux";
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    # Конфигурация для машины с именем "nixos"
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/desktop/default.nix  # базовый конфиг системы
        home-manager.nixosModules.home-manager
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [
            (final: prev: {
              stable = pkgs-stable;
            })
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs zen-browser; };
          home-manager.users.daniil = import ./modules/home/default.nix;
          home-manager.backupFileExtension = "backup"; 
        }

      ];
      # Unstable как дополнительный аргумент в модули.
      specialArgs = {
        inherit inputs; 
      };
    };
  };
}

