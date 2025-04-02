load("//private/lib:utils.bzl", "file_to_rlocationpath")

def _bat_binary_imp(ctx):
    return bat_binary_action(
        ctx = ctx,
        src = ctx.file.src,
        data_targets = ctx.attr.data,
    )
    

def bat_binary_action(
    ctx,
    src, #File
    data_files = [], #Seq[File]
    data_targets = [], #Seq[DefaultInfo] (brings in transient runfiles)
):
    if(src.extension.upper() != "BAT"):
        fail("bat_binary src needs to be a *.bat file.")
    #Create launcher
    
    launcher = ctx.actions.declare_file(ctx.label.name + "_launcher.bat")    

    ctx.actions.expand_template(
        template = ctx.file._launcher_template, 
        output = launcher,
        substitutions = {
            "{runfiles_lib_rpath}" : file_to_rlocationpath(ctx, ctx.file._runfiles_bat),
            "{script_rpath}" : file_to_rlocationpath(ctx, src),
        }
    )
  
    data_runfiles_list = [
        data_item[DefaultInfo].default_runfiles.merge(ctx.runfiles(data_item[DefaultInfo].files.to_list()))
        for data_item in data_targets
    ]

    return DefaultInfo(
        executable = launcher,
        runfiles = ctx.runfiles([src, ctx.file._runfiles_bat] + data_files).merge_all(data_runfiles_list)
    )

BAT_BINARY_IMPLICIT_ATTRS = {
    "_runfiles_bat": attr.label(allow_single_file=True, default="runfiles.bat"),
    "_launcher_template": attr.label(allow_single_file=True, default="bat_launcher_template"),
}

bat_binary = rule(
    implementation = _bat_binary_imp,
    attrs = {
        "src" : attr.label(allow_single_file=[".bat"], mandatory=True),
        "data": attr.label_list(allow_files=True),
   
    } | BAT_BINARY_IMPLICIT_ATTRS,
    executable = True
)