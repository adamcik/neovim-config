{...}: {
  globals = {
    # Set <space> as the leader key. See `:help mapleader`
    mapleader = " ";
    maplocalleader = " ";
  };

  opts = {
    # Make line numbers default
    number = true;

    # Enable mouse mode, can be useful for resizing splits for example!
    mouse = "nv";

    # Don't show the mode, since it's already in the status line
    showmode = false;

    # Enable break indent
    breakindent = true;

    # Save undo history
    undofile = true;

    # Case-insensitive searching UNLESS \C or one or more capital letters in
    # the search term
    ignorecase = true;
    smartcase = true;

    # Keep signcolumn on by default
    signcolumn = "yes";

    # Show which line your cursor is on
    cursorline = true;

    # Minimal number of screen lines to keep above and below the cursor.
    scrolloff = 10;

    # Decrease update time
    updatetime = 250;

    # Decrease mapped sequence wait time
    # Displays which-key popup sooner
    timeoutlen = 300;

    # Configure how new splits should be opened
    splitright = true;
    splitbelow = true;

    # Sets how neovim will display certain whitespace characters in the editor.
    #  See `:help 'list'` and `:help 'listchars'`
    list = true;
    listchars = {
      tab = "» ";
      trail = "·";
      nbsp = "␣";
    };

    # Preview substitutions live, as you type!
    inccommand = "split";

    # It might make sense to postpone this with a schedule intil after UiEnter
    # to speed things up?
    clipboard = "unnamedplus";

    # Disable folding by default (even with treesitter)
    foldenable = false;
  };

  keymaps = [
    # Clear search highlights with <Esc> in normal mode
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlights";
    }

    # Keybinds to make split navigation easier.
    #  Use CTRL+<hjkl> to switch between windows
    #
    #  See `:help wincmd` for a list of all window commands
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w><C-h>";
      options.desc = "Move focus to the left window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w><C-l>";
      options.desc = "Move focus to the right window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w><C-j>";
      options.desc = "Move focus to the lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w><C-k>";
      options.desc = "Move focus to the upper window";
    }

    # Tab navigation
    {
      mode = "n";
      key = "<leader>n";
      action = "<cmd>tabnext<CR>";
      options.desc = "[N]ext tab";
    }
    {
      mode = "n";
      key = "<leader>p";
      action = "<cmd>tabprevious<CR>";
      options.desc = "[P]revious tab";
    }

    # Diagnostic keymaps
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>lua vim.diagnostic.setloclist()<CR>";
      options.desc = "Open diagnostic [Q]uickfix list";
    }

    # Telescope custom mappings
    {
      mode = "n";
      key = "<leader>sf";
      action.__raw = ''
        function()
          local builtin = require('telescope.builtin')
          if vim.fn.isdirectory('.git') == 1 then
            builtin.git_files { show_untracked = true }
          else
            builtin.find_files()
          end
        end
      '';
      options.desc = "[S]earch [F]iles";
    }
    {
      mode = "n";
      key = "<leader>sn";
      action.__raw = ''
        function()
          require('telescope.builtin').find_files { cwd = vim.fn.stdpath('config') }
        end
      '';
      options.desc = "[S]earch [N]eovim config files";
    }
    {
      mode = "n";
      key = "<leader>/";
      action.__raw = ''
        function()
          local builtin = require('telescope.builtin')
          local themes = require('telescope.themes')
          builtin.current_buffer_fuzzy_find(themes.get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end
      '';
      options.desc = "[/] Fuzzily search in current buffer";
    }

    # Terminal mode keymaps
    # NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
    # or just use <C-\><C-n> to exit terminal mode
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options.desc = "Exit terminal mode";
    }
    {
      mode = "t";
      key = "<C-h>";
      action = "<C-\\><C-n><C-w><C-h>";
      options.desc = "Move focus to the left window";
    }
    {
      mode = "t";
      key = "<C-l>";
      action = "<C-\\><C-n><C-w><C-l>";
      options.desc = "Move focus to the right window";
    }
    {
      mode = "t";
      key = "<C-j>";
      action = "<C-\\><C-n><C-w><C-j>";
      options.desc = "Move focus to the lower window";
    }
    {
      mode = "t";
      key = "<C-k>";
      action = "<C-\\><C-n><C-w><C-k>";
      options.desc = "Move focus to the upper window";
    }
  ];

  autoCmd = [
    {
      event = "TextYankPost";
      callback.__raw = "vim.highlight.on_yank";
    }
    {
      event = "TermOpen";
      desc = "Set local settings for terminal buffers";
      callback.__raw = ''
        function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.scrolloff = 0
          vim.bo.filetype = "terminal"
        end
      '';
    }
  ];

  extraConfigLua = ''
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = " ",
          [vim.diagnostic.severity.INFO] = " ",
        }
      }
    })
  '';
}
