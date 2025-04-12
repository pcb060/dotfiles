local M = {}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  callback = function(args)
    local buf = args.buf
    local line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""

    local shebangs = {
      "^#!%s*/bin/sh",
      "^#!%s*/bin/bash",
      "^#!%s*/usr/bin/env%s+sh",
      "^#!%s*/usr/bin/env%s+bash",
      "^#!%s*/bin/zsh",
      "^#!%s*/usr/bin/env%s+zsh",
    }

    for _, pattern in ipairs(shebangs) do
      if line:match(pattern) then
        vim.bo[buf].filetype = "sh"
        return
      end
    end
  end,
})

return M
