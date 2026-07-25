# Phase 0: 何も管理しない空の home-manager 設定。
#
# Phase 1 で home.packages、Phase 3 で xdg.configFile、Phase 4 で programs.* が入る。
# 追加時は必ず mise.toml の対応エントリを同じコミットで削除する。
{ username, ... }:

{
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # home-manager が後方互換性の判断に使う値。一度決めたら上げない。
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
