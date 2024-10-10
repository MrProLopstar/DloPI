@echo off
chcp 65001 >nul

echo Запуск скрипта...

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

echo Проверка наличия процесса winws.exe...
tasklist /FI "IMAGENAME eq winws.exe" 2>NUL | find /I "winws.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo Завершение процесса winws.exe...
    taskkill /F /IM winws.exe >nul
) else (
    echo Процесс winws.exe не запущен.
)

set "exe=%~dp0dpi\winws.exe"
if not exist "%exe%" (
    echo Ошибка: Файл winws.exe не найден по пути "%exe%".
    pause
    exit /b
) else (
    echo winws.exe найден по пути "%exe%".
)

set "params=--wf-tcp=443-65535 --wf-udp=443-65535 --filter-udp=443 --hostlist=%~dp0dpi\list-discord.txt --hostlist=%~dp0dpi\list-youtube.txt --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=%~dp0dpi\quic_initial_www_google_com.bin --new --filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-fake-quic=%~dp0dpi\quic_initial_www_google_com.bin --filter-tcp=443 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls=%~dp0dpi\tls_clienthello_www_google_com.bin"

if exist "%~dp0dpi\list-domains.txt" (
    echo Добавление list-domains.txt...
    set "params=%params% --hostlist=%~dp0list-domains.txt"
)
if exist "%~dp0dpi\list-customs-domains.txt" (
    echo Добавление list-customs-domains.txt...
    set "params=%params% --hostlist=%~dp0list-customs-domains.txt"
)

echo Параметры запуска:
echo %params%

echo Запуск winws.exe и перенаправление вывода в winws_log.txt и winws_error.log...
powershell -Command "Start-Process -FilePath '%exe%' -ArgumentList '%params%' -WindowStyle Hidden -RedirectStandardOutput '%~dp0dpi\winws_log.txt' -RedirectStandardError '%~dp0dpi\winws_error.log'"

if "%ERRORLEVEL%" NEQ "0" (
    echo Ошибка при запуске winws.exe с кодом %ERRORLEVEL%.
) else (
    echo winws.exe успешно запущен.
)

echo Сценарий завершён.
exit
