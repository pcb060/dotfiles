return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")

    -- Disable auto ft-mapping, we'll handle it manually
    lint.linters_by_ft = {}

    -- Define a pattern for shell shebangs that ShellCheck can handle
    local function is_shell_script(buf)
      local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, false)
      local first_line = lines[1] or ""

    local shebangs = {
      "^#!%s*/bin/sh",
      "^#!%s*/bin/bash",
      "^#!%s*/usr/bin/env%s+bash",
      "^#!%s*/usr/bin/env%s+sh",
      "^#!%s*/bin/zsh",
      "^#!%s*/usr/bin/env%s+zsh",
    }

    for _, pattern in ipairs(shebangs) do
        if first_line:match(pattern) then
          return true
        end
      end

      return false
    end

    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local filename = vim.api.nvim_buf_get_name(buf)

        -- Run ShellCheck if it's a .sh file or has a compatible shebang
        if filename:match("%.sh$") or is_shell_script(buf) then
          lint.try_lint("shellcheck")
        end
      end,
    })

    --Optional: manual lint command
    --vim.keymap.set("n", "<leader>ll", function()
    --  lint.try_lint()
    --end, { desc = "Lint current buffer" })
  end,
}

