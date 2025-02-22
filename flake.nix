{
  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/develop";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";  # IMPORTANT!!!
    blueprint = {
      url = "github:numtide/blueprint";
      inputs.nixpkgs.follows = "nix-ros-overlay/nixpkgs";
    };
  };
  outputs = inputs: inputs.blueprint {
    inherit inputs;
    prefix = "./nix";
    nixpkgs.overlays = [
      inputs.nix-ros-overlay.overlays.default
    ];
  };
  # nixConfig = {
  #   substituters = [ "https://ros.cachix.org" ];
  #   trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  # };
}
