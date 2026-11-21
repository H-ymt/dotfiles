# Phase 0: 何も管理しない空の nix-darwin 設定。
#
# パッケージ・dotfiles はすべて mise.toml が管理し続ける。ここに移してよいのは
# 「同じコミットで mise.toml 側から消したもの」だけ（Ownership 衝突の回避）。
# 移行計画は https://github.com/H-ymt/dotfiles/issues/1 を参照。
{ username, pkgsUnstable, inputs, ... }:

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
    extraSpecialArgs = { inherit username pkgsUnstable inputs; };
    users.${username} = import ./home.nix;

    # 既存の実ファイル（mise 由来の symlink や各ツールが自動追記した .zshenv/.zprofile 等）と
    # home-manager 生成物が衝突したとき、abort せず .hm-bak へ退避してから上書きする。
    # Phase 4 の dotfiles ownership 移管を安全に行うために必要。
    backupFileExtension = "hm-bak";
  };

  homebrew = {
    enable = true;

    # cleanup = "none": 宣言外の cask/formula には触らない（デフォルト）。
    # 宣言漏れが即 uninstall される事故を防ぐため、当面は none で運用する。
    onActivation = {
      cleanup = "none";
      autoUpdate = false; # 更新は明示的に。activation のたびに brew update を走らせない
      upgrade = false; # 既存 cask を勝手に upgrade しない
    };

    # サードパーティ tap。homebrew/cask 本体に入っているものは宣言不要。
    taps = [
      "fayazara/tap" # screendrop
    ];

    casks = [
      # --- エディタ / ターミナル ---
      "cursor"
      "antigravity"
      "ghostty"

      # --- AI CLI / ツール ---
      "claude"
      "codex"

      # --- 生産性 / コミュニケーション ---
      "obsidian"
      "slack"
      "microsoft-teams" # 手動枠だった（pkg installer 形式）
      "figma"
      "linear"
      "raycast"

      # --- 開発基盤 ---
      "orbstack"

      # --- ユーティリティ ---
      "dockdoor"
      "karabiner-elements"
      "macwinzipper"
      "zipic"
      "thaw"
      "logi-options+" # 手動枠だった（pkg installer 形式）
      "adobe-creative-cloud" # 手動枠だった（pkg installer 形式）
      "fayazara/tap/screendrop"

      # --- フォント（homebrew/cask 本体に統合済み。追加 tap は不要）---
      "font-ibm-plex-mono"
      "font-plemol-jp"
      "font-plemol-jp-nf"
    ];
  };
}
