local wezterm = require("wezterm")
local mux = wezterm.mux

local wezterm_functions = {}

function wezterm_functions.create_workspace(window, pane)
	window:perform_action(
		wezterm.action.PromptInputLine({
			description = "Enter workspace name",
			action = wezterm.action_callback(function(_, workspace_name)
				if workspace_name and workspace_name ~= "" then
					mux.spawn_window({ workspace = { workspace_name } })
					wezterm.log_info("Switched to new workspace: " .. workspace_name)
				else
					wezterm.log_info("Workspace creation cancelled")
				end
			end),
		}),
		pane
	)
end

return wezterm_functions
