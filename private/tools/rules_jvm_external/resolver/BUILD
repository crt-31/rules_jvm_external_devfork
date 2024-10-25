load("//private/rules:artifact.bzl", "artifact")

java_library(
    name = "resolver",
    srcs = glob(["*.java"]),
    javacopts = [
        "--release",
        "8",
    ],
    visibility = [
        "//private/tools/rules_jvm_external:__subpackages__",
    ],
    deps = [
        "//private/tools/rules_jvm_external",
        artifact(
            "com.google.guava:guava",
            repository_name = "rules_jvm_external_deps",
        ),
    ],
)
