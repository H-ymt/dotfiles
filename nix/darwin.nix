# Phase 0: 何も管理しない空の nix-darwin 設定。
#
# パッケージ・dotfiles はすべて mise.toml が管理し続ける。ここに移してよいのは
# 「同じコミットで mise.toml 側から消したもの」だけ（Ownership 衝突の回避）。
# 移行計画は https://github.com/H-ymt/dotfiles/issues/1 を参照。
{ username, ... }:

{
  # Determinate Nix installer が /nix と nix-daemon を所有する。
  # これを true にすると nix-darwin 側の nix.* 管理が自動で無効化される。
  determinateNix.enable = true;

  # 「darwin-rebuild を実行したユーザー」に暗黙適用されていたオプションの帰属先。
  # nix-darwin のオプション再編に伴う過渡的な仕組みで、将来的に不要になる。
  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # nix-darwin が後方互換性の判断に使う値。新規構成なので現行値 (7) から始める。
  # 一度決めたら上げない（上げると stateful data と defaults の互換が崩れる）。
  system.stateVersion = 7;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit username; };
    users.${username} = import ./home.nix;
  };
}
