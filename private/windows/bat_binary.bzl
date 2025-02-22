

def _bat_binary_imp(ctx):
    return bat_binary_action(
        ctx = ctx,
        src = ctx.file.src,
        data_targets = ctx.attr.data,
        embed_runfiles_lib = ctx.attr.embed_runfiles_lib
    )
    

def bat_binary_action(
    ctx,
    src, #File
    data_files = [], #Seq[File]
    data_targets = [], #Seq[DefaultInfo] (brings in transient runfiles)
    embed_runfiles_lib =True,
):
    if embed_runfiles_lib == True : 
        
        #TODO: How to deconfict name
        out_script = ctx.actions.declare_file(ctx.label.name + "_.bat")
        
        #This will only run on windows... make a shell as well if we want to do on linux as well.
        ctx.actions.run(
            executable = ctx.file._concat_script,
            inputs = [src, ctx.file._runfiles_bat],
            outputs = [out_script],
            arguments = [
                ctx.file._runfiles_bat.path.replace("/", "\\"),
                src.path.replace("/", "\\"),    
                out_script.path.replace("/", "\\") 
            ],
            mnemonic = "EmbeddingRunfiles",

        )
    else:
        out_script = src

    data_runfiles_list = [
        data_item[DefaultInfo].default_runfiles.merge(ctx.runfiles(data_item[DefaultInfo].files.to_list()))
        for data_item in data_targets
    ]

    return DefaultInfo(
        executable = out_script,
        runfiles = ctx.runfiles([out_script] + data_files).merge_all(data_runfiles_list)
    )

BAT_BINARY_IMPLICIT_ATTRS = {
    "_concat_script": attr.label(allow_single_file=True, default="concat_file.bat", executable=True, cfg="exec"),
    "_runfiles_bat": attr.label(allow_single_file=True, default="runfiles.bat", cfg="exec"),
}

bat_binary = rule(
    implementation = _bat_binary_imp,
    attrs = {
        "src" : attr.label(allow_single_file=True, mandatory=True),
        "data": attr.label_list(allow_files=True),
        "embed_runfiles_lib": attr.bool(default = True),
#        "_concat_script": attr.label(allow_single_file=True, default="concat_file.bat", executable=True, cfg="exec"),
#        "_runfiles_bat": attr.label(allow_single_file=True, default="runfiles.bat", cfg="exec"),
    } | BAT_BINARY_IMPLICIT_ATTRS,
    executable = True
)