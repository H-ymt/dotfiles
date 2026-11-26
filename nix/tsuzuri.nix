# tsuzuri の閲覧アプリを `tsuzuri` コマンドで起動できるようにする。スキル本体は skills.nix が配る。
# アプリは同じリポジトリの skills/tsuzuri/scripts を読むため、スキルと同じ flake input から作る。
{ lib, pkgs, inputs, ... }:

let
  # 初回起動時、アプリは同梱のクイックスタートを ~/.config/tsuzuri/samples/ へ copytree し、
  # 写した order.json を消して書き直す。copytree は store の読み取り専用の権限まで写すため、
  # そのままだと PermissionError で起動できない。写した直後に書き込み権限を戻す。
  # 行頭の空白が Python のインデントなので、空白を削る '' 文字列ではなく "" で書く。
  copyLine = "        shutil.copytree(HERE / \"quickstart\" / root.name, root)";
  copyAndChmod = lib.concatStringsSep "\n" [
    copyLine
    "        for path in (root, *root.rglob(\"*\")):"
    "            path.chmod(path.stat().st_mode | 0o200)"
  ];
  src = pkgs.applyPatches {
    name = "tsuzuri-source";
    src = inputs.tsuzuri;
    postPatch = ''
      substituteInPlace app/server.py \
        --replace-fail ${lib.escapeShellArg copyLine} ${lib.escapeShellArg copyAndChmod}
    '';
  };
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "tsuzuri" ''
      exec ${pkgs.python3}/bin/python3 ${src}/app/server.py "$@"
    '')
  ];
}
