{
  lib,
  pkgs,
  ...
}: {
  keymaps = [
    {
      mode = "n";
      key = "<leader>tf";
      action.__raw = ''
        function()
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          print("Autoformat-on-save (buffer): " .. (vim.b.disable_autoformat and "disabled" or "enabled"))
        end
      '';
      options.desc = "[T]oggle [F]ormat-on-save (buffer)";
    }
    {
      mode = "n";
      key = "<leader>tF";
      action.__raw = ''
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          print("Autoformat-on-save (global): " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
        end
      '';
      options.desc = "[T]oggle [F]ormat-on-save (global)";
    }
    {
      mode = "n";
      key = "<leader>f";
      action.__raw = "function() require('conform').format { async = true, lsp_format = 'fallback' } end";
      options.desc = "[F]ormat buffer";
    }
  ];

  plugins = {
    sleuth.enable = true;

    conform-nvim = {
      # TODO: Add and configure yamlfix as a custom YAML formatter if desired

      enable = true;
      settings = {
        notify_on_error = false;

        default_format_opts = {
          lsp_format = "fallback";
          timeout_ms = 500;
          # TODO: Should injected be added here?
        };

        format_on_save.__raw = ''
          function(bufnr)
            local disable_filetypes = {
              c = true,
              cpp = true,
              json = true,
              jsonc = true,
              yaml = true,
              ["yaml.github"] = true,
            }
            if vim.b[bufnr].disable_autoformat == nil then
              vim.b[bufnr].disable_autoformat = disable_filetypes[vim.bo[bufnr].filetype] or false
            end
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500, lsp_format = "fallback", formatters = { "injected" } }
          end
        '';

        formatters_by_ft = let
          mkStopAfterFirst = list:
            (lib.listToAttrs (lib.imap1
              (i: v: {
                name = "__unkeyed-${toString i}";
                value = v;
              })
              list))
            // {stop_after_first = true;};

          jsFormatter = mkStopAfterFirst ["biome" "prettierd" "prettier"];
        in {
          lua = ["stylua"];
          python = ["ruff_fix" "ruff_format"];
          bash = ["shfmt"];
          caddy = ["caddy"];
          nix = ["alejandra"];

          yaml = ["yamlfmt"];
          "yaml.github" = ["yamlfmt"];
          "yaml.dockercompose" = ["yamlfmt"];

          markdown = mkStopAfterFirst ["mdformat" "prettierd" "prettier"];

          toml = ["taplo"];
          "toml.pyproject" = mkStopAfterFirst ["pyproject_fmt" "taplo"];

          javascript = jsFormatter;
          typescript = jsFormatter;
          typescriptreact = jsFormatter;
          json = jsFormatter;
          jsonc = jsFormatter;
        };

        formatters = {
          caddy = {
            command = "caddy";
            args = ["fmt" "$FILENAME"];
            stdin = false;
          };

          pyproject_fmt = {
            command = "pyproject-fmt";
            args = ["--no-print-diff" "$FILENAME"];
            stdin = false;
            exitCodes = [0 1];
          };
        };
      };
    };
  };

  extraPackages = with pkgs; [
    shfmt
    alejandra
    stylua
    # TODO: Decide on what default formatters to have here.
  ];
}
