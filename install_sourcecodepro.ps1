Remove-Item -path Fonts -recurse
md Fonts
Invoke-WebRequest -Uri "https://github.com/adobe-fonts/source-code-pro/releases/download/2.030R-ro%2F1.050R-it/source-code-pro-2.030R-ro-1.050R-it.zip" -OutFile "Fonts\scp.zip"
Invoke-Expression "$env:USERPROFILE\scoop\shims\7z.exe x Fonts\scp.zip -oFonts\scp"
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
dir Fonts\scp\source-code-pro-2.030R-ro-1.050R-it\TTF\*.ttf | %{ $fonts.CopyHere($_.fullname) }
