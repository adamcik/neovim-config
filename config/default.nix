{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./options.nix
    ./completion.nix
    ./custom-plugins.nix
    ./filetypes.nix
    ./formatting.nix
    ./lint.nix
    ./lsp.nix
    ./mini.nix
    ./treesitter.nix
    ./ui.nix
    ./vcs.nix
    ./ai.nix
  ];

  extraPackages = with pkgs; [
    fd
    fzf
    ripgrep
    unzip
  ];
}
