{pkgs, ...}: {
  autoCmd = [
    {
      event = ["BufEnter" "BufWritePost" "InsertLeave"];
      callback.__raw = ''
        function()
          if vim.opt_local.modifiable:get() then
            require("lint").try_lint()
          end
        end
      '';
      desc = "Run nvim-lint on buffer events for modifiable buffers";
    }
  ];

  plugins.lint = {
    enable = true;
    lintersByFt = {
      bash = ["shellcheck"];
      dockerfile = ["hadolint"];
      make = ["checkmake"];
      markdown = ["markdownlint"];
      nix = ["statix"];
      rst = ["vale"];
      sh = ["shellcheck"];
      terraform = ["tflint"];
      text = ["vale"];
      yaml = ["yamllint"];
      "yaml.github" = ["actionlint"];
      zsh = ["shellcheck"];
      dotenv = ["dotenv_linter"];
    };
  };

  # TODO:: Other linters to consider if not covered by lsp
  # djlint
  # detect-secrets
  # trivy
  # tfsec -> trivy?
  # systemdlint
  # systemd-analyze
  # statix
  # protolint
  # json5
  # gitleaks
  # gitlint
  # commitlint

  extraPackages = with pkgs; [
    actionlint
    checkmake
    hadolint
    nodePackages.markdownlint-cli
    shellcheck
    tflint
    vale
    yamllint
    dotenv-linter
    statix
  ];
}
