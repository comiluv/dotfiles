local ok, onedark = pcall(require, "onedark")
if not ok then return end

function ColorMyPencils(color)
    color = color or "onedark"
    vim.cmd.colorscheme(color)
end

ColorMyPencils()
