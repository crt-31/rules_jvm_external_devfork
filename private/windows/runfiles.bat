@echo off
rem ---RUNFILES_LIB---------------------------------------------------

rem Force MANFIEST_ONLY since Bazel doesn't have a way to know if runfiles are enabled or not (yet).
set RUNFILES_MANIFEST_ONLY=1

set RUNFILES_LIB=:runfiles_call

goto runfiles_endcode

:runfiles_call

set function_call=%1
shift

if "%function_call%" == "rlocation" (
    goto runfiles_rlocation
) else (
    echo "invalid runfiles function: %function_call%"
)

:runfiles_initialize
if not defined RUNFILES_DIR (    
    set RUNFILES_DIR=%1.runfiles
    echo %1
)
if not defined RUNFILES_MANIFEST_FILE (
    set RUNFILES_MANIFEST_FILE=%RUNFILES_DIR%/Manifest
)

exit /b 0

:runfiles_rlocation
::TODO: Check if Env exist and fail if no
setlocal enableDelayedExpansion    
if "%RUNFILES_MANIFEST_ONLY%" == "1" (
    
    for /f "tokens=1,2" %%a in ( %RUNFILES_MANIFEST_FILE% ) do (
        if "%%a" == "%2" (
            set result=%%b
            goto runfiles_rlocation_processresult
        )
    )
) else (
    set result=%RUNFILES_DIR%/%2
)

:runfiles_rlocation_processresult

set "result=%result:/=\%"
endlocal & set %1=%result%
exit /b 0

:runfiles_endcode

rem Call initialize for the user (so the user doesn't have to)
call :runfiles_initialize %~0
@echo

rem ---RUNFILES_LIB - END ---------------------------------------------------

