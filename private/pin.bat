@echo off
call %RUNFILES_LIB% rlocation maven_unsorted_file %1

set maven_install_json_loc={maven_install_location}
set "maven_install_json_loc=%maven_install_json_loc:/=\%"

copy /y %maven_unsorted_file% %maven_install_json_loc%

if  "{predefined_maven_install}" == "True" (
    echo "Successfully pinned resolved artifacts for @{repository_name}, $maven_install_json_loc% is now up-to-date."
) else (
    echo "Successfully pinned resolved artifacts for @{repository_name} in $maven_install_json_loc%." 
    echo  "This file should be checked into your version control system."
    echo 
    echo "Next, please update your WORKSPACE file by adding the maven_install_json attribute" 
    echo  "and loading pinned_maven_install from @{repository_name}//:defs.bzl".
    echo ""
    echo "For example:"
    echo ""
    echo ""
    echo "============================================================="
    echo ""
    echo "maven_install("
    echo "    artifacts = # ...,"
    echo "    repositories = # ...,"
    echo "    maven_install_json = \"@//:{repository_name}_install.json\","
    echo )
    echo ""
    echo load("@{repository_name}//:defs.bzl", "pinned_maven_install")
    echo pinned_maven_install()
    echo ""
    echo "============================================================="
    echo ""
    echo ""
    echo "To update {repository_name}_install.json, run this command to re-pin the unpinned repository:"
    echo ""
    echo "    bazel run @unpinned_{repository_name}//:pin"
)
echo
