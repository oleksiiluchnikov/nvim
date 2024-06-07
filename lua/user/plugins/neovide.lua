-- Neovid config file
-- Font
-- vim.opt.guifont = { "Fairfax HD:h16" }
vim.opt.guifont = { "ProggyCleanTTSZ:h16" }

-- Scale
vim.g.neovide_scale_factor = 1

-- Background color
vim.g.neovide_background = "#010203"

-- Floating Blur Amount

-- Transparency
vim.g.neovide_transparency = 1.0

-- Scroll Animation Length
vim.g.neovide_scroll_animation_length = 0.0 -- 0.0 is instant

-- Hiding the mouse when typing
vim.g.neovide_hide_mouse_when_typing = true

-- Underline automatic scaling
vim.g.neovide_underline_automatic_scaling = false


-- Functionaltiy

-- Refresh rate
vim.g.neovide_refresh_rate = 60

-- Idle refresh rate
vim.g.neovide_refresh_rate_idle = 5

-- Confirm quit
vim.g.neovide_confirm_quit = 1

-- Fullscreen
vim.g.neovide_fullscreen = false
vim.g.neovide_input_use_logo = 1

-- Remember Previous Window Size
vim.g.neovide_remember_window_size = false

-- Profiler
vim.g.neovide_profiler = false


-- Input Settings

-- Use Logo Key
vim.g.neovide_input_use_logo = true

-- macOS Alt is Meta
vim.g.neovide_input_macos_alt_is_meta = true


-- Cursor Settings

-- Animation Length
vim.g.neovide_cursor_animation_length = 0 -- 0 to disable

-- Animation Trail Size
vim.g.neovide_cursor_trail_size = 0

-- Antialiasing
vim.g.neovide_cursor_antialiasing = false

-- Unfocused Outline Width
vim.g.neovide_cursor_unfocused_outline_width = 1

-- Cursor Particles
vim.g.neovide_cursor_vfx_mode =
"pixiedust" -- options: "railgun", "sandstorm", "pixelated-sandstorm", "sonicboom", "none"

-- Particle Settings
vim.g.neovide_cursor_vfx_particle_density = 1400
vim.g.neovide_cursor_vfx_particle_lifetime = 0.1

-- Particle Opacity
vim.g.neovide_cursor_vfx_opacity = 200.0
