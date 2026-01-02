{
  lib,
  pkgs,
  ...
}: {
  # LSP core configuration (keymaps + onAttach)
  lsp = {
    # LSP keymaps, applied per-buffer on attach
    keymaps = [
      # Telescope-backed LSP pickers
      {
        mode = "n";
        key = "gd";
        action.__raw = "require('telescope.builtin').lsp_definitions";
        options.desc = "LSP: [G]oto [D]efinition";
      }
      {
        mode = "n";
        key = "gr";
        action.__raw = "require('telescope.builtin').lsp_references";
        options.desc = "LSP: [G]oto [R]eferences";
      }
      {
        mode = "n";
        key = "gI";
        action.__raw = "require('telescope.builtin').lsp_implementations";
        options.desc = "LSP: [G]oto [I]mplementation";
      }
      {
        mode = "n";
        key = "<leader>D";
        action.__raw = "require('telescope.builtin').lsp_type_definitions";
        options.desc = "LSP: Type [D]efinition";
      }
      {
        mode = "n";
        key = "<leader>ds";
        action.__raw = "require('telescope.builtin').lsp_document_symbols";
        options.desc = "LSP: [D]ocument [S]ymbols";
      }
      {
        mode = "n";
        key = "<leader>ws";
        action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
        options.desc = "LSP: [W]orkspace [S]ymbols";
      }

      # Direct vim.lsp.buf actions, using lspBufAction helper
      {
        mode = "n";
        key = "<leader>rn";
        lspBufAction = "rename";
        options.desc = "LSP: [R]e[n]ame";
      }
      {
        mode = ["n" "x"];
        key = "<leader>ca";
        lspBufAction = "code_action";
        options.desc = "LSP: [C]ode [A]ction";
      }
      {
        mode = "n";
        key = "gD";
        lspBufAction = "declaration";
        options.desc = "LSP: [G]oto [D]eclaration";
      }
    ];

    # Extra behaviour when a server attaches
    onAttach = ''
      if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local highlight_augroup = vim.api.nvim_create_augroup("custom-lsp-highlight", { clear = false })

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = bufnr,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = bufnr,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })
      end

      -- Inlay hints toggle keymap (if supported)
      if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.keymap.set('n', '<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
        end, { buffer = bufnr, desc = 'LSP: [T]oggle Inlay [H]ints' })
      end

      -- Attach navic if supported
      if client and client.server_capabilities.documentSymbolProvider then
        local ok, navic = pcall(require, 'nvim-navic')
        if ok and navic.attach then
          navic.attach(client, bufnr)
        end
      end

      -- Disable hover for ruff LSP
      if client and client.name == 'ruff' then
        client.server_capabilities.hoverProvider = false
      end

      -- Explicitly disable formatting for pyright/basedpyright
      if client and (client.name == "pyright" or client.name == "basedpyright") then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end

      -- Avoid breaking gq
      vim.bo[bufnr].formatexpr = nil
    '';

    servers = let
      mkLsp = name: attrs: {
        enable = true;
        package = lib.mkIf (attrs.optional or false) null;
        config = attrs.config or {};
      };
    in
      lib.mapAttrs mkLsp {
        nixd = {};
        ast_grep = {};
        fish_lsp = {};
        marksman = {};
        systemd_lsp = {};
        taplo = {};
        lua_ls = {
          config = {
            Lua = {
              telemetry = {enable = false;};
              workspace = {checkThirdParty = false;};
            };
          };
        };
        jsonls = {
          config = {
            json = {
              schemas.__raw = ''require("schemastore").json.schemas()'';
              validate = {enable = true;};
            };
          };
        };
        yamlls = {
          config = {
            filetypes = ["yaml" "yaml.github"];
            yaml = {
              keyOrdering = false;
              format = {enable = true;};
              validate = true;
              schemaStore = {
                enable = false;
                url = "";
              };
              schemas.__raw = ''require("schemastore").json.schemas()'';
            };
          };
        };
        typos_lsp = {
          config = {
            diagnosticSeverity = "Warning";
          };
        };

        # TODO: diagnosticls for linters in LSPs?
        arduino_language_server.optional = true;
        basedpyright = {
          optional = true;
          config = {
            basedpyright = {disableOrganizeImports = true;};
            python = {
              analysis = {
                ignore = ["*"];
              };
            };
          };
        };
        bashls.optional = true;
        biome.optional = true;
        clangd.optional = true;
        cmake.optional = true;
        cssls.optional = true;
        docker_compose_language_service.optional = true;
        dockerls.optional = true;
        eslint.optional = true;
        gopls.optional = true;
        helm_ls.optional = true;
        hls.optional = true;
        html.optional = true;
        htmx.optional = true;
        jinja_lsp.optional = true;
        jqls.optional = true;
        nginx_language_server.optional = true;
        postgres_lsp.optional = true;
        protols.optional = true;
        # graphql.optional = true;
        pyright.optional = true;
        ruff.optional = true;
        rust_analyzer.optional = true;
        sqls.optional = true;
        stylelint_lsp.optional = true;
        tailwindcss.optional = true;
        terraformls.optional = true;
        ts_ls.optional = true;
        tsgo.optional = true;
        ty.optional = true;
        zls.optional = true;
      };
  };

  plugins.lazydev = {
    enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    SchemaStore-nvim
    luvit-meta
    diagflow-nvim
  ];

  extraConfigLua = ''
    -- Setup plugins via a mapping of module name to opts
    local plugin_setups = {
        ["yaml-companion"] = {},
        ["lazydev"] = {},
        ["luvit-meta"] = {},
        ["diagflow"] = {},
    }
    for name, opts in pairs(plugin_setups) do
        local ok, mod = pcall(require, name)
        if ok and mod.setup then
            mod.setup(opts)
        end
    end
  '';

  lsp.luaConfig.post = ''
    vim.lsp.config("basedpyright", {
        on_new_config = function(config, root)
            local python_path = require("python-lspconfig").python_path(root)
            if python_path and python_path ~= "" then
                config.settings.python.pythonPath = python_path
            end
        end,
    })
    vim.lsp.enable("basedpyright")
  '';
}
