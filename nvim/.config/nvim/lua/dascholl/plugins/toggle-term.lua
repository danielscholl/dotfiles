return {
  {
    "akinsho/toggleterm.nvim",
    tag = "v2.13.0", -- Use the latest stable version
    config = function()
      require("toggleterm").setup{
        size = 20,
        open_mapping = [[<C-,>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      }
    end,
    keys = {
      {
        "<leader>ch",
        "<cmd>ToggleTerm size=40 direction=horizontal<cr>",
        desc = "Open a horizontal terminal"
      },
      {
        "<leader>cv",
        "<cmd>ToggleTerm size=40 direction=vertical<cr>",
        desc = "Open a vertical terminal"
      },
      {
        "<leader>cf",
        "<cmd>ToggleTerm direction=float<cr>",
        desc = "Open a floating terminal"
      },
      {
        "<leader>cd",
        "<cmd>ToggleTerm dir=~/Desktop<cr>",
        desc = "Open a terminal at the Desktop directory"
      },
    },
  },
}
