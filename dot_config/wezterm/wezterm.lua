-- Pull in the wezterm API
local wezterm = require("wezterm")
local wez_funcs = require("wezterm_functions")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This will hold the action ability of wezterm
local act = wezterm.action

-- This will hold the multiplexer
local mux = wezterm.mux

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "Solarized (dark) (terminal.sexy)"
-- config.color_scheme = "s3r0 modified (terminal.sexy)"
-- config.color_scheme = "GruvboxDark"
config.color_scheme = "GruvboxDark"
config.font = wezterm.font("JetBrains Mono")
config.harfbuzz_features = { "calt=0" }
config.default_prog = { "pwsh.exe" }

-- Keymappings
config.leader = { key = "`", timeout_milliseconds = 750 }
config.keys = {
	{
		mods = "LEADER",
		key = "e",
		action = act.SendKey({
			key = "`",
		}),
	},
	-- splitting panes
	{
		mods = "LEADER",
		key = "-",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "\\",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "Space",
		action = act.RotatePanes("Clockwise"),
	},
	{
		mods = "LEADER",
		key = "Enter",
		action = act.ActivateCopyMode,
	},
	{
		mods = "LEADER",
		key = "0",
		action = act.PaneSelect({
			mode = "SwapWithActive",
		}),
	},

	-- window management
	{
		mods = "LEADER",
		key = "c",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "l",
		action = act.ActivateLastTab,
	},
	{
		mods = "LEADER",
		key = "x",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	{ key = "LeftArrow", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
	{ key = "RightArrow", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
}

-- add tab navigation
for i = 1, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

-- workspace management
-- print the workspace name at the upper right
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

wezterm.on("create_workspace", wez_funcs.create_workspace)

-- load plugin
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
-- keymaps
table.insert(config.keys, { key = "s", mods = "LEADER", action = workspace_switcher.switch_workspace() })
table.insert(config.keys, { key = "t", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) })
table.insert(config.keys, { key = "r", mods = "LEADER", action = wezterm.action.EmitEvent("create_workspace") })
table.insert(config.keys, { key = "d", mods = "LEADER", action = wezterm.action.ShowDebugOverlay })
table.insert(config.keys, { key = "[", mods = "LEADER", action = act.SwitchWorkspaceRelative(1) })
table.insert(config.keys, { key = "]", mods = "LEADER", action = act.SwitchWorkspaceRelative(-1) })

-- wezterm config stuff for neovim
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

-- and finally, return the configuration to wezterm
return config
