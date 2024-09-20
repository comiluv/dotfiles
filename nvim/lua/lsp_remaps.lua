local M = {}

function M.create_remaps()
	-- create remaps
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("LspRemaps", {}),
		callback = function(ev)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
			vim.keymap.set(
				"n",
				"gd",
				"<cmd>Telescope lsp_definitions<cr>",
				{ buffer = ev.buf, desc = "Go to definition" }
			)
			vim.keymap.set(
				"n",
				"gi",
				"<cmd>Telescope lsp_implementations<cr>",
				{ buffer = ev.buf, desc = "Go to implementation" }
			)
			vim.keymap.set(
				"n",
				"gr",
				"<cmd>Telescope lsp_references<cr>",
				{ buffer = ev.buf, desc = "List references" }
			)
			vim.keymap.set(
				"n",
				"go",
				"<cmd>Telescope lsp_type_definitions<cr>",
				{ buffer = ev.buf, desc = "Go to type definition" }
			)
			vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature help" })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf })
			vim.keymap.set(
				"n",
				"<leader>vws",
				vim.lsp.buf.workspace_symbol,
				{ buffer = ev.buf, desc = "Workspace symbol" }
			)
			vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = ev.buf, desc = "Show diagnostic" })
			vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { buffer = ev.buf, desc = "View diagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = ev.buf, desc = "Next diagnostic" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = ev.buf, desc = "Previous diagnostic" })
			vim.keymap.set("n", "<leader>x", function()
				require("telescope.builtin").diagnostics({ bufnr = 0 })
			end, { buffer = ev.buf, desc = "Diagnostics Quickfix" })
			vim.keymap.set("n", "<A-6>", function()
				require("telescope.builtin").diagnostics({ bufnr = 0 })
			end, { buffer = ev.buf, desc = "Diagnostics Quickfix" })
			vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
			vim.keymap.set(
				"n",
				"<leader>vrr",
				"<cmd>Telescope lsp_references<cr>",
				{ buffer = ev.buf, desc = "Open references" }
			)
			vim.keymap.set("n", "<leader>ss", function()
				require("telescope.builtin").lsp_document_symbols({
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				})
			end, { buffer = ev.buf, desc = "Goto Symbol" })
			vim.keymap.set("n", "<leader>sS", function()
				require("telescope.builtin").lsp_workspace_symbols({
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				})
			end, { buffer = ev.buf, desc = "Goto Symbol (Workspace)" })
			vim.keymap.set("n", "<f2>", ":IncRename <C-r><C-w>", { buffer = ev.buf, desc = "Rename symbol" })
			vim.keymap.set("n", "<leader>vrn", ":IncRename <C-r><C-w>", { buffer = ev.buf, desc = "Rename symbol" })
			vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature help" })
		end,
	})
end

return M
