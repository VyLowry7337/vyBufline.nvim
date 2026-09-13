local config = require("vyBufline.config")

local function test_defaults()
	config.setup()
	local opts = config.get()
	assert(opts.align == "center", "default align should be 'center'")
	assert(opts.icons == true, "default icons should be true")
	assert(opts.separator == "", "default separator should be empty")
	print("PASS: defaults")
end

local function test_merge()
	config.setup({ align = "right", icons = false })
	local opts = config.get()
	assert(opts.align == "right", "align should be overridden to 'right'")
	assert(opts.icons == false, "icons should be overridden to false")
	assert(opts.separator == "", "separator should remain default")
	print("PASS: merge")
end

test_defaults()
test_merge()
