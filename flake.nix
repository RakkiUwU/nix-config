{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    nix-colors.url = "github:misterio77/nix-colors";
    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:RiscadoA/impermanence";
  };

  outputs = { ... } @ inputs:
    let lib = import ./lib { inherit inputs; };
    in {
      overlay = import ./overlays;
      nixosConfigurations = {
        rimuru = lib.mkHost {
          host = "rimuru";
          system = "x86_64-linux";
          users = [ "rakki" ];
        };
      };
    };
}
