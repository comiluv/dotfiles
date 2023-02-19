-- Google java format indentation
vim.bo.tabstop = 8
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

-- press F5 to cd to directory, javac %
vim.keymap.set("n", "<F5>", ":<C-u>cd %:p:h<BAR>:w<BAR>te javac %<CR>", { buffer = true })
vim.keymap.set({ "i", "v" }, "<F5>", "<ESC><F5>", { buffer = true, remap = true })

-- press F8 to cd to directory, java %<
vim.keymap.set("n", "<F8>", ":<C-u>cd %:p:h<BAR>te java %<<CR>", { buffer = true })
vim.keymap.set({ "i", "v" }, "<F8>", "<ESC><F8>", { buffer = true, remap = true })

-- https://github.com/mfussenegger/nvim-jdtls#Configuration-verbose
-- Only verbose config version works. Quickstart doens't work
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = 'C:\\code\\java_headfirst\\' .. project_name

local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {

		-- 💀
		'java', -- or '/path/to/java17_or_newer/bin/java'
		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-Xms1g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',

		-- 💀
		'-jar', 'C:\\Users\\choij\\AppData\\Local\\nvim-data\\mason\\packages\\jdtls\\plugins\\org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
		-- Must point to the                                                     Change this to
		-- eclipse.jdt.ls installation                                           the actual version


		-- 💀
		'-configuration', 'C:\\\\Users\\choij\\AppData\\Local\\nvim-data\\mason\\packages\\jdtls\\config_win',
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
		-- Must point to the                      Change to one of `linux`, `win` or `mac`
		-- eclipse.jdt.ls installation            Depending on your system.


		-- 💀
		-- See `data directory configuration` section in the README
		'-data', workspace_dir,
	},
	-- 💀
	-- This is the default if not provided, you can remove it. Or adjust as needed.
	-- One dedicated LSP server & client will be started per unique root_dir
	root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),
	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {
			signatureHelp = {enabled = true},
		}
	},
	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = {}
	},
}

-- Manually copy pasted remaps from lsp.lua because lsp-zero doesn't run jdtls
config['on_attach'] = function(client, bufnr)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
	{ buffer = bufnr, desc = "Go to declaration"})
	vim.keymap.set("n", "gd", vim.lsp.buf.definition,
	{ buffer = bufnr, desc = "Go to definition" })
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
	{ buffer = bufnr, desc = "Go to implementation"})
	vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references,
	{ buffer = bufnr, desc = "Go to references"})
	vim.keymap.set("n", "K", vim.lsp.buf.hover,
	{ buffer = bufnr, })
	vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol,
	{ buffer = bufnr, desc = "Workspace symbol" })
	vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float,
	{ buffer = bufnr, desc = "View diagnostic" })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
	{ buffer = bufnr, desc = "Next diagnostic" })
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,
	{ buffer = bufnr, desc = "Previous diagnostic" })
	vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action,
	{ buffer = bufnr, desc = "Code action" })
	vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references,
	{ buffer = bufnr, desc = "Open references" })
	vim.keymap.set("n", "<leader>vrn", ":IncRename <C-r><C-w>",
	{ buffer = bufnr, desc = "Rename symbol" })
	vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help,
	{ buffer = bufnr, desc = "Signature help" })

	-- get nvim-navic working with multiple tabs
	if client.server_capabilities["documentSymbolProvider"] then
		require("nvim-navic").attach(client, bufnr)
	end
end

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

