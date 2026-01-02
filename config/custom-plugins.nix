{pkgs, ...}: {
  extraPlugins = [
    (
      let
        rev = "cd32df1b78217a0de826d8b2cf645e84f30d166a";
      in (pkgs.vimUtils.buildVimPlugin {
        pname = "python-lspconfig";
        version = rev;
        src = pkgs.fetchFromGitHub {
          owner = "adamcik";
          repo = "python-lspconfig.nvim";
          hash = "sha256-GMnFxq0j3FYVDhQniJStnKNefDx4r4nGTX6XxoUbKns=";
          inherit rev;
        };
        dependencies = [pkgs.vimPlugins.plenary-nvim];
      })
    )
    (
      let
        rev = "3d3cd95e4a4135c250faf83dd5ed61b8e5502b86";
      in (pkgs.vimUtils.buildVimPlugin {
        pname = "tailwindcss-colorizer-cmp";
        version = rev;
        src = pkgs.fetchFromGitHub {
          owner = "roobert";
          repo = "tailwindcss-colorizer-cmp.nvim";
          hash = "sha256-PIkfJzLt001TojAnE/rdRhgVEwSvCvUJm/vNPLSWjpY=";
          inherit rev;
        };
      })
    )
    (
      let
        rev = "bee239e847cf336fc10925a35c65052f41aa89e3";
      in (pkgs.vimUtils.buildVimPlugin {
        pname = "jj-diffconflicts";
        version = rev;
        src = pkgs.fetchFromGitHub {
          owner = "rafikdraoui";
          repo = "jj-diffconflicts";
          hash = "sha256-FXsLSYy+eli8VArUL8ZOiPtyOk4Q8TUYwobEefZPRII=";
          inherit rev;
        };
      })
    )
    (
      let
        rev = "222e90bd8dcdf16ca1efc4e784416afb5f011c31";
      in (pkgs.vimUtils.buildVimPlugin {
        pname = "copilot-lualine";
        version = rev;
        src = pkgs.fetchFromGitHub {
          owner = "AndreM222";
          repo = "copilot-lualine";
          hash = "sha256-HYNqPdwatrNTNUGo6I2SzmNxSI4iqX+Ls7GHQcU8+Fk=";
          inherit rev;
        };
      })
    )
    (
      let
        rev = "0af25bcfdd1e3132dc1795caf621bef9bc8ecd32";
      in (pkgs.vimUtils.buildVimPlugin {
        pname = "highlight-whitespace";
        version = rev;
        src = pkgs.fetchFromGitHub {
          owner = "lukoshkin";
          repo = "highlight-whitespace";
          hash = "sha256-2sNJwNdfYRq+srH6nfwP6U1jqK3fmmyu8xxsQKxYgPE=";
          inherit rev;
        };
      })
    )
  ];
}
