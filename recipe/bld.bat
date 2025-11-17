@echo off
setlocal enabledelayedexpansion

REM First install the Python package (needed for frontend build)
echo Installing package with pip first...
%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
if errorlevel 1 exit 1

REM Check if the build_frontend script exists
if exist "scripts\build_frontend.sh" (
    echo Found scripts/build_frontend.sh, building frontend...

    REM Set Node.js memory options
    set NODE_OPTIONS=--max-old-space-size=8192

    REM Build the frontend using bash (available in conda environments)
    bash scripts/build_frontend.sh
    if errorlevel 1 exit 1

    REM Reinstall to include the built frontend
    echo Reinstalling package to include built frontend...
    %PYTHON% -m pip install . -vv --no-deps --no-build-isolation --force-reinstall
    if errorlevel 1 exit 1
) else (
    echo Warning: scripts/build_frontend.sh not found, skipping frontend build
)

exit 0

