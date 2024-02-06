local wezterm = require("wezterm")
local workspaces = require("workspace-manager.init")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Gruvbox Dark (Gogh)"

config.font = wezterm.font("MesloLGS NF")
config.font_size = 15.8 -- 16 // Has to be adjusted because of 'use_fancy_tab_bar = false'
config.window_decorations = "RESIZE"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false
-- config.tab_max_width = 16
config.show_tabs_in_tab_bar = true

config.send_composed_key_when_left_alt_is_pressed = false

function tab_title(tab_info)
	local title = tab_info.tab_title

	if title and #title > 0 then
		return title
	end

	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	local title = tab_title(tab)
	title = wezterm.truncate_right(title, max_width - 2)
	if tab.is_active then
		return {
			{ Foreground = { Color = "#fbf1c7" } },
			{ Background = { Color = "#665c54" } },
			{ Text = " " .. title .. "   " },
		}
	else
		return {
			{ Foreground = { Color = "#a89984" } },
			{ Background = { Color = "#3c3836" } },
			{ Text = " " .. title .. " " },
		}
	end
end)

wezterm.on("open-workspace", function(window, pane)
	workspaces.open_workspace(window, pane)
end)

config.keys = {
	{
		key = "l",
		mods = "ALT",
		action = wezterm.action.ShowLauncher,
	},
	{
		key = "|",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "CTRL",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "t",
		mods = "SUPER",
		action = wezterm.action.SpawnCommandInNewTab({
			cwd = "~/",
		}),
	},
	{
		key = "p",
		mods = "SUPER",
		action = wezterm.action.EmitEvent("open-workspace"),
	},
}

return config
