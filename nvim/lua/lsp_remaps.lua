local M = {}

function M.create_remaps()
	-- create remaps
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("LspRemaps", {}),
		callback = function(event)
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end
			map("gD", vim.lsp.buf.declaration, "[G]o to [D]eclaration")
			map("gd", "<cmd>Telescope lsp_definitions<cr>", "[G]o to [d]efinition")
			map("gi", "<cmd>Telescope lsp_implementations<cr>", "[G]o to [i]mplementation")
			map("gr", "<cmd>Telescope lsp_references<cr>", "[G]oto [r]eferences")
			map("go", "<cmd>Telescope lsp_type_definitions<cr>", "[Go] to type definition")
			map("gs", vim.lsp.buf.signature_help, "Signature help")
			map("K", vim.lsp.buf.hover, "Hover over cursor")
			map("gl", vim.diagnostic.open_float, "Show diagnostic")
			map("<leader>vd", vim.diagnostic.open_float, "Show diagnostic")
			map("]d", vim.diagnostic.goto_next, "Next diagnostic")
			map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
			map("<leader>x", function()
				require("telescope.builtin").diagnostics({ bufnr = 0 })
			end, "Diagnostics Quickfix")
			local symbols = {
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
			}
			map("<leader>ss", function()
				require("telescope.builtin").lsp_document_symbols({
					symbols = symbols,
				})
			end, "Document symbols")
			map("<leader>sS", function()
				require("telescope.builtin").lsp_dynamic_workspace_symbols({
					symbols = symbols,
				})
			end, "Workspace symbols")
			map("<f2>", ":IncRename <C-r><C-w>", "Rename symbol")
			map("<C-h>", vim.lsp.buf.signature_help, "Signature help", "i")

			-- The following code creates a keymap to toggle inlay hints in your
			-- code, if the language server you are using supports them
			--
			-- This may be unwanted, since they displace some of your code
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
				map("<leader>th", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				end, "[T]oggle Inlay [H]ints")
			end
		end, -- function end
	})
end

return M
