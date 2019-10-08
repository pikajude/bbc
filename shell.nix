{ compiler ? "ghc8_6" }:

let reflexpkgs = import (fetchTarball https://github.com/reflex-frp/reflex-platform/tarball/develop) {};

in

with reflexpkgs;
with nixpkgs;

reflexpkgs."${compiler}".developPackage {
  root = ./.;
  modifier = drv: haskell.lib.addBuildTool drv
    (generalDevToolsAttrs ghc8_6).haskell-ide-engine;
  overrides = self: super: {
    ${if compiler == "ghcjs" then null else "reflex-dom"} = haskell.lib.addBuildDepend
      (haskell.lib.enableCabalFlag super.reflex-dom "use-warp")
      self.jsaddle-warp;
    ${if compiler == "ghcjs" then "hpack" else null} = null;
  };
}
