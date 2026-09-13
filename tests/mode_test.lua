local mode = require("vyBufline.mode")

local function test_hl_normal()
	local hl = mode.hl("n")
	assert(hl == "vyNormalMode", "normal mode hl should be vyNormalMode, got: " .. hl)
	print("PASS: hl normal")
end

local function test_hl_visual()
	local hl = mode.hl("v")
	assert(hl == "vyVisualMode", "visual mode hl should be vyVisualMode, got: " .. hl)
	print("PASS: hl visual")
end

local function test_hl_unknown()
	local hl = mode.hl("xyz")
	assert(hl == "vyNormalMode", "unknown mode should fallback to vyNormalMode")
	print("PASS: hl unknown fallback")
end

local function test_icon()
	local icon = mode.icon("n")
	assert(type(icon) == "string", "icon should be a string")
	print("PASS: icon")
end

local function test_get()
	local m = mode.get("i")
	assert(m ~= nil, "get should return a table")
	assert(m[1] == "INSERT", "first element should be label")
	assert(m[2] == "vyInsertMode", "second element should be hl group")
	print("PASS: get")
end

test_hl_normal()
test_hl_visual()
test_hl_unknown()
test_icon()
test_get()
