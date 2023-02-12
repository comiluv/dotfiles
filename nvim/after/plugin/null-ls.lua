local ok, null_ls = pcall(require, "null-ls")
if not ok then return end

local sources = {
    -- python
    null_ls.builtins.formatting.black.with({
        extra_args = { "--line-length=120" }
    }),
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.google_java_format,
}

null_ls.setup({ sources = sources })

