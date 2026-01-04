{pkgs, ...}: {
  plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add = {text = "+";};
        change = {text = "~";};
        delete = {text = "_";};
        topdelete = {text = "‾";};
        changedelete = {text = "~";};
      };
    };
  };

  plugins.hunk.enable = true;
  plugins.diffview.enable = true;

  keymaps = [
    # Navigation
    {
      mode = "n";
      key = "]c";
      action.__raw = ''
        function()
          if vim.wo.diff then vim.cmd.normal { "]c", bang = true }
          else require("gitsigns").nav_hunk("next") end
        end
      '';
      options.desc = "Jump to next git [c]hange";
    }
    {
      mode = "n";
      key = "[c";
      action.__raw = ''
        function()
          if vim.wo.diff then vim.cmd.normal { "[c", bang = true }
          else require("gitsigns").nav_hunk("prev") end
        end
      '';
      options.desc = "Jump to previous git [c]hange";
    }
    # Actions
    {
      mode = "v";
      key = "<leader>hr";
      action.__raw = ''
        function()
          require("gitsigns").reset_hunk { vim.fn.line("."), vim.fn.line("v") }
        end
      '';
      options.desc = "reset git hunk";
    }
    {
      mode = "n";
      key = "<leader>hr";
      action.__raw = "require('gitsigns').reset_hunk";
      options.desc = "git [r]eset hunk";
    }
    {
      mode = "n";
      key = "<leader>hR";
      action.__raw = "require('gitsigns').reset_buffer";
      options.desc = "git [R]eset buffer";
    }
    {
      mode = "n";
      key = "<leader>hb";
      action.__raw = "require('gitsigns').blame_line";
      options.desc = "git [b]lame line";
    }
    {
      mode = "n";
      key = "<leader>hd";
      action.__raw = "require('gitsigns').diffthis";
      options.desc = "git [d]iff against index";
    }
    {
      mode = "n";
      key = "<leader>hD";
      action.__raw = ''
        function()
          require("gitsigns").diffthis("@")
        end
      '';
      options.desc = "git [D]iff against last commit";
    }
    # Toggles
    {
      mode = "n";
      key = "<leader>tb";
      action.__raw = "require('gitsigns').toggle_current_line_blame";
      options.desc = "[T]oggle git show [b]lame line";
    }
    {
      mode = "n";
      key = "<leader>tD";
      action.__raw = "require('gitsigns').toggle_deleted";
      options.desc = "[T]oggle git show [D]eleted";
    }
  ];

  # Optionally enable diffview.nvim for rich diffs/history
  # plugins.diffview = {
  #   enable = true;
  #   lazy = {
  #     cmd = [ "DiffviewOpen" "DiffviewFileHistory" ];
  #     keys = [
  #       { key = "<leader>gd"; desc = "Open diffview"; }
  #       { key = "<leader>gh"; desc = "File history (diffview)"; }
  #     ];
  #   };
  # };
}
