return {
  {
    "shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    init = function()
      require("ayu").setup({
        mirage = false,
        overrides = {},
      })
    end,
  },
}
