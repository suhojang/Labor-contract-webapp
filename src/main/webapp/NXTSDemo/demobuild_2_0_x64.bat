@echo off

set  PROG_PATH=%ProgramFiles%
SET TK_DIR=%SystemRoot%\System32

:start
echo "ProgramFiles is %PROG_PATH%"
SET TK_HOME="%PROG_PATH%\KTNET\SCORE PKI ToolKit for .NET"
REM .NET Directory �� ����Դϴ�. �������� ������.
set NET_ROOT_DIR=%SystemRoot%\Microsoft.NET\Framework64
set DEMO_DIR="C:\inetpub\wwwroot\NetToolkitDemo"

if not exist %DEMO_DIR%\bin  md %DEMO_DIR%\bin


REM .NET 2.0�� ����Դϴ�.
REM 2.0�� 3.x�� CLR�� ȣȯ�ǹǷ� 3.0�� ,3.5�� ��쿡�� �Ʒ��� ��θ� ����Ͻø� �˴ϴ�.
set NET_DIR=%NET_ROOT_DIR%\v2.0.50727

REM Path �� �߰�(csc.exe)
set PATH=%NET_DIR%;%PATH%

echo "Compiling ToolKit Demo..."

csc /platform:x64 /noconfig  /nologo /target:library /r:System.dll /r:System.Web.dll /r:System.Drawing.dll /r:System.Data.dll /r:%TK_DIR%\TSAPI_NET_VS80_x64.dll /out:%DEMO_DIR%\bin\NetToolkitDemo.dll /recurse:%DEMO_DIR%\*.cs 

pause