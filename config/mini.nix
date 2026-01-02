{...}: {
  plugins.mini = {
    enable = true;
    modules = {
      ai = {enable = true;};
      surround = {enable = true;};
    };
  };

  keymaps = [
    {
      key = "ys";
      action = "MiniSurround.add";
      options.desc = "Add surround";
    }
    {
      key = "ds";
      action = "MiniSurround.delete";
      options.desc = "Delete surround";
    }
    {
      key = "cs";
      action = "MiniSurround.replace";
      options.desc = "Replace surround";
    }
  ];
}
