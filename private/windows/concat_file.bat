@echo off
::This script should only to be used in an action so we don't have to worry bout runfiles.
copy /y /b "%1" + "%2" "%3"
