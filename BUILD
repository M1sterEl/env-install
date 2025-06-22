load("@rules_python//python:defs.bzl",            "py_binary")
load("@my_pip_deps//:requirements.bzl",           "requirement")

py_binary(
    name   = "env_install_bin",
    main   = "env-install.py",
    srcs   = glob(["install_scripts/**/*.py"]) + ["env-install.py"],
    deps   = [
        requirement("requests"),
        requirement("gitpython"),
    ],
    python_version = "PY3",
)
