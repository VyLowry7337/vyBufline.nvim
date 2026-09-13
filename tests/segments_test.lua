local segments = require("vyBufline.segments")

local function test_hl()
	local result = segments.hl("BufOn")
	assert(result == "%#vyBufOn#", "should return highlight ref")
	print("PASS: hl")
end

local function test_clickable()
	local result = segments.clickable("test", "GoToBuf", 42)
	assert(result == "%42@vyGoToBuf@test%X", "should wrap in click handler")
	print("PASS: clickable")
end

local function test_buf_name_no_name()
	local buf = vim.api.nvim_create_buf(true, false)
	local name = segments.buf_name(buf)
	assert(name == "No Name", "unnamed buffer should return 'No Name'")
	vim.api.nvim_buf_delete(buf, { force = true })
	print("PASS: buf_name no name")
end

local function test_get_icon()
	local icon, hl = segments.get_icon("test.lua")
	assert(type(icon) == "string", "icon should be a string")
	assert(#icon > 0, "icon should not be empty")
	print("PASS: get_icon")
end

test_hl()
test_clickable()
test_buf_name_no_name()
test_get_icon()
