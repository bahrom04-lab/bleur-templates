{
  pkgs ?
    let
      lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
      nixpkgs = fetchTarball {
        url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
        sha256 = lock.narHash;
      };
    in
    import nixpkgs { overlays = [ ]; },
  ...
}:
let
  # For extension
  inherit (pkgs) lib;
in
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "#name#";
  version = "#version#";

  src = lib.cleanSource ./.;

  nativeBuildInputs = with pkgs; [
    nodejs_22
    pnpm
    pnpmConfigHook
  ];

  pnpmDeps = pkgs.fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-c4uOyJ4/Pxg4EV1vxZkxBfVRj08ph7gDFwcSjjQO9lU=";
  };

  env.CI = "true";

  # Build
  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  # Install
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r dist/* $out/
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "#website#";
    description = "#description#";
    license = with licenses; [ mit ];
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ orzklv ];
  };
})
