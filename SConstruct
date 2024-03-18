#!/usr/bin/env python
import os
from pathlib import Path


def normalize_path(val, env):
    return val if os.path.isabs(val) else os.path.join(env.Dir("#").abspath, val)


def validate_parent_dir(key, val, env):
    if not os.path.isdir(normalize_path(os.path.dirname(val), env)):
        raise UserError("'%s' is not a directory: %s" % (key, os.path.dirname(val)))


# Provide options to configure these two values
extension_name = "gdetemplate"
project_dir = Path('test/project')

localEnv = Environment(tools=["default"], PLATFORM="")

customs = ["custom.py"]
customs = [os.path.abspath(path) for path in customs]

opts = Variables(customs, ARGUMENTS)
opts.Update(localEnv)

Help(opts.GenerateHelpText(localEnv))

env = localEnv.Clone()

# TODO This is where we have to clone the godot-cpp library

env = SConscript("ext/godot-cpp/SConstruct", {"env": env, "customs": customs})

env.Append(CPPPATH=["src/"])
lib_sources = Glob("src/*.cpp")

lib_filename = Path("{}{}{}".format(extension_name, env["suffix"], env["SHLIBSUFFIX"]))

if env["platform"] == "macos":
    platlibname = "{}.{}.{}".format(extension_name, env["platform"], env["target"])
    lib_filename = "{}.framework/{}".format(env["platform"], platlibname, platlibname)

lib_path = "{}/{}".format(extension_name, lib_filename)
build_library = env.SharedLibrary(
    lib_path,
    source=lib_sources,
)
feature_flags = '{}.{}'.format(env["platform"], env["target"])

configure_dict = {
    '${EXTENSION_NAME}': extension_name,
    '${COMPATIBILITY_MINIMUM}': '4.2',
    '${ENTRY_SYMBOL}': "{}_library_init".format(extension_name.lower()),
    '${FEATURE_FLAGS}': feature_flags,
    '${LIBRARY_FILENAME}': lib_filename,
}
# TODO Conditional configure_dict entries
#'#reloadable': 'reloadable',
#'${ENABLE_HOT_RELOAD}': 'yes',
#'#compatibility_maximum': 'compatibility_maximum',
#'${COMPATIBILITY_MAXIMUM}': 'min_version',
#'#autodetect_library_prefix': 'autodetect_library_prefix',
#"${AUTO_LIB_PREFIX}": 'res://gdextension/{}'.format(extension_name),

gdextension_filename = "{}.gdextension".format(extension_name)
gdextension_path = Path() / extension_name / gdextension_filename

# Configure files
env.Tool('textfile')
configure_header = env.Substfile('src/configure.h.in', SUBST_DICT=configure_dict)
configure_gdextension = env.Substfile(gdextension_path, 'src/template.gdextension.in', SUBST_DICT=configure_dict)

env.Depends(build_library, configure_header)

install_dir = project_dir / 'gdextension' / extension_name
install_library = env.InstallAs(install_dir / lib_filename, gdextension_path)
install_gdextension = env.InstallAs(install_dir / gdextension_filename, build_library)
env.Depends(install_library, build_library)
# TODO Could I use this to just copy across the whole file?

default_args = [configure_header, build_library, configure_gdextension, install_library, install_gdextension]

if env["compiledb"]:
    default_args += [env["compiledb_file"]]

Default(*default_args)
