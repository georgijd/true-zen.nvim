local service = require("true-zen.services.modes.mode-ataraxis.service")
-- local truezen = require("true-zen.init")

local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

local M = {}

local function get_status()
    return status_mode_ataraxis
end

local function set_status(value)
    status_mode_ataraxis = value
end

local function eval_main_window()
    vim.cmd(
        [[windo if &ma | if exists("b:truezen_main_window_id") | let g:truezen_main_window = b:truezen_main_window_id | endif | endif]]
    )
end

local function autocmds(state)
    if (state == "start") then
        api.nvim_exec(
            [[
			augroup truezen_mode_ataraxis
				autocmd!
				autocmd WinEnter * if exists("w:truezen_window") | execute "lua require'true-zen.services.modes.mode-ataraxis.init'.resume()" | endif
			augroup END
		]],
            false
        )
    elseif (state == "stop") then
        api.nvim_exec([[
			augroup truezen_mode_ataraxis
				autocmd!
			augroup END
		]], false)
    end
end

local function get_win_dimensions()
    local dimensions = {}
    dimensions["x_axis"] = api.nvim_eval([[winwidth('%')]])
    dimensions["y_axis"] = api.nvim_eval([[winheight('%')]])

    return dimensions
end

local function on()
    service.on()
    autocmds("start")
    set_status("on")
end

local function off()
    autocmds("stop")
    service.off()
    set_status("off")
end

function M.resume()
    if (service.get_layout() ~= api.nvim_eval("winrestcmd()")) then
        print("closing all windows without truezen_buffer var...")
        print("load layout...")
        print("getting id of only the window that is modifiable...")
        print("going to the main window by id...")
    else
        print("Layout is still the same")
    end
end

local function toggle()
    if (get_status() == "on") then
        off()
    else
        on()
    end
end

function M.main(option)
    option = option or 0

    if (option == "toggle") then
        toggle()
    elseif (option == "on") then
        on()
    elseif (option == "off") then
        off()
    end
end

return M
