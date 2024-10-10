@echo off
chcp 65001 >nul

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Требуются права администратора. Перезапуск с правами...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

set "scriptPath=%~dp0%~nx0"
set "shortcutName=winws-autostart"
set "startupFolder=%AppData%\Microsoft\Windows\Start Menu\Programs\Startup"
set "shortcut=%startupFolder%\%shortcutName%.lnk"

if not exist "%shortcut%" (
    echo Создание ярлыка для автозапуска...
    powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%shortcut%'); $s.TargetPath = '%scriptPath%'; $s.Save()"
    echo Ярлык создан.
) else (
    echo Ярлык для автозапуска уже существует.
)

tasklist /FI "IMAGENAME eq winws.exe" 2>NUL | find /I "winws.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo Завершение процесса winws.exe...
    taskkill /F /IM winws.exe >nul
)

set exe=%~dp0dpi\winws.exe
set params=--wf-tcp=443-65535 --wf-udp=443-65535 --filter-udp=443 --hostlist="%~dp0list-discord.txt" --hostlist="%~dp0list-youtube.txt"

if exist "%~dp0list-domains.txt" (
    echo Добавление файла list-domains.txt...
    set params=%params% --hostlist="%~dp0list-domains.txt"
)

if exist "%~dp0list-customs-domains.txt" (
    echo Добавление файла list-customs-domains.txt...
    set params=%params% --hostlist="%~dp0list-customs-domains.txt"
)

set params=%params% --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0dpi\quic_initial_www_google_com.bin" --new --filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-fake-quic="%~dp0dpi\quic_initial_www_google_com.bin" --filter-tcp=443 --dpi-desync-fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls="%~dp0dpi\tls_clienthello_www_google_com.bin"

powershell -WindowStyle Hidden -Command "Start-Process '%exe%' '%params%' -WindowStyle Hidden"

exit
