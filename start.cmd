@echo off
chcp 65001 >nul

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Требуются права администратора. Перезапуск с правами...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

title DloPI - Управление скриптами
color 0A
cls

echo =======================================================
echo       Добро пожаловать в DloPI Management
echo =======================================================
echo.
echo Описание скриптов:
echo 1) controld - предоставляет доступ к сайтам, заблокированным в России.
echo 2) winws - помогает обходить блокировки РКН (например, YouTube, Discord).
echo 4) Остановить оба скрипта и удалить из автозапуска.
echo.
echo =======================================================
echo Выберите, что вы хотите сделать:
echo.
echo 1 - Запустить оба скрипта: controld и winws
echo 2 - Запустить только controld
echo 3 - Запустить только winws
echo 4 - Остановить все и убрать из автозапуска
echo.
echo 0 - Выход
echo.
set /p choice="Введите ваш выбор: "

if "%choice%"=="1" (
    echo Запуск обоих скриптов...
    start "" "%~dp0controld.bat"
    start "" "%~dp0winws.bat"
    goto wait_for_completion
)

if "%choice%"=="2" (
    echo Запуск скрипта controld...
    start /wait "" "%~dp0controld.bat"
    goto end
)

if "%choice%"=="3" (
    echo Запуск скрипта winws...
    start /wait "" "%~dp0winws.bat"
    goto end
)

if "%choice%"=="4" (
    echo Остановка скриптов и удаление из автозапуска...

    echo Остановка ctrld...
    "%~dp0ctrld\ctrld.exe" stop

    tasklist /FI "IMAGENAME eq winws.exe" 2>NUL | find /I "winws.exe" >NUL
    if "%ERRORLEVEL%"=="0" (
        echo Остановка winws...
        taskkill /F /IM winws.exe >nul
    )

    schtasks /query /tn "ctrld_autostart" >nul 2>&1
    if %errorlevel% equ 0 (
        schtasks /delete /tn "ctrld_autostart" /f >nul
    )

    echo Откройте папку автозагрузки и удалите ярлык winws-autostart вручную.
    start explorer "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup"

    pause
    goto end
)

if "%choice%"=="0" (
    echo Выход...
    goto end
)

echo Неправильный выбор. Попробуйте еще раз.
pause
cls
goto :EOF

:wait_for_completion
:loop
timeout /t 1 >nul
tasklist | findstr /i "controld.bat" >nul
set "ctrl_status=%errorlevel%"
tasklist | findstr /i "winws.bat" >nul
set "winws_status=%errorlevel%"

if %ctrl_status% neq 0 if %winws_status% neq 0 goto end
goto loop

:end
echo.
echo Все команды успешно выполнены.
echo Нажмите любую клавишу для выхода...
pause
exit
