# See https://github.com/L3MON4D3/LuaSnip/issues/1190#issuecomment-2171656749
$find = '$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@'
$replace = '$(CC) $^ $(LDLIBS) -o $@ $(LDFLAGS)'

$file = '.\deps\jsregexp\Makefile'
If (!(Test-Path $file))
{
	throw '\deps\jsregexp not found'
}
(Get-Content $file).replace($find, $replace) | Set-Content $file
$file = '.\deps\jsregexp005\Makefile'
If (!(Test-Path $file))
{
	throw '\deps\jsregexp005 not found'
}
(Get-Content $file).replace($find, $replace) | Set-Content $file

$env:CHERE_INVOKING = 'yes' # Keep current Directory
$env:MSYSTEM = 'UCRT64' # https://www.msys2.org/docs/environments/
C:\msys64\usr\bin\bash -lc 'pacman --noconfirm -Syu'
C:\msys64\usr\bin\bash -lc 'pacman --noconfirm --needed -S git'
C:\msys64\usr\bin\bash -lc 'pacman --noconfirm --needed -S mingw-w64-ucrt-x86_64-luajit mingw-w64-ucrt-x86_64-make mingw-w64-ucrt-x86_64-gcc'
C:\msys64\usr\bin\bash -lc 'mingw32-make CC=gcc CFLAGS="-I/ucrt64/include/luajit-2.1 -O2 -Wall -fPIC" LDFLAGS="-shared -lluajit-5.1" install_jsregexp'

