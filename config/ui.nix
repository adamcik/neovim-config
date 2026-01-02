{
  lib,
  pkgs,
  ...
}: {
  extraPlugins = with pkgs.vimPlugins; [
    copilot-lualine
  ];
  keymaps = [
    {
      mode = "n";
      key = "\\";
      action = ":Neotree reveal<CR>";
      options.desc = "NeoTree reveal";
    }
    {
      mode = "n";
      key = "<leader>tu";
      action = ":UndotreeToggle<CR>";
      options.desc = "[T]oggle [U]ndo tree";
    }
  ];

  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = "mocha";
    };
  };

  plugins = {
    telescope = {
      enable = true;
      settings = {
        extensions.__raw = ''
          {
            ["ui-select"] = require('telescope.themes').get_dropdown(),
          }
        '';
      };
      extensions = {
        fzf-native.enable = true;
        ui-select.enable = true;
      };
      keymaps = {
        "<leader><leader>" = {
          action = "buffers";
          options.desc = "[ ] Find existing buffers";
        };
        "<leader>sp" = {
          action = "live_grep";
          options.desc = "[S]earch [P]roject (live grep)";
        };
        "<leader>sb" = {
          action = "buffers";
          options.desc = "[S]earch [B]uffers";
        };
        "<leader>sr" = {
          action = "oldfiles";
          options.desc = "[S]earch [R]ecent files";
        };
        "<leader>ss" = {
          action = "grep_string";
          options.desc = "[S]earch current [S]ymbol/word";
        };
        "<leader>sh" = {
          action = "help_tags";
          options.desc = "[S]earch [H]elp";
        };
        "<leader>sk" = {
          action = "keymaps";
          options.desc = "[S]earch [K]eymaps";
        };
        "<leader>sd" = {
          action = "diagnostics";
          options.desc = "[S]earch [D]iagnostics";
        };
      };
    };

    web-devicons.enable = true;

    # TODO: Revisit lazy loading for which-key using lz.n or keymap triggers, as in legacy config (see plugins/which.lua)
    which-key = let
      mkSpec = key: cfg:
        {
          __unkeyed-1 = key;
          inherit (cfg) group;
        }
        // lib.optionalAttrs (cfg ? mode) {inherit (cfg) mode;};
    in {
      enable = true;

      settings = {
        icons = {
          mappings = true;
        };
        spec = lib.mapAttrsToList mkSpec {
          "<leader>c" = {
            group = "[C]ode";
            mode = ["n" "x"];
          };
          "<leader>d" = {group = "[D]ocument";};
          "<leader>r" = {group = "[R]ename";};
          "<leader>s" = {group = "[S]earch";};
          "<leader>w" = {group = "[W]orkspace";};
          "<leader>t" = {group = "[T]oggle";};
          "<leader>h" = {
            group = "Git [H]unk";
            mode = ["n" "v"];
          };
        };
      };
    };

    todo-comments = {
      enable = true;
      settings = {
        signs = true;
        search.pattern = "\\b(KEYWORDS)(\\([^\\)]*\\))?:";
        highlight.pattern = ".*<((KEYWORDS)%(\(.{-1,}\))?):";
      };
    };

    neo-tree = {
      enable = true;
      settings = {
        log_level = "ERROR";
        log_to_file = false;
        close_if_last_window = true;
        filesystem = {
          window = {
            mappings = {
              "\\" = "close_window";
            };
          };
        };
      };
    };

    indent-blankline = {
      enable = true;
      settings = {
        indent = {
          highlight = ["CursorColumn" "Whitespace"];
          char = "";
        };
        whitespace = {
          highlight = ["CursorColumn" "Whitespace"];
          remove_blankline_trail = false;
        };
        scope = {enabled = false;};
      };
    };

    # Navic: code context breadcrumbs in winbar
    navic = {
      enable = true;
      settings = {
        lsp.auto_attach = true;
        highlight = true;
        separator = " > ";
      };
    };

    lualine = {
      enable = true;
      settings = {
        winbar = {
          lualine_c = [
            {
              __raw = "navic";
            }
          ];
        };
        sections = {
          lualine_c = [
            "copilot"
          ];
          lualine_x = [
            {
              __raw = ''
                function()
                  local ok, yc = pcall(require, "yaml-companion")
                  if ok then
                    local schema = yc.get_buf_schema(0)
                    if schema and schema.result and schema.result.name then
                      return "YAML: " .. schema.result.name
                    end
                  end
                  return ""
                end
              '';
            }
            "encoding"
            "fileformat"
            "filetype"
          ];
        };
      };
    };

    colorizer = {
      enable = true;
      settings.user_default_options.mode = "virtualtext";
    };

    undotree.enable = true;
  };
}
