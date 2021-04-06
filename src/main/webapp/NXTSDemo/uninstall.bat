Msiexec /x {43E17C7C-A7D9-4ED5-935D-C837C6C4960B}

IF EXIST "C:\Inetpub\wwwroot\NetToolkitDemo\TSToolkitConfig.js" GOTO END
del "C:\Inetpub\wwwroot\NetToolkitDemo\bin\NetToolkitDemo.dll"
GOTO END

:END
