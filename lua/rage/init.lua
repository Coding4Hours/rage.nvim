local M = {}

local a = require("plenary.async")
local uv = vim.loop

local fetch_insult = a.wrap(function(cb)
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local handle
  local data = ""
  local error_data = ""
  local url = "https://evilinsult.com/generate_insult.php?lang=en&type=text"

  handle, _ = uv.spawn("curl", {
    args = { "-s", url },
    stdio = { nil, stdout, stderr },
  }, function(code, signal)
    pcall(function() stdout:close() end)
    pcall(function() stderr:close() end)
    if handle then
      pcall(function() handle:close() end)
    end

    if code == 0 then
      cb(data)
    else
      cb("Failed to fetch insult. Error: " .. error_data)
    end
  end)

  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      data = data .. chunk
    end
  end)

  stderr:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      error_data = error_data .. chunk
    end
  end)
end, 1)

function M.insult_me()
  a.run(function()
    local insult = fetch_insult()
    vim.schedule(function()
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { insult })
      local win_opts = {
        relative = "editor",
        style = "minimal",
        border = "rounded",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor((vim.o.lines - math.floor(vim.o.lines * 0.8)) / 2),
        col = math.floor((vim.o.columns - math.floor(vim.o.columns * 0.8)) / 2),
      }
      vim.api.nvim_open_win(buf, true, win_opts)
    end)
  end)
end

function M.setup()
  M.timer = vim.loop.new_timer()
  M.running = false

  local function start()
    if not M.running then
      M.timer:start(300000, 300000, vim.schedule_wrap(M.insult_me))
      M.running = true
      print("Rage started")
    end
  end

  local function stop()
    if M.running then
      M.timer:stop()
      M.timer:close()
      M.timer = vim.loop.new_timer()
      M.running = false
      print("Rage stopped")
    end
  end

  vim.api.nvim_create_user_command("Rage", start, {})
  vim.api.nvim_create_user_command("Calm", stop, {})
  vim.api.nvim_create_user_command("RageToggle", function()
    if M.running then stop() else start() end
  end, {})
end



return M
