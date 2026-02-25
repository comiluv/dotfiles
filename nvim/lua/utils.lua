local M = {}

function M.array_to_table(arr, default_value)
	default_value = default_value or true
	local tbl = {}
	for _, v in ipairs(arr) do
		tbl[v] = default_value
	end
	return tbl
end

-- taken from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua
function M.is_loaded(name)
	local Config = require("lazy.core.config")
	return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
	if M.is_loaded(name) then
		fn(name)
	else
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyLoad",
			callback = function(event)
				if event.data == name then
					fn(name)
					return true
				end
			end,
		})
	end
end

-- taken from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/mini.lua
-- taken from MiniExtra.gen_ai_spec.buffer
function M.ai_buffer(ai_type)
	local start_line, end_line = 1, vim.api.nvim_buf_line_count(0)
	if ai_type == "i" then
		-- Skip first and last blank lines for `i` textobject
		local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
		-- Do nothing for buffer with all blanks
		if first_nonblank == 0 or last_nonblank == 0 then
			return { from = { line = start_line, col = 1 } }
		end
		start_line, end_line = first_nonblank, last_nonblank
	end

	local to_col = math.max(#vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, true)[1], 1)
	return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end
-- register all text objects with which-key
---@param opts table
function M.ai_whichkey(opts)
	local objects = {
		{ " ", desc = "whitespace" },
		{ '"', desc = '" string' },
		{ "'", desc = "' string" },
		{ "(", desc = "() block" },
		{ ")", desc = "() block with ws" },
		{ "<", desc = "<> block" },
		{ ">", desc = "<> block with ws" },
		{ "?", desc = "user prompt" },
		{ "U", desc = "use/call without dot" },
		{ "[", desc = "[] block" },
		{ "]", desc = "[] block with ws" },
		{ "_", desc = "underscore" },
		{ "`", desc = "` string" },
		{ "a", desc = "argument" },
		{ "b", desc = ")]} block" },
		{ "c", desc = "class" },
		{ "d", desc = "digit(s)" },
		{ "e", desc = "CamelCase / snake_case" },
		{ "f", desc = "function" },
		{ "g", desc = "entire file" },
		{ "i", desc = "indent" },
		{ "o", desc = "block, conditional, loop" },
		{ "q", desc = "quote `\"'" },
		{ "t", desc = "tag" },
		{ "u", desc = "use/call" },
		{ "{", desc = "{} block" },
		{ "}", desc = "{} with ws" },
	}

	---@type wk.Spec[]
	local ret = { mode = { "o", "x" } }
	---@type table<string, string>
	local mappings = vim.tbl_extend("force", {}, {
		around = "a",
		inside = "i",
		around_next = "an",
		inside_next = "in",
		around_last = "al",
		inside_last = "il",
	}, opts.mappings or {})
	mappings.goto_left = nil
	mappings.goto_right = nil

	for name, prefix in pairs(mappings) do
		name = name:gsub("^around_", ""):gsub("^inside_", "")
		ret[#ret + 1] = { prefix, group = name }
		for _, obj in ipairs(objects) do
			local desc = obj.desc
			if prefix:sub(1, 1) == "i" then
				desc = desc:gsub(" with ws", "")
			end
			ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
		end
	end
	require("which-key").add(ret, { notify = false })
end

return M
