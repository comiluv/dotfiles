require('code_runner').setup({
  -- put here the commands by filetype
  filetype = {
		java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
		python = "python3 -u",
		typescript = "deno run",
		rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
        c = "cd $dir && make $fileNameWithoutExt && $dir/$fileNameWithoutExt.exe",
        cpp = "cd $dir && make $fileNameWithoutExt && $dir/$fileNameWithoutExt.exe",
	},
})
