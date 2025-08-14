if vim.fn.has("nvim-0.5.0") ~= 1 then
  vim.api.nvim_err_writeln("⚠️ rage.nvim requires at least Neovim 0.5.0")
  return
end


vim.cmd("Rage")
