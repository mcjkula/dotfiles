local wezterm = require("wezterm")
local workspaces = {}
local cache_file = "/Users/anon/.config/wezterm/workspace-manager/cache/history.lua"
local MAX_DEPTH = 2

local function read_cache()
	local file, err = loadfile(cache_file)
	if not file then
		wezterm.log_error("Failed to read cache: " .. err)
		return nil
	end
	return file()
end

local function write_cache(dirs)
	local file, err = io.open(cache_file, "w")
	if not file then
		wezterm.log_error("Failed to write cache: " .. err)
		return
	end
	file:write("return {\n")
	for _, dir in ipairs(dirs) do
		file:write(string.format("  {dir = %q, count = %d, last_used = %d},\n", dir.dir, dir.count, dir.last_used))
	end
	file:write("}\n")
	file:close()
end

local function find_dir(dirs, dir)
	for _, d in ipairs(dirs) do
		if d.dir == dir then
			return d
		end
	end
	return nil
end

local function filter_dirs(dirs, blacklist)
	local filtered = {}
	for _, dir in ipairs(dirs) do
		local blacklisted = false
		for _, pattern in ipairs(blacklist) do
			if dir:match(pattern) or dir:match("^" .. pattern:sub(1, -4) .. "$") then
				blacklisted = true
				break
			end
		end
		if not blacklisted then
			table.insert(filtered, dir)
		end
	end
	return filtered
end

local function update_dir(dirs, dir, increment_count)
	local found_dir = find_dir(dirs, dir)
	if found_dir then
		if increment_count then
			found_dir.count = found_dir.count + 1
		end
		found_dir.last_used = os.time()
	else
		table.insert(dirs, { dir = dir, count = 0, last_used = os.time() })
	end
end

local function update_cache()
	local _, stdout, _ = wezterm.run_child_process({
		"find",
		"/Volumes/Transcend/Developer/projects",
		"/Users/anon/.local/share/nvim/lazy/md-pdf.nvim",
		"/Users/anon",
		"/Users/anon/Library/Group Containers/G69SCX94XU.duck/Library/Application Support/duck/Volumes.noindex/Nextcloud/documents",
		"-maxdepth",
		tostring(MAX_DEPTH),
		"-type",
		"d",
	})
	local new_dirs = wezterm.split_by_newlines(stdout)
	local blacklist = {
		--"/Users/anon/Library/.*",
		"/Users/anon/Pictures/.*",
		"/Users/anon/Downloads/.*",
		"/Users/anon/Music/.*",
		"/Users/anon/Documents/.*",
		"/Users/anon/Movies/.*",
		"/Users/anon/Applications/.*",
		"/Users/anon/Desktop/.*",
		"/Users/anon/dbProjects/.*",
		"/Users/anon/qtProjects/.*",
		"/Users/anon/Public/.*",
		"/Users/anon/Zotero/.*",
		"/Users/anon/ptProjects/.*",
		"/Users/anon/Cisco Packet Tracer 8.2.1/.*",
	}
	new_dirs = filter_dirs(new_dirs, blacklist)
	local old_dirs = read_cache() or {}
	for _, new_dir in ipairs(new_dirs) do
		update_dir(old_dirs, new_dir, false)
	end
	local refresh_entry = find_dir(old_dirs, "Refresh Files")
	if not refresh_entry then
		table.insert(old_dirs, 1, { dir = "Refresh Files", count = 0, last_used = 0 })
	end
	write_cache(old_dirs)
end

function workspaces.open_workspace(window, pane)
	local choices = {}
	local dirs = read_cache()

	if dirs then
		for _, dir in ipairs(dirs) do
			table.insert(choices, { label = dir.dir })
		end
	else
		wezterm.log_error("Failed to update cache: dirs is still nil")
	end

	window:perform_action(
		wezterm.action.InputSelector({
			action = wezterm.action_callback(function(_, _, id, label)
                if not label then
                    update_cache()
                end
				if label == "Refresh Files" then
					update_cache()
					workspaces.open_workspace(window, pane)
				else
					local directory = label:match("^.+/(.+)$")

					update_dir(dirs, label, true)
					table.sort(dirs, function(a, b)
						if a.dir == "Refresh Files" then
							return true
						elseif b.dir == "Refresh Files" then
							return false
						elseif a.count == b.count then
							if a.last_used == b.last_used then
								return a.dir < b.dir
							else
								return a.last_used > b.last_used
							end
						else
							return a.count > b.count
						end
					end)
					write_cache(dirs)

					for tab_index, tab in ipairs(window:mux_window():tabs()) do
						if tab:get_title() == directory then
							window:perform_action(wezterm.action.ActivateTab(tab_index - 1), pane)
							window:perform_action(wezterm.action.MoveTab(0), pane)
							return
						end
					end

					local _, _ = window:mux_window():spawn_tab({ cwd = label })
					window:active_tab():set_title(directory)
					window:perform_action(wezterm.action.MoveTab(0), pane)
				end
			end),
			title = "Workspaces",
			choices = choices,
			alphabet = "1234567890abcdefghilmnopqrstuvwxyz",
			fuzzy = true,
			fuzzy_description = "Find Workspace: ",
		}),
		pane
	)
end

return workspaces
