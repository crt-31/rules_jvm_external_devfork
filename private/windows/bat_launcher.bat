@echo off

:launcher_start

call :runfiles_initialize %~0

set RUNFILES_LIB=:runfiles_call
call %RUNFILES_LIB% rlocation RUNFILES_LIB_PATH {runfiles_lib_rpath}
call %RUNFILES_LIB% rlocation SCRIPT_PATH {script_rpath}

::Use () block so that the vars will be expanded and we can unset local vars so the local vars don't get inherited by subscript.
(
    setlocal
    
    ::Unset local vars so subscript will not see them
    set SCRIPT_PATH=
    set RUNFILES_LIB_PATH=

    set RUNFILES_LIB=call %RUNFILES_LIB_PATH%

    echo SCRIPT_PATH=  %SCRIPT_PATH%
    echo VARS=  %*
    call %SCRIPT_PATH% %*
    endlocal
)