# Phase 1: 純粋な単体 CLI を home.packages で管理する。
# Phase 3: dotfiles を xdg.configFile で管理する。
#
# home.packages に追加したものは同じコミットで mise.toml の [bootstrap.packages] から、
# xdg.configFile に追加したものは同じコミットで mise.toml の [dotfiles] から削除する
# （同じものを Homebrew/mise と Nix の両方が管理すると衝突する）。
#
# Phase 4 で programs.* が入る。
# 移行計画は https://github.com/H-ymt/dotfiles/issues/1 を参照。
{ config, pkgs, username, ... }:

let
  # dotfiles リポジトリの絶対パス。out-of-store symlink の参照先に使う。
  dotfiles = "/Users/${username}/ghq/github.com/H-ymt/dotfiles";
in
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # home-manager が後方互換性の判断に使う値。一度決めたら上げない。
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # --- シェル / プロンプト ---
    bash
    sheldon
    starship
    atuin
    zoxide
    fzf

    # --- ファイル操作・検索 ---
    bat
    eza
    fd
    tree
    treemd
    yazi
    _7zz # Homebrew: sevenzip

    # --- Git ---
    gh
    ghq
    glab
    delta # Homebrew: git-delta
    git-filter-repo
    lazygit
    lefthook

    # --- エディタ ---
    neovim

    # --- データ変換・メディア ---
    jq
    pandoc
    # Homebrew の poppler は pdftotext 等のコマンド群を含むが、nixpkgs の
    # poppler はライブラリのみ。コマンドは poppler_utils 側にある
    poppler-utils
    ffmpeg

    # --- クラウド / SaaS CLI ---
    wrangler # Homebrew: cloudflare-wrangler
    supabase-cli # Homebrew: supabase
    shopify-cli
    # nixpkgs の `turso` は別物（ローカル SQL シェル tursodb）。
    # Homebrew の tursodatabase/tap/turso に相当するのは turso-cli
    turso-cli
    infisical
    gdrive
    wp-cli

    # --- その他 ---
    btop
    killport
    uv
    mo
  ];

  # Phase 3: dotfiles を xdg.configFile で管理する。
  #
  # 方式の使い分け:
  # - 実行時に書き換えられないファイル → source（Nix store 経由・宣言的）。
  #   編集は git add + darwin-rebuild switch で反映される。
  # - プログラム/GUI が自分で書き換えるファイル → mkOutOfStoreSymlink。
  #   リポジトリ内の実ファイルへ symlink するので書き込みが通り、編集も即反映。
  xdg.configFile = {
    # --- store 経由（書き込みなし）---
    "ghostty" = {
      source = ../.config/ghostty;
      recursive = true;
    };
    "wezterm" = {
      source = ../.config/wezterm;
      recursive = true;
    };
    "bat" = {
      source = ../.config/bat;
      recursive = true;
    };
    "yazi" = {
      source = ../.config/yazi;
      recursive = true;
    };
    "starship.toml".source = ../.config/starship.toml;

    # --- out-of-store（書き込みあり）---
    # LazyVim が lazy-lock.json / lazyvim.json を実行時に書き換えるため store には置けない。
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nvim";
    # Karabiner-Elements の GUI が karabiner.json を書き換える（automatic_backups / assets も生成）。
    "karabiner/karabiner.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/karabiner/karabiner.json";
  };
}
