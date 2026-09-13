local M = {}

local NORMAL = "vyNormalMode"
local VISUAL = "vyVisualMode"
local SELECT = "vySelectMode"
local INSERT = "vyInsertMode"
local REPLACE = "vyReplaceMode"
local COMMAND = "vyCommandMode"
local CONFIRM = "vyConfirmMode"
local TERMINAL = "vyTerminalMode"
local TERMINAL_OFF = "vyNTerminalMode"

M.modes = {
	["n"] = { "NORMAL", NORMAL, "" },
	["niI"] = { "NORMAL / INSERT", NORMAL, "" },
	["niR"] = { "NORMAL / REPLACE", NORMAL, "" },
	["niV"] = { "NORMAL / V-REPLACE", NORMAL, "" },
	["nt"] = { "TERMINAL_OFF", TERMINAL_OFF, "" },
	["ntT"] = { "TERMINAL_OFF", TERMINAL_OFF, "" },

	["no"] = { "PENDING", NORMAL, "" },
	["nov"] = { "PENDING CHAR", NORMAL, "" },
	["noV"] = { "PENDING LINE", NORMAL, "" },
	["no\22"] = { "PENDING BLOCK", NORMAL, "" },

	["v"] = { "VISUAL", VISUAL, "" },
	["vs"] = { "VISUAL / SELECT", VISUAL, "" },
	["V"] = { "V-LINE", VISUAL, "" },
	["Vs"] = { "V-LINE / SELECT", VISUAL, "" },
	["\22"] = { "V-BLOCK", VISUAL, "" },
	["\22s"] = { "V-BLOCK / SELECT", VISUAL, "" },

	["s"] = { "SELECT", SELECT, "" },
	["S"] = { "S-LINE", SELECT, "" },
	["\19"] = { "S-BLOCK", SELECT, "" },

	["i"] = { "INSERT", INSERT, "" },
	["ic"] = { "INSERT / COMPLETE", INSERT, "" },
	["ix"] = { "INSERT / COMPLETE", INSERT, "" },

	["R"] = { "REPLACE", REPLACE, "" },
	["Rc"] = { "REPLACE / COMPLETE", REPLACE, "" },
	["Rx"] = { "REPLACE / COMPLETE", REPLACE, "" },
	["Rv"] = { "V-REPLACE", REPLACE, "" },
	["Rvc"] = { "V-REPLACE / COMPLETE", REPLACE, "" },
	["Rvx"] = { "V-REPLACE / COMPLETE", REPLACE, "" },

	["c"] = { "COMMAND", COMMAND, "" },
	["cv"] = { "EX", COMMAND, "" },
	["ce"] = { "EX", COMMAND, "" },

	["r"] = { "PROMPT", CONFIRM, "" },
	["rm"] = { "MORE", CONFIRM, "" },
	["r?"] = { "CONFIRM", CONFIRM, "" },
	["x"] = { "CONFIRM", CONFIRM, "" },

	["t"] = { "TERMINAL", TERMINAL, "" },
	["!"] = { "SHELL", TERMINAL, "" },
}

function M.get(mode_key)
	return M.modes[mode_key]
end

function M.hl(mode_key)
	local m = M.modes[mode_key]
	return m and m[2] or NORMAL
end

function M.icon(mode_key)
	local m = M.modes[mode_key]
	return m and m[3] or ""
end

return M
