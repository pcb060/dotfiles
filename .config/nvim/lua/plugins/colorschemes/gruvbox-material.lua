return {
    {
        "sainnhe/gruvbox-material",
        lazy = false, -- load at startup, not on demand
        priority = 1000, -- load before other plugins that might set colors
        init = function()
            -- Palette: "material" | "mix" | "original"
            vim.g.gruvbox_material_palette = "material"

            -- Background contrast: "hard" | "medium" | "soft"
            vim.g.gruvbox_material_background = "hard"

            -- Optional but recommended: enable bold/italic if your font supports it
            vim.g.gruvbox_material_enable_bold = 1
            vim.g.gruvbox_material_enable_italic = 1

            -- Better performance using cached highlights
            vim.g.gruvbox_material_better_performance = 1
        end,
    }
}
