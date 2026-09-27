{
  description = "H-ymt macOS 基盤層 (nix-darwin + home-manager)";

  # FlakeHub の URL は Determinate 公式ガイドの推奨。末尾の数字はメジャーバージョン制約で、
  # 実際に固定されるバージョンは flake.lock 側が持つ。
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";

    # 安定版に未収録・古すぎるパッケージだけを個別に取るための unstable（0.1 = nixos-unstable）。
    # 使う側は pkgsUnstable.<name> で明示し、基本は安定版の pkgs を使う。
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

    nix-darwin.url = "https://flakehub.com/f/nix-darwin/nix-darwin/0";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "https://flakehub.com/f/nix-community/home-manager/0";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Determinate Nix installer で入れた Nix を nix-darwin に奪わせないためのモジュール。
    # determinateNix.enable = true が nix-darwin 側の nix.* 管理を自動で無効化する
    # （nix.enable = false を別途書く必要はない）。
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, nix-darwin, home-manager, determinate }:
    let
      # ホスト名 (YamatonoMacBook-Air) ではなく機種非依存の識別子を使う。
      # darwin-rebuild switch --flake .#mba で明示的に指定して切り替える。
      hostName = "mba";
      system = "aarch64-darwin";
      username = "yamato_handai";
    in
    {
      darwinConfigurations.${hostName} = nix-darwin.lib.darwinSystem {
        modules = [
          determinate.darwinModules.default
          home-manager.darwinModules.home-manager
          ./nix/darwin.nix
          {
            _module.args = {
              inherit username;
              pkgsUnstable = nixpkgs-unstable.legacyPackages.${system};
            };
            nixpkgs.hostPlatform = system;
          }
        ];
      };

      # `nix fmt` 用。Phase 1 以降で nix ファイルが増えるため今のうちに用意する。
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
