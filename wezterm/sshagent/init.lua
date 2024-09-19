local wezterm = require("wezterm")
local sshagent = {}
local cache_file = "/Users/anon/.config/wezterm/sshagent/cache/users.lua"

local function table_contains(tbl, item)
    for _, value in ipairs(tbl) do
        if value == item then
            return true
        end
    end
    return false
end

local function read_cache()
    local file, err = loadfile(cache_file)
    if not file then
        wezterm.log_error("Failed to read cache: " .. err)
        return {}
    end
    return file()
end

local function write_cache(hosts)
    local file, err = io.open(cache_file, "w")
    if not file then
        wezterm.log_error("Failed to write cache: " .. err)
        return
    end
    file:write("return {\n")
    for host, users in pairs(hosts) do
        file:write(string.format("  [%q] = {", host))
        for _, user in ipairs(users) do
            file:write(string.format("%q, ", user))
        end
        file:write("},\n")
    end
    file:write("}\n")
    file:close()
end

local function update_cache(host, user)
    local hosts = read_cache()
    if not hosts[host] then
        hosts[host] = {}
    end
    if not table_contains(hosts[host], user) then
        table.insert(hosts[host], user)
    end
    write_cache(hosts)
end

local function connect_ssh(window, pane, user, host)
    local ssh_command = string.format("ssh -Y %s@%s", user, host)
    window:perform_action(wezterm.action.SpawnCommandInNewTab({ args = { "bash", "-c", ssh_command } }), pane)
    update_cache(host, user)
end

local function prompt_new_user(window, pane, host)
    window:perform_action(
        wezterm.action.PromptInputLine({
            description = "Enter new user:",
            action = wezterm.action_callback(function(window, pane, line)
                if line and line ~= "" then
                    connect_ssh(window, pane, line, host)
                end
            end),
        }),
        pane
    )
end

local function select_user(window, pane, host)
    local cache = read_cache()
    local users = cache[host] or {}
    local user_choices = {{ label = "Add new user" }}
    for _, user in ipairs(users) do
        table.insert(user_choices, { label = user })
    end

    window:perform_action(
        wezterm.action.InputSelector({
            action = wezterm.action_callback(function(window, pane, id, user)
                if user == "Add new user" then
                    prompt_new_user(window, pane, host)
                elseif user then
                    connect_ssh(window, pane, user, host)
                end
            end),
            title = "Select User for " .. host,
            choices = user_choices,
            fuzzy = true,
            fuzzy_description = "Select or add a user: ",
        }),
        pane
    )
end

function sshagent.connect_to_server(window, pane)
    local hosts = {}
    local file, err = io.open("/Users/anon/.ssh/known_hosts", "r")
    if not file then
        wezterm.log_error("Failed to read known hosts: " .. err)
        return
    end

    for line in file:lines() do
        local host = line:match("^[^%s,]+")
        if host and not hosts[host] then
            hosts[host] = true
        end
    end

    file:close()

    local choices = {}
    for host, _ in pairs(hosts) do
        table.insert(choices, { label = host })
    end

    window:perform_action(
        wezterm.action.InputSelector({
            action = wezterm.action_callback(function(window, pane, id, host)
                if host then
                    select_user(window, pane, host)
                end
            end),
            title = "SSH Connections",
            choices = choices,
            fuzzy = true,
            fuzzy_description = "Select a server to connect: ",
        }),
        pane
    )
end

return sshagent
