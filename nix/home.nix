# Phase 1: 純粋な単体 CLI を home.packages で管理する。
#
# ここに追加したものは同じコミットで mise.toml の [bootstrap.packages] から削除する
# （同じツールを Homebrew と Nix の両方が管理すると PATH が衝突する）。
#
# Phase 3 で xdg.configFile、Phase 4 で programs.* が入る。
# 移行計画は https://github.com/H-ymt/dotfiles/issues/1 を参照。
{ pkgs, username, ... }:

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
}
