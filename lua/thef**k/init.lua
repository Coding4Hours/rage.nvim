local M = {}

function M.hello_world()
  print("Hello, World!")
end

function M.setup(opts)
  -- Map a command to the function
  vim.api.nvim_command('command! HelloWorld lua require("thef**k").hello_world()')
end

return M
