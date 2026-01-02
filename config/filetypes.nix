{...}: {
  filetype = {
    extension = {
      env = "dotenv";
    };

    filename = {
      "Caddyfile" = "caddy";
      "caddyfile" = "caddy";
      ".env" = "dotenv";
      "env" = "dotenv";
      "pyproject.toml" = "toml.pyproject";
      "dockerfile.dockerignore" = "conf";
      "action.yaml" = "yaml.github";
      "action.yml" = "yaml.github";
    };

    pattern = {
      "%.env%.[%w_.-]+" = "dotenv";
      "%.caddyfile%.[%w_.-]+" = "caddy";
      ".*%.github/workflows/.*%.yml" = "yaml.github";
      ".*%.github/workflows/.*%.yaml" = "yaml.github";
      ".*/action.yml" = "yaml.github";
      ".*/action.yaml" = "yaml.github";
    };
  };
}
