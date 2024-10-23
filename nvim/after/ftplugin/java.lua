-- Google java format indentation
vim.bo.tabstop = 8
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

if vim.fn.executable("java") == 0 then
	vim.notify("Java Not Found", vim.log.levels.WARN)
	return
end

-- press F5 to cd to directory, javac %
vim.keymap.set("n", "<F5>", ":<C-u>cd %:p:h<BAR>:update<BAR>exec 'term javac' shellescape(@%)<CR>", { buffer = true })
vim.keymap.set({ "i", "x" }, "<F5>", "<ESC><F5>", { buffer = true, remap = true })

-- press F8 to cd to directory, java %<
vim.keymap.set("n", "<F8>", ":<C-u>cd %:p:h<BAR>exec 'term java' shellescape(expand('%<'))<CR>", { buffer = true })
vim.keymap.set({ "i", "x" }, "<F8>", "<ESC><F8>", { buffer = true, remap = true })

-- Below only makes sense if nvim-jdtls is installed
local has_jdtls, jdtls = pcall(require, "jdtls")
if not has_jdtls then
	vim.notify("Nvim-jdtls Not Found", vim.log.levels.WARN)
	return
end

-- https://github.com/mfussenegger/nvim-jdtls#Configuration-verbose
-- Only verbose config version works. Quickstart doens't work
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = "C:\\code\\java\\" .. project_name

local jdtls_dir = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local config_dir = jdtls_dir .. "/config_win"
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
-- Must point to the                      Change to one of `linux`, `win` or `mac`
-- eclipse.jdt.ls installation            Depending on your system.
local path_to_jar = jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_1.6.600.v20231106-1826.jar"
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
-- Must point to the                                                     Change this to
-- eclipse.jdt.ls installation                                           the actual version
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
local lsp_capabilities = require("coq").lsp_ensure_capabilities().capabilities
local jdtls_capabilities = {
	workspace = {
		configuration = true,
	},
	textDocument = {
		completion = {
			completionItem = {
				snippetSupport = true,
			},
		},
	},
}
local capabilities = vim.tbl_deep_extend("force", lsp_capabilities, jdtls_capabilities)
local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.onCompletionItemSelectedCommand = "editor.action.triggerParameterHints"

-- keymaps are handled globally by LspAttach autocmd

local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {
		-- 💀
		"java", -- or '/path/to/java17_or_newer/bin/java'
		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- 💀
		"-jar",
		path_to_jar,

		-- 💀
		"-configuration",
		config_dir,

		-- 💀
		-- See `data directory configuration` section in the README
		"-data",
		workspace_dir,
	},
	-- 💀
	-- This is the default if not provided, you can remove it. Or adjust as needed.
	-- One dedicated LSP server & client will be started per unique root_dir
	root_dir = root_dir,
	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			format = { enabled = false },
		},
	},
	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = {},
		extendedClientCapabilities = extendedClientCapabilities,
	},
	capabilities = capabilities,
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
