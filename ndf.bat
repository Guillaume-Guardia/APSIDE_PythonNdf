::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFBxBRQiOAE60EKYg/O3o+9aJpktQRPsrcIDV5rCPNOEv40bre4URxmNUnM1CBRhXHg==
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpSI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBNQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFBxBRQiOAE60EKYg/O3o+9aJpktQRPsrcIDV5rqKJq4W8kCE
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal

:: Use the virtual environment located at the root of the git repository.
:: Through ndf.exe (Bat To Exe Converter), b2eprogramfilename is the path of the exe, which stays at the root.
:: (b2eprogramfilename is quoted when the path contains spaces: remove the quotes)
SET "NDF_EXE="
IF DEFINED b2eprogramfilename SET "NDF_EXE=%b2eprogramfilename:"=%"
SET "NDF_ROOT=%~dp0"
IF DEFINED NDF_EXE FOR %%I IN ("%NDF_EXE%") DO SET "NDF_ROOT=%%~dpI"
SET "NDF_PYTHON=%NDF_ROOT%.venv\Scripts\python.exe"

IF NOT EXIST "%NDF_PYTHON%" (
    ECHO Virtual environment not found: "%NDF_PYTHON%"
    ECHO Create it with "dev.bat install" at the root of the repository.
    PAUSE
    EXIT /B 1
)

:: Drop the first argument if it is the path of ndf.exe (the user's arguments must be kept)
IF DEFINED NDF_EXE IF /I "%~1"=="%NDF_EXE%" SHIFT

:: Forward the arguments as they were given (an empty "" argument doesn't stop the loop)
SET NDF_ARGS=
:collect_args
IF [%1]==[] GOTO run
SET NDF_ARGS=%NDF_ARGS% %1
SHIFT
GOTO collect_args

:run
"%NDF_PYTHON%" "%NDF_ROOT%src\pyndf\main.py"%NDF_ARGS%
SET "NDF_ERROR=%ERRORLEVEL%"

:: Keep the console open to read the error when the application fails
IF NOT "%NDF_ERROR%"=="0" (
    ECHO The application stopped with the error code %NDF_ERROR%.
    PAUSE
)
EXIT /B %NDF_ERROR%