# NOTE: based on https://github.com/gleachkr/nix-tools/blob/main/kani/default.nix
{
  lib,
  rust-overlay,
  fetchFromGitHub,
  glibc,
  extend,
  system,
  rsync,
  makeWrapper,
  stdenv,
  autoPatchelfHook,
}: let
  version = "0.63.0";

  rustPkgs = extend (import rust-overlay);

  # Rust toolchain as specified in `$KANI_HOME/rust-toolchain-version`
  rustHome = rustPkgs.rust-bin.nightly."2025-06-03".default.override {
    extensions = ["rustc-dev" "rust-src" "llvm-tools" "rustfmt"];
  };

  rustPlatform = rustPkgs.makeRustPlatform {
    cargo = rustHome;
    rustc = rustHome;
  };

  releases = {
    x86_64-linux = builtins.fetchTarball {
      url = "https://github.com/model-checking/kani/releases/download/kani-${version}/kani-${version}-x86_64-unknown-linux-gnu.tar.gz";
      sha256 = "0c4lyh005qj6bp7cm07ic34hbyvin86kd41x2bkdw721ssv5wwpx";
    };
    aarch64-linux = builtins.fetchTarball {
      url = "https://github.com/model-checking/kani/releases/download/kani-${version}/kani-${version}-aarch64-unknown-linux-gnu.tar.gz";
      sha256 = "117rpkdpcfp3ckryl0i4d86yj2q5dm4r7jsnsn191089f05y67pc";
    };
    x86_64-darwin = builtins.fetchTarball {
      url = "https://github.com/model-checking/kani/releases/download/kani-${version}/kani-${version}-x86_64-apple-darwin.tar.gz";
      sha256 = "08h395k6a48xjmb15gifj9ng0a68qy30y8ngkysz13a86b7i14mg";
    };
    aarch64-darwin = builtins.fetchTarball {
      url = "https://github.com/model-checking/kani/releases/download/kani-${version}/kani-${version}-aarch64-apple-darwin.tar.gz";
      sha256 = "1x0djj9kxhxyiqby452sz8w8bkyvxz77j9cvl3fa9knwlwlabr12";
    };
  };

  kani-home = stdenv.mkDerivation {
    name = "kani-home";

    src = releases.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

    buildInputs = [
      stdenv.cc.cc.lib # libs needed by patchelf
    ];

    runtimeDependencies = [
      glibc # not detected as missing by patchelf for some reason
    ];

    nativeBuildInputs = [autoPatchelfHook];

    installPhase = ''
      runHook preInstall
      ${rsync}/bin/rsync -av $src/ $out --exclude kani-compiler --exclude kani-driver
      runHook postInstall
    '';
  };
in
  rustPlatform.buildRustPackage {
    pname = "kani";

    inherit version;

    src = fetchFromGitHub {
      owner = "model-checking";
      repo = "kani";
      rev = "kani-${version}";
      hash = "sha256-SCiptYoUPSw9tIEzl+htqD8KDBbL4wNLrv38BSlpJmY=";
      fetchSubmodules = true;
    };

    cargoPatches = [
      ./deduplicate-tracing-tree.patch
    ];

    nativeBuildInputs = [makeWrapper];

    postInstall = ''
      mkdir -p $out/lib/
      ${rsync}/bin/rsync -av ${kani-home}/ $out/lib/kani-${version} --perms --chmod=D+rw,F+rw
      cp $out/bin/* $out/lib/kani-${version}/bin/
      ln -s ${rustHome} $out/lib/kani-${version}/toolchain
    '';

    postFixup = ''
      wrapProgram $out/bin/kani --set KANI_HOME $out/lib/
      wrapProgram $out/bin/cargo-kani --set KANI_HOME $out/lib/
    '';

    cargoHash = "sha256-DeDvhzQuTyklpneGFqa7iYdhcRBRV8+6BgiD1/bWQ7Y=";

    env = {
      RUSTUP_HOME = "${rustHome}";
      RUSTUP_TOOLCHAIN = "..";
    };

    meta = {
      description = "Kani Rust Verifier ";
      homepage = "https://model-checking.github.io/kani/";
      license = with lib.licenses; [
        mit
        asl20
      ];
      meta.platforms = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      maintainers = with lib.maintainers; [chrjabs];
      mainProgram = "kani";
    };
  }
