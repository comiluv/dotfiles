return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		cmd = "TSUpdate",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		build = ":TSUpdate",
		dependencies = {
			-- auto close block with end
			{ "RRethy/nvim-treesitter-endwise" },

			-- jump to matching parens
			{
				"andymass/vim-matchup",
				config = function()
					vim.g.matchup_matchparen_offscreen = { method = "popup" }
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
		},
		opts = {
-- stylua: ignore
			ensure_installed = {
"bash","c","c_sharp","cmake","cpp","css","csv","diff","dockerfile","editorconfig","git_config","gitattributes","gitcommit","gitignore","go","haskell","html","htmldjango","java","javascript","jsdoc","json","jsonc","kotlin","lua","make","markdown","markdown_inline","pascal","php","powershell","python","rust","sql","squirrel","tsv","typescript","vim","vimdoc","xml","yaml","zig"
			},
			ignore_install = { "ini" },
			sync_install = false,
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = false },
			endwise = { enable = true }, -- "RRethy/nvim-treesitter-endwise",
			matchup = { enable = true }, -- "andymass/vim-matchup",
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
