{lib, ...}: {
  plugins = {
    cmp-nvim-lsp.enable = true;
    cmp-emoji.enable = true;
    cmp-git.enable = true;
    # gitmoji.enable = true;
    cmp-nvim-lsp-document-symbol.enable = true;
    cmp-treesitter.enable = true;
    cmp-buffer.enable = true;
    fidget.enable = true;
    lspkind.enable = true;

    copilot-lua.enable = true;
    copilot-cmp.enable = true;

    # Present only as the snippet engine for LSP; we don't expose
    # "luasnip" as a completion source.
    luasnip.enable = true;

    cmp = {
      enable = true;

      cmdline = {
        "/" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [
            {name = "nvim_lsp_document_symbol";}
            {name = "buffer";}
          ];
        };
        "?" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [
            {name = "nvim_lsp_document_symbol";}
            {name = "buffer";}
          ];
        };
        ":" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [
            {name = "path";}
            {
              name = "cmdline";
              option = {
                ignore_cmds = ["Man" "!"];
              };
            }
          ];
        };
      };

      settings = {
        mapping.__raw = ''
          cmp.mapping.preset.insert({
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          })
        '';

        snippet = {
          # Only used when an LSP completion item contains snippet text.
          expand.__raw = ''
            function(args)
              require("luasnip").lsp_expand(args.body)
            end
          '';
        };

        sources = [
          {
            name = "lazydev";
            group_index = 0;
          }
          {name = "emoji";}
          {name = "git";}
          # {name = "gitmoji";}
          {name = "nvim_lsp_document_symbol";}
          {name = "nvim_lsp_signature_help";}
          {name = "path";}
          {
            name = "nvim_lsp";
            entry_filter.__raw = ''
              function(entry, ctx)
                return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
              end
            '';
          }
          {name = "copilot";}
          {name = "treesitter";}
          {name = "buffer";}
        ];

        formatting.format = lib.mkForce "global_formatter";
      };
    };
  };

  extraConfigLua = ''
    require("tailwindcss-colorizer-cmp").setup({ color_square_width = 2 })
    require("copilot_cmp").setup()
    local kind_formatter = require("lspkind").cmp_format({
      mode = "symbol_text",
      maxwidth = 50,
      menu = {
        copilot = "[ Copilot]",
        nvim_lsp = "[LSP]",
        buffer = "[Buffer]",
        path = "[Path]",
      },
      symbol_map = {
        Copilot = "",
      }
    })
    local tailwind_formatter = require("tailwindcss-colorizer-cmp").formatter
    global_formatter = function(entry, vim_item)
      vim_item = kind_formatter(entry, vim_item)
      vim_item = tailwind_formatter(entry, vim_item)
      return vim_item
    end
  '';
}
