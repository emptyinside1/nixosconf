{
  description = "Добавляю в свой конфиг flakes и home-manager.";

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
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, zen-browser, ... } @inputs:
  let
    # Переменные для удобства
    system = "x86_64-linux";
    pkgs-stable = nixpkgs-stable.legacyPackages.${system};
  in
  {
    # Конфигурация для машины с именем "nixos"
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix  # базовый конфиг системы
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit pkgs-stable inputs zen-browser; };
          home-manager.users.daniil = import ./home.nix;
        }

      ];
      # Unstable как дополнительный аргумент в модули.
      specialArgs = {
        inherit pkgs-stable; 
      };
    };
  };
}

