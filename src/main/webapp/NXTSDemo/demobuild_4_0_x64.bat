@echo off

set  PROG_PATH=%ProgramFiles%
SET TK_DIR=%SystemRoot%\System32

:start
echo "ProgramFiles is %PROG_PATH%"
SET TK_HOME="%PROG_PATH%\KTNET\SCORE PKI ToolKit for .NET"
REM .NET Directory 의 경로입니다. 변경하지 마세요.
set NET_ROOT_DIR=%SystemRoot%\Microsoft.NET\Framework64
set DEMO_DIR="C:\inetpub\wwwroot\NetToolkitDemo"

if not exist %DEMO_DIR%\bin  md %DEMO_DIR%\bin


REM .NET 4.0의 경로입니다.
set NET_DIR=%NET_ROOT_DIR%\v4.0.30319

REM Path 에 추가(csc.exe)
set PATH=%NET_DIR%;%PATH%

echo "Compiling ToolKit Demo..."

csc /platform:x64 /noconfig  /nologo /target:library /r:System.dll /r:System.Web.dll /r:System.Drawing.dll /r:System.Data.dll /r:System.Configuration.dll /r:%TK_DIR%\TSAPI_NET_VS100.dll /out:%DEMO_DIR%\bin\NetToolkitDemo.dll /recurse:%DEMO_DIR%\*.cs 

pause