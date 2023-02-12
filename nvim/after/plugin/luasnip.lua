local ok, types = pcall(require, 'luasnip.util.types')
if not ok then return end
-- https://github.com/L3MON4D3/LuaSnip/wiki/Nice-Configs

require'luasnip'.config.setup({
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = {{"●", "GruvboxOrange"}}
			}
		},
		[types.insertNode] = {
			active = {
				virt_text = {{"●", "GruvboxBlue"}}
			}
		}
	},
})

