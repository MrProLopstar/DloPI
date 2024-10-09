@echo off
chcp 65001 >nul

set "ctrld_exe=%~dp0ctrld\ctrld.exe"

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Требуются права администратора.
    echo Попытка перезапуска с правами администратора...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

if not exist "%ctrld_exe%" (
    echo Файл ctrld.exe не найден по пути %ctrld_exe%.
    echo Убедитесь, что программа скачана правильно.
    exit /b
)

echo Создание задачи в Планировщике задач...
schtasks /create /f /tn "ctrld_autostart" /tr "%ctrld_exe% start" /sc onlogon /rl highest /it
echo Задача ctrld_autostарт успешно создана или уже существует.

tasklist /FI "IMAGENAME eq ctrld.exe" 2>NUL | find /I "ctrld.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo Процесс ctrld уже запущен.
    goto :end
)

echo Запуск ctrld...
"%ctrld_exe%" start

:end
echo Все команды успешно выполнены.
exit
