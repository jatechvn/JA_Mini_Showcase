@echo off
setlocal DisableDelayedExpansion
title Building JA Mini Showcase Release...
cd /d "%~dp0"
if errorlevel 1 (
    echo [ERROR] Cannot open the project directory.
    exit /b 1
)

echo ========================================================
echo   Building JA Mini Showcase Windows Release (x64)
echo ========================================================

:: 1. Dong tien trinh dang chay
taskkill /IM ja_mini_showcase.exe /F 2>nul

:: 2. Bien dich ban phat hanh Release
call flutter build windows --release
set "BUILD_EXIT_CODE=%ERRORLEVEL%"
if not "%BUILD_EXIT_CODE%"=="0" (
    echo.
    echo [ERROR] Release build failed with error code %BUILD_EXIT_CODE%.
    if not defined CI if not "%CI%"=="true" if not "%NO_PAUSE%"=="1" pause
    exit /b %BUILD_EXIT_CODE%
)

set "REL=build\windows\x64\runner\Release"
set "DIST=dist"
set "VERSION=1.2.0"
set "PACK=dist_pack"
set "BACKUP_ROOT=backup"

if not exist "%REL%\ja_mini_showcase.exe" (
    echo [ERROR] Release executable is missing: "%REL%\ja_mini_showcase.exe"
    exit /b 1
)

:: 3. Xoa du lieu runtime phat sinh trong thu muc Release
if exist "%REL%\config.json" del /f /q "%REL%\config.json"
if exist "%REL%\config.ini" del /f /q "%REL%\config.ini"
if exist "%REL%\logs" rmdir /s /q "%REL%\logs"

:: 4. Chep script phu tro, bo cai va tai nguyen vao Release
if exist debug.bat copy /y debug.bat "%REL%\" >nul
if exist install.bat copy /y install.bat "%REL%\" >nul
if exist uninstall.bat copy /y uninstall.bat "%REL%\" >nul
if exist uninstall.ps1 copy /y uninstall.ps1 "%REL%\" >nul
if exist ABOUT.txt copy /y ABOUT.txt "%REL%\" >nul
if exist README.md copy /y README.md "%REL%\" >nul
if exist CHANGELOG.md copy /y CHANGELOG.md "%REL%\" >nul
if exist USERGUIDE.md copy /y USERGUIDE.md "%REL%\" >nul
if exist RELEASE_NOTES.md copy /y RELEASE_NOTES.md "%REL%\" >nul
if exist LICENSE copy /y LICENSE "%REL%\" >nul

:: 5. Tao shortcut .Release.lnk tai goc du an
powershell -NoProfile -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('.Release.lnk'); $Shortcut.TargetPath = Join-Path (Get-Item .).FullName '%REL%'; $Shortcut.Save()"
if errorlevel 1 echo [WARNING] Could not create .Release.lnk; continuing.

echo.
echo [1/2] Copying files to dist/ (Ready-to-run portable app)...
:snapshot_dist
if not exist "%DIST%\" goto after_snapshot_dist
for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "(Get-Date).ToString('yyyyMMdd_HHmmssfff')"`) do set "BACKUP_DIST=%BACKUP_ROOT%\dist_%%T"
if not defined BACKUP_DIST (
    echo [ERROR] Could not create a backup name for dist/.
    exit /b 1
)
if not exist "%BACKUP_ROOT%\" mkdir "%BACKUP_ROOT%"
move "%DIST%" "%BACKUP_DIST%" >nul
if errorlevel 1 (
    echo [ERROR] Could not snapshot existing dist/ to "%BACKUP_DIST%".
    exit /b 1
)
:after_snapshot_dist
mkdir "%DIST%" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Could not create "%DIST%".
    exit /b 1
)
xcopy /e /i /y /q "%REL%\*.*" "%DIST%\" >nul
if errorlevel 1 (
    echo [ERROR] Could not copy the Release build to dist/.
    exit /b 1
)

:: Preserve portable user data in dist/, but keep it out of the public ZIP.
if defined BACKUP_DIST (
    if exist "%BACKUP_DIST%\data\search_history.json" (
        if not exist "%DIST%\data\" mkdir "%DIST%\data"
        copy /y "%BACKUP_DIST%\data\search_history.json" "%DIST%\data\search_history.json" >nul
        if errorlevel 1 echo [WARNING] Could not restore data\search_history.json.
    )
    if exist "%BACKUP_DIST%\logs\" (
        xcopy /e /i /y /q "%BACKUP_DIST%\logs\*.*" "%DIST%\logs\" >nul
        if errorlevel 1 echo [WARNING] Could not restore portable logs.
    )
)

for %%F in (install.bat uninstall.bat uninstall.ps1) do (
    if not exist "%DIST%\%%F" (
        echo [ERROR] Required distribution file is missing: "%DIST%\%%F"
        exit /b 1
    )
)

echo [2/2] Packaging release ZIP with parent folder...
if exist "%PACK%" rmdir /s /q "%PACK%"
mkdir "%PACK%\JA_Mini_Showcase_v%VERSION%_Windows_x64"
robocopy "%DIST%" "%PACK%\JA_Mini_Showcase_v%VERSION%_Windows_x64" /E /R:1 /W:1 /XD logs /XF search_history.json update_config.json config.json config.ini *.log *.key >nul
if errorlevel 8 (
    echo [ERROR] Could not stage the clean release package.
    exit /b 1
)

powershell -NoProfile -Command "Compress-Archive -Path '%PACK%\*' -DestinationPath '%DIST%\JA_Mini_Showcase_v%VERSION%_Windows_x64.zip' -Force"
if errorlevel 1 (
    echo [ERROR] Could not create the release ZIP.
    exit /b 1
)
if exist "%PACK%" rmdir /s /q "%PACK%"

:: Tao SHA256 checksum
powershell -NoProfile -Command "$hash = (Get-FileHash -Path '%DIST%\JA_Mini_Showcase_v%VERSION%_Windows_x64.zip' -Algorithm SHA256).Hash; Set-Content -Path '%DIST%\SHA256SUMS.txt' -Value \"$hash *JA_Mini_Showcase_v%VERSION%_Windows_x64.zip\""
if errorlevel 1 (
    echo [ERROR] Could not write SHA256SUMS.txt.
    exit /b 1
)

echo.
echo ========================================================
echo   [SUCCESS] Build ^& Packaging complete!
echo   - Release folder : %REL%\
echo   - Dist folder    : %DIST%\
echo   - Installer      : %DIST%\install.bat
echo   - Uninstaller    : %DIST%\uninstall.bat
echo   - Shortcut       : .Release.lnk
echo ========================================================
echo.
if not defined CI if not "%CI%"=="true" if not "%NO_PAUSE%"=="1" pause
