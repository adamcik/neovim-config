{pkgs, ...}: let
  dotenvGrammarVersion = "0.0.4";

  dotenvGrammar = pkgs.tree-sitter.buildGrammar {
    language = "dotenv";
    version = dotenvGrammarVersion;
    src =
      pkgs.fetchgit
      {
        url = "https://github.com/pnx/tree-sitter-dotenv.git";
        rev = "v${dotenvGrammarVersion}";
        sha256 = "sha256-YuBlYjlfJ2+n+5hE9qDz7/gGDQE9654hR8i48CL180E=";
      };

    postInstall = ''
      mkdir -p $out/queries/dotenv
      cp -r $src/queries/* $out/queries/dotenv/
    '';

    meta.homepage = "https://github.com/pnx/tree-sitter-dotenv";
  };
in {
  extraPackages = with pkgs; [
    tree-sitter
  ];

  plugins.treesitter = {
    enable = true;

    settings = {
      highlight.enable = true;
      indent.enable = true;
      folding.enable = true;
    };

    nixvimInjections = true;

    grammarPackages =
      pkgs.vimPlugins.nvim-treesitter.allGrammars
      ++ [
        dotenvGrammar
      ];

    luaConfig.post = ''
      do
          local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
          parser_config.dotenv = {
              install_info = {
                  url = "${dotenvGrammar}",
                  files = { "src/parser.c" },
                  branch = "v${dotenvGrammarVersion}",
              },
              filetype = "dotenv",
          }
      end
    '';

    languageRegister.dotenv = "dotenv";
  };
}
