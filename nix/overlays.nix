let
  nix-community-infra = pkgs: rec {
    inherit (pkgs)
      git-crypt
      niv
      sops
      rsync
      sources;
    inherit (pkgs.python3.pkgs) invoke;

    terraform = pkgs.terraform.withPlugins (
      p: [
        p.cloudflare
        p.null
        p.external
      ]
    );
  };

in
[
  (self: super: { sources = import ./sources.nix; })
  (self: super: { cachix = import super.sources.cachix {}; })
  (self: super: { nix-community-infra = nix-community-infra super; })
  (self: super: (import "${super.sources.hercules-ci-effects}/overlay.nix") self super)
]
