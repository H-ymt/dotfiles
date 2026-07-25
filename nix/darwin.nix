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

  # Phase 2: GUI アプリ（cask）を nix-darwin から宣言的に管理する。
  # Homebrew バイナリ自体は Nix が所有せず、activation 時に既存の brew で
  # `brew bundle` を走らせる仕組み。formula は Nix 未収録の 4 件のみ mise.toml に残す。
  homebrew = {
    enable = true;

    # cleanup = "none": 宣言外の cask/formula には触らない（デフォルト）。
    # 宣言漏れが即 uninstall される事故を防ぐため、当面は none で運用する。
    onActivation = {
      cleanup = "none";
      autoUpdate = false; # 更新は明示的に。activation のたびに brew update を走らせない
      upgrade = false; # 既存 cask を勝手に upgrade しない
    };

    casks = [
      # --- エディタ / ターミナル ---
      "cursor"
      "visual-studio-code"
      "zed"
      "ghostty"
      "wezterm"

      # --- AI CLI / ツール ---
      "claude"
      "codex"
      "copilot-cli"

      # --- 生産性 / コミュニケーション ---
      "notion"
      "obsidian"
      "slack"
      "linear" # 旧 linear-linear は同一 cask の別名。正式 token は linear
      "microsoft-teams" # 手動枠だった（pkg installer 形式）
      "figma"
      "raycast"

      # --- 開発基盤 ---
      "orbstack"
      "ngrok" # 手動枠だった（postflight_steps を使用）
      "local"

      # --- ユーティリティ ---
      "dockdoor"
      "keycastr"
      "karabiner-elements"
      "macwinzipper"
      "zipic"
      "thaw"
      "logi-options+" # 手動枠だった（pkg installer 形式）
      "adobe-creative-cloud" # 手動枠だった（pkg installer 形式）

      # --- フォント（homebrew/cask 本体に統合済み。追加 tap は不要）---
      "font-ibm-plex-mono"
      "font-plemol-jp"
      "font-plemol-jp-nf"
    ];
  };
}
