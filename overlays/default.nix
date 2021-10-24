{ ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      wlroots = prev.wlroots.overrideAttrs(old: {
        postPatch = ''
          sed -i 's/assert(argb8888 &&/assert(true || argb8888 ||/g' 'render/wlr_renderer.c'
        '';
      });
    })
  ];
}
