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


REM .NET 2.0의 경로입니다.
REM 2.0과 3.x의 CLR은 호환되므로 3.0과 ,3.5일 경우에도 아래의 경로를 사용하시면 됩니다.
set NET_DIR=%NET_ROOT_DIR%\v2.0.50727

REM Path 에 추가(csc.exe)
set PATH=%NET_DIR%;%PATH%

echo "Compiling ToolKit Demo..."

csc /platform:x64 /noconfig  /nologo /target:library /r:System.dll /r:System.Web.dll /r:System.Drawing.dll /r:System.Data.dll /r:%TK_DIR%\TSAPI_NET_VS80_x64.dll /out:%DEMO_DIR%\bin\NetToolkitDemo.dll /recurse:%DEMO_DIR%\*.cs 

pause