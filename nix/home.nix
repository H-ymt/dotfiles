# Phase 1: 純粋な単体 CLI を home.packages で管理する。
# Phase 3: dotfiles を xdg.configFile で管理する。
# Phase 4: 宣言的に生成できる設定を programs.* へ移す（starship / git / zsh）。
#
# home.packages に追加したものは同じコミットで mise.toml の [bootstrap.packages] から、
# xdg.configFile / programs.* に追加したものは同じコミットで mise.toml の
# [dotfiles] から削除する（同じものを Homebrew/mise と Nix の両方が管理すると衝突する）。
#
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
    # starship は programs.starship.enable が導入する（Phase 4）
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
    # delta は programs.git.delta.enable が導入する（Phase 4）
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
    # starship.toml は Phase 4 で programs.starship.settings へ移した。

    # --- out-of-store（書き込みあり）---
    # LazyVim が lazy-lock.json / lazyvim.json を実行時に書き換えるため store には置けない。
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nvim";
    # Karabiner-Elements の GUI が karabiner.json を書き換える（automatic_backups / assets も生成）。
    "karabiner/karabiner.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/karabiner/karabiner.json";
  };

  # Phase 4: 宣言的に生成できる設定を programs.* へ移す。
  #
  # verbatim 配置（xdg.configFile / mise [dotfiles]）との違い:
  # programs.* は Nix の型付きオプションから設定ファイルを *生成* する。
  # TOML/ini を手書きする代わりに Nix の attrset で書けるので、他の値（username 等）
  # と組み合わせた宣言ができる。生成物は store 経由なので実体は read-only。

  # starship.toml を 1:1 で移植。format 文字列とセグメント設定はそのまま。
  # enableZshIntegration は false にして init を programs.zsh 側の initContent が
  # 持つ eval 行に任せる（既存 .zshrc の実行順序を変えないため）。
  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      # 元の starship.toml は """...""" 内で行末 \ を継続に使い全セグメントを 1 行に連結し、
      # 最後の $character だけ改行の後に置いていた。
      # home-manager の TOML 生成器は改行入り文字列も basic string の \n エスケープで書き出し、
      # starship のパーサは format 内の \n を escaped_char エラーで拒否する。
      # そこで改行は starship 組込みの $line_break 変数で表現する（生成 TOML の表記に依存せず
      # starship が確実に改行と解釈する）。見た目は元と同じ「プロンプト記号を次行」になる。
      format =
        "[░▒▓](#a3aed2)"
        + "[  ](bg:#a3aed2 fg:#090c0c)"
        + "[](bg:#769ff0 fg:#a3aed2)"
        + "$directory"
        + "[](fg:#769ff0 bg:#394260)"
        + "$git_branch"
        + "$git_status"
        + "[](fg:#394260 bg:#212736)"
        + "$nodejs"
        + "$rust"
        + "$golang"
        + "$php"
        + "[](fg:#212736 bg:#1d2230)"
        + "$time"
        + "[ ](fg:#1d2230)"
        + "$line_break$character";

      directory = {
        style = "fg:#e3e5e5 bg:#769ff0";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
      };

      git_status = {
        style = "bg:#394260";
        format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };
    };
  };

  # .gitconfig を移植。移行ついでに既存の不整合を修正した:
  # - core.excludesfile = /Users/hymt/.gitignore_global を削除（パスが実在せず、
  #   hymt は現ユーザー yamato_handai とも異なる死んだ設定だった）
  # - 壊れた alias を除去: g = git（git g = git git になる）、
  #   checkout = co（co は未定義で循環）。co = checkout の 1 件のみ残す
  # email/name は現行 .gitconfig の値をそのまま維持する。
  programs.git = {
    enable = true;
    lfs.enable = true;

    # この home-manager では設定は programs.git.settings 配下に集約された
    # （旧 userName / aliases / extraConfig は deprecated）。
    settings = {
      user = {
        name = "H-ymt";
        email = "y.handai1272@gmail.com";
      };
      alias = {
        st = "status";
        co = "checkout";
      };
      push.default = "current";
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      diff.colorMoved = "default";
    };
  };

  # Phase 5: mise の [bootstrap.hooks.*] を home-manager の activation script へ移す。
  #
  # mise フックは `mise bootstrap` 実行時のみ走ったが、activation script は
  # `darwin-rebuild switch` のたびに走る。3 つとも冪等かつ失敗許容（|| true）で、
  # 毎回走っても副作用がないため、変更検知は挟まず素直に毎回実行する。
  #
  # PATH に注意: activation は home-manager の最小環境で走るため、参照するコマンドは
  # フルパスか明示的な PATH 追加が要る。gh / bat は Nix プロファイル
  # （home.packages 由来）にあるが、apm は Nix 管理外の ~/.local/bin/apm（手動配置）。
  # apm 自体の導入は Phase 5 の対象外なので、無ければ警告して skip する
  # （新 PC ではブートストラップ時に別途入れる。mise の `|| true` と同じ寛容さ）。
  home.activation = {
    # 旧 [bootstrap.hooks.post-packages]: gh-poi extension を導入する。
    installGhPoi = config.lib.dag.entryAfter [ "installPackages" ] ''
      if ${pkgs.gh}/bin/gh auth status >/dev/null 2>&1; then
        ${pkgs.gh}/bin/gh extension list 2>/dev/null | grep -q seachicken/gh-poi \
          || ${pkgs.gh}/bin/gh extension install seachicken/gh-poi 2>/dev/null || true
      fi
    '';

    # 旧 [bootstrap.hooks.post-dotfiles] の apm install: Agent Skills を導入する。
    # apm は Nix 管理外のため存在確認してから実行する。
    #
    # apm は PyInstaller 製で内部の GitPython が git 実行ファイルを要求するが、
    # activation は最小 PATH で走るため git が見つからず ImportError で落ちる。
    # pkgs.git のフルパスを GIT_PYTHON_GIT_EXECUTABLE と PATH の両方に渡して解決する。
    installApmSkills = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      apm_bin="$HOME/.local/bin/apm"
      if [ -x "$apm_bin" ]; then
        export GIT_PYTHON_GIT_EXECUTABLE="${pkgs.git}/bin/git"
        PATH="${pkgs.git}/bin:$PATH" "$apm_bin" install --target all || true
      else
        echo "warning: apm not found at $apm_bin — skipping skill install (Phase 5)" >&2
      fi
    '';

    # 旧 [bootstrap.hooks.post-dotfiles] の bat cache: bat のテーマ/シンタックスキャッシュを再構築する。
    buildBatCache = config.lib.dag.entryAfter [ "installPackages" ] ''
      ${pkgs.bat}/bin/bat cache --build || true
    '';
  };

  # delta は独立した programs.delta モジュールへ移った。
  # enableGitIntegration を明示すると git の pager/interactive.diffFilter に自動で結線される。
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
  };

  # .zshrc を移植。sheldon（zsh-defer による遅延ロード）は nixpkgs の
  # programs.zsh.plugins に defer 相当がないため継続し、eval "$(sheldon source)" を
  # initContent に残す。starship/zoxide/fzf/atuin の各 init もすべて手書きの eval を
  # 維持することで、既存 .zshrc の実行順序（compinit → sheldon → … → starship → atuin）
  # を 1 バイトも変えない。
  #
  # enableCompletion = false: home-manager が独自の compinit を注入すると二重実行に
  # なるため無効化し、既存の「sheldon より前に手動 compinit」を initContent で維持する。
  programs.zsh = {
    enable = true;
    enableCompletion = false;

    # programs.zsh.enable は .zshenv / .zprofile も生成するため、既存の実ファイル
    # （Volta / Vite+ / Cargo が .zshenv に、OrbStack / Obsidian が .zprofile に自動追記したもの）
    # をここに取り込んで内容を保持する。取り込まないと activation がファイル衝突で止まる。
    envExtra = ''
      export VOLTA_HOME="$HOME/.volta"
      export PATH="$VOLTA_HOME/bin:$PATH"

      # Vite+ bin (https://viteplus.dev)
      . "$HOME/.vite-plus/env"
      . "$HOME/.cargo/env"
    '';

    profileExtra = ''
      # Added by OrbStack: command-line tools and integration
      # This won't be added again if you remove it.
      source ~/.orbstack/shell/init.zsh 2>/dev/null || :

      # Added by Obsidian
      export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
    '';

    initContent = ''
      # Amazon Q pre block. Keep at the top of this file.
      [[ -f "''${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "''${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

      # Homebrew
      export PATH="/opt/homebrew/bin:$PATH"
      export PATH="$HOME/.volta/bin:$HOME/.codeium/windsurf/bin:$HOME/.antigravity/antigravity/bin:$HOME/.turso:$PATH"

      # Claude Code
      export ANTHROPIC_MODEL=opus

      # Initialize completions (must be before sheldon for compdef)
      autoload -Uz compinit && compinit

      # zsh-abbr: enable cursor placement in expansions
      export ABBR_SET_EXPANSION_CURSOR=1

      # sheldon - zsh plugin manager
      eval "$(sheldon source 2>/dev/null)"

      setopt NO_BANG_HIST

      # Rust / Cargo
      . "$HOME/.cargo/env"

      # pnpm
      export PNPM_HOME="$HOME/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      # mise
      eval "$(mise activate zsh)"
      corepack disable pnpm 2>/dev/null

      # zoxide
      eval "$(zoxide init zsh)"

      # git helper functions
      function git_main_branch() {
        local branch
        for branch in main trunk mainline default master; do
          git show-ref -q --verify "refs/heads/$branch" 2>/dev/null && echo "$branch" && return 0
        done
        echo main
      }

      function git_current_branch() {
        git symbolic-ref --short HEAD 2>/dev/null
      }

      function git_develop_branch() {
        local branch
        for branch in dev devel develop development; do
          git show-ref -q --verify "refs/heads/$branch" 2>/dev/null && echo "$branch" && return 0
        done
        echo develop
      }

      # fzf
      source <(fzf --zsh)

      # ghq + fzf でリポジトリにジャンプ (Ctrl+G)
      function ghq-fzf-repo() {
        local selected
        selected=$(ghq list | fzf --preview "eza -T --level=2 --color=always $(ghq root)/{}")
        if [ -n "$selected" ]; then
          BUFFER="cd $(ghq root)/$selected"
          zle accept-line
        fi
        zle reset-prompt
      }
      zle -N ghq-fzf-repo
      bindkey '^G' ghq-fzf-repo

      # Yazi
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      # Starship
      eval "$(starship init zsh)"

      # atuin (shell history)
      eval "$(atuin init zsh)"

      # SSH: ghostty の terminfo がないサーバーでの表示崩れを防ぐ
      ssh() {
        TERM=xterm-256color command ssh "$@"
      }

      # Shopify Hydrogen
      h2() {
        local prefix
        prefix="$(npm prefix -s)"
        "$prefix/node_modules/.bin/shopify" hydrogen "$@"
      }

      # Kiro
      [[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

      # Amazon Q post block. Keep at the bottom of this file.
      [[ -f "''${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "''${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };
}
