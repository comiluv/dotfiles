local M = {}

function M.array_to_table(arr, default_value)
	default_value = default_value or true
	local tbl = {}
	for _, v in ipairs(arr) do
		tbl[v] = default_value
	end
	return tbl
end

return M
