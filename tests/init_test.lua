local bufline = require("vyBufline")

local function test_setup()
	bufline.setup()
	assert(vim.o.showtabline == 2, "showtabline should be 2")
	assert(vim.o.tabline ~= "", "tabline should be set")
	print("PASS: setup")
end

local function test_generate()
	local result = bufline.generate()
	assert(type(result) == "string", "generate should return string")
	assert(#result > 0, "generate should return non-empty string")
	print("PASS: generate")
end

local function test_navigation()
	-- Should not error when called
	bufline.next()
	bufline.prev()
	print("PASS: navigation")
end

test_setup()
test_generate()
test_navigation()
