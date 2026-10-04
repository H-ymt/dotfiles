return {
  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "text" },
    init = function()
      vim.g.bullets_outline_levels = { "std-" }
      vim.g.bullets_custom_mappings = {
        { "imap", "<Tab>", "<Plug>(bullets-demote)" },
        { "imap", "<S-Tab>", "<Plug>(bullets-promote)" },
      }
    end,
  },
}
