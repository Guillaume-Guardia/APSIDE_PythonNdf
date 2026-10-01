@echo off
:: Development helper, used locally and by the CI
::   dev.bat install : create the virtual environment .venv and install the dependencies
::   dev.bat test    : check the dependencies and run the tests
::   dev.bat run     : launch the application
::   dev.bat exe     : generate ndf.exe from ndf.bat (needs Bat To Exe Converter)
::   dev.bat         : install then test
setlocal

SET "ROOT=%~dp0"
SET "VENV_PYTHON=%ROOT%.venv\Scripts\python.exe"

IF "%~1"=="" GOTO :all
IF /I "%~1"=="install" GOTO :install
IF /I "%~1"=="test" GOTO :test
IF /I "%~1"=="run" GOTO :run
IF /I "%~1"=="exe" GOTO :exe
ECHO Usage: dev.bat [install^|test^|run^|exe]
EXIT /B 1

:all
CALL :install || EXIT /B 1
CALL :test
EXIT /B %ERRORLEVEL%

:install
IF NOT EXIST "%VENV_PYTHON%" (
    ECHO Creating the virtual environment .venv
    python -m venv "%ROOT%.venv" || EXIT /B 1
)
"%VENV_PYTHON%" -m pip install -e "%ROOT%." -r "%ROOT%requirements-dev.txt" || EXIT /B 1
EXIT /B 0

:test
CALL :check_venv || EXIT /B 1
:: Run Qt without display
SET "QT_QPA_PLATFORM=offscreen"
"%VENV_PYTHON%" -m pip check || EXIT /B 1
PUSHD "%ROOT%"
"%VENV_PYTHON%" -m pytest tests -ra
SET "RESULT=%ERRORLEVEL%"
POPD
EXIT /B %RESULT%

:run
CALL :check_venv || EXIT /B 1
CALL "%ROOT%ndf.bat"
EXIT /B %ERRORLEVEL%

:exe
:: The path of the converter can be overridden with the environment variable B2E
IF NOT DEFINED B2E SET "B2E=%ProgramFiles%\Bat To Exe Converter\Bat_To_Exe_Converter.exe"
IF NOT EXIST "%B2E%" (
    ECHO Bat To Exe Converter not found: "%B2E%"
    ECHO Install it from https://www.f2ko.de/en/b2e.php or set B2E to its path.
    EXIT /B 1
)
"%B2E%" /bat "%ROOT%ndf.bat" /exe "%ROOT%ndf.exe" /icon "%ROOT%data\icons\pyndf.ico" /overwrite || EXIT /B 1
EXIT /B 0

:check_venv
IF NOT EXIST "%VENV_PYTHON%" (
    ECHO Virtual environment not found, run "dev.bat install" first.
    EXIT /B 1
)
EXIT /B 0
