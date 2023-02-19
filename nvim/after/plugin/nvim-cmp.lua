local ok, cmp_autopairs = pcall(require,'nvim-autopairs.completion.cmp')
if not ok then return end

-- If you want insert `(` after select function or method item
local cmp = require('cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

-- autopairs: add mapping `CR` on nvim-cmp setup. Check readme.md on nvim-cmp repo
local handlers = require('nvim-autopairs.completion.handlers')

cmp.event:on(
'confirm_done',
cmp_autopairs.on_confirm_done({
	filetypes = {
		-- "*" is a alias to all filetypes
		["*"] = {
			["("] = {
				kind = {
					cmp.lsp.CompletionItemKind.Function,
					cmp.lsp.CompletionItemKind.Method,
				},
				handler = handlers["*"]
			}
		},
		lua = {
			["("] = {
				kind = {
					cmp.lsp.CompletionItemKind.Function,
					cmp.lsp.CompletionItemKind.Method
				},
				---@param char string
				---@param item table item completion
				---@param bufnr number buffer number
				---@param rules table
				---@param commit_character table<string>
				handler = function(char, item, bufnr, rules, commit_character)
					-- Your handler function. Inpect with print(vim.inspect{char, item, bufnr, rules, commit_character})
				end
			}
		},
		-- Disable for tex
		tex = false
	}
})
)

