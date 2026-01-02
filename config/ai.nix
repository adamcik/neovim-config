{...}: {
  extraConfigLua = ''
    require("copilot").setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        yaml = false,
        markdown = false,
        json = false,
        csv = false,
        dotenv = false,
      },
    })
  '';
}
