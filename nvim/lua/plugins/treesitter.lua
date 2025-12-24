return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		cmd = "TSUpdate",
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		build = ":TSUpdate",
		dependencies = {
			{ "folke/ts-comments.nvim", opts = {} },
			{ "andymass/vim-matchup" },
			{ "RRethy/nvim-treesitter-endwise" },
		},
		opts = {},
		config = function(_, opts)
			local ensure_installed = {}
			require("nvim-treesitter").install(ensure_installed)
			vim.api.nvim_create_autocmd({ "Filetype" }, {
				callback = function(event)
					if vim.tbl_contains(vim.g.info_filetype, event.match) then
						return
					end
					-- skip for large files
					local max_filesize = 100 * 1024 -- 100 KB
					local filesize_ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(event.buf))
					if not filesize_ok or stats and stats.size > max_filesize then
						return true
					end
					-- make sure nvim-treesitter is loaded
					local ok, nvim_treesitter = pcall(require, "nvim-treesitter")
					-- no nvim-treesitter, maybe fresh install
					if not ok then
						return
					end
					local ft = vim.bo[event.buf].ft
					local lang = vim.treesitter.language.get_lang(ft)
					nvim_treesitter.install({ lang }):await(function(err)
						if err then
							vim.notify("Treesitter install error for ft: " .. ft .. " err: " .. err)
							return
						end

						pcall(vim.treesitter.start, event.buf)
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					end)
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		init = function()
			-- PERF: no need to load the plugin, if we only need its queries for mini.ai
			local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
			local opts = require("lazy.core.plugin").values(plugin, "opts", false)
			local enabled = false
			if opts.textobjects then
				for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
					if opts.textobjects[mod] and opts.textobjects[mod].enable then
						enabled = true
						break
					end
				end
			end
			if not enabled then
				require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
			end
		end,
	},
}
