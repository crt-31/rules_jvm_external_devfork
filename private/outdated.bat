@echo off

call %BAT_RUNFILES_LIB% rlocation outdated_jar_path %1 || goto eof
call %BAT_RUNFILES_LIB% rlocation artifacts_file_path %2 || goto eof
call %BAT_RUNFILES_LIB% rlocation repositories_file_path %3 || goto eof
extra_option_flag=%4

java {proxy_opts} -jar "%outdated_jar_path%" ^
  --artifacts-file "%artifacts_file_path%" ^
  --repositories-file "%repositories_file_path%" ^
  %extra_option_flag% ^
  || goto eof

:eof
