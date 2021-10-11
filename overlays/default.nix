{ ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      /*
      # wlroots fork with nvidia proprietary driver support
      wlroots = prev.wlroots.overrideAttrs (oldAttrs: rec {
        src = prev.fetchFromGitHub {
          owner = "danvd";
          repo = "wlroots-eglstreams";
          rev = "225adced7c3c66de3dde95068111c5e982dd9d78";
          sha256 = "sha256-0DhREZcCbu5lDbaQrNFQwkcw0AgZdYPEfo/U2E6XQK8=";
        };
      });
      */
    })
  ];
}
