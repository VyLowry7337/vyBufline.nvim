local explorer = require("vyBufline.explorer")

local function test_returns_number()
	local w = explorer.get_explorer_width()
	assert(type(w) == "number", "should return a number")
	assert(w >= 0, "width should be non-negative")
	print("PASS: returns number")
end

test_returns_number()
