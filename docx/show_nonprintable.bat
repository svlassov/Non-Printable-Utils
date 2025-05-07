@echo off
chcp 65001 >nul
setlocal

if "%~1"=="" (
    echo Usage: %~nx0 "<file.docx>"
    exit /b 1
)

set "DOCX_FILE=%~1"
set "TMP_DIR=%TEMP%\show_nonprintable_%RANDOM%"
set "ZIP_FILE=%TMP_DIR%\temp.zip"
set "TEXT_FILE=%TMP_DIR%\text.txt"

REM Создаем временную директорию
mkdir "%TMP_DIR%"
if not exist "%TMP_DIR%" (
    echo Error: Failed to create temporary directory
    exit /b 1
)

REM Копируем файл и переименовываем его в .zip
copy "%DOCX_FILE%" "%ZIP_FILE%" >nul

REM Распаковываем .zip
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%TMP_DIR%' -Force"

set "XML=%TMP_DIR%\word\document.xml"
if not exist "%XML%" (
    echo Error: document.xml not found
    rmdir /S /Q "%TMP_DIR%"
    exit /b 1
)

REM Извлекаем текст без XML-тегов и сохраняем в файл
echo ======= START OF document.xml =======
type "%XML%"
echo ======= END OF document.xml =======
powershell -Command "Get-Content -Raw -Encoding UTF8 '%XML%' | Select-String -Pattern '<[^>]*>' -NotMatch | Out-File -Encoding UTF8 '%TEXT_FILE%'"


REM Запуск Python скрипта
python process_text.py "%TEXT_FILE%"

REM Очистка
rmdir /S /Q "%TMP_DIR%"
