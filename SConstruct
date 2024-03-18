#!/usr/bin/env python
from pathlib import Path
from SCons.Script import *

from SCons.Errors import UserError


def normalize_path(val, environment):
    return val if os.path.isabs(val) else os.path.join(environment.Dir("#").abspath, val)


def validate_parent_dir(key, val, environment):
    if not os.path.isdir(normalize_path(os.path.dirname(val), environment)):
        raise UserError("'%s' is not a directory: %s" % (key, os.path.dirname(val)))


localEnv = Environment(tools=["default"], PLATFORM="")

customs = ["custom.py"]
customs = [os.path.abspath(path) for path in customs]

opts = Variables(customs, ARGUMENTS)
opts.Add("extension_name",
         help="The name of the library, will generate files with the name as the prefix",
         default="gde_template")

opts.Add(PathVariable(
    key="project_path",
    help="The path to the project to install the extension to",
    default="test/project"
))
opts.Update(localEnv)

Help(opts.GenerateHelpText(localEnv))

# Pull in the godot-cpp project
env = SConscript("ext/godot-cpp/SConstruct", {"env": localEnv.Clone(), "customs": customs})

# Library Path/Filename
if env["platform"] == "macos":
    lib_filename = "{}.{}.{}".format(env['extension_name'], env["platform"], env["target"])
    lib_path = "{}.framework/{}".format(env["platform"], lib_filename)
else:
    lib_filename = "{}{}{}".format(env['extension_name'], env["suffix"], env["SHLIBSUFFIX"])
    lib_path = "{}/{}".format(env['extension_name'], lib_filename)

# GDextension Path/Filename
gdextension_filename = "{}.gdextension".format(env['extension_name'])
gdextension_path = Path() / env['extension_name'] / gdextension_filename

# Configuration Variables
feature_flags = '{}.{}'.format(env["platform"], env["target"])

configure_dict = {
    '${EXTENSION_NAME}': env['extension_name'],
    '${COMPATIBILITY_MINIMUM}': '4.2',
    '${ENTRY_SYMBOL}': "{}_library_init".format(env['extension_name'].lower()),
    '${FEATURE_FLAGS}': feature_flags,
    '${LIBRARY_FILENAME}': lib_filename,
}
# TODO Conditional configure_dict entries
# '#reloadable': 'reloadable',
# '${ENABLE_HOT_RELOAD}': 'yes',
# '#compatibility_maximum': 'compatibility_maximum',
# '${COMPATIBILITY_MAXIMUM}': 'min_version',
# '#autodetect_library_prefix': 'autodetect_library_prefix',
# "${AUTO_LIB_PREFIX}": 'res://gdextension/{}'.format(extension_name),

# Configure files
env.Tool('textfile')
configure_header = env.Substfile('src/configure.h.in', SUBST_DICT=configure_dict)
configure_gdextension = env.Substfile(gdextension_path, 'src/template.gdextension.in', SUBST_DICT=configure_dict)

# Build Library
env.Append(CPPPATH=["src/"])
build_library = env.SharedLibrary(
    lib_path,
    source=Glob("src/*.cpp"),
)
env.Depends(build_library, configure_header)

# Install Files
install_dir = Path(env['project_path']) / 'gdextension' / env['extension_name']
install_library = env.InstallAs(install_dir / lib_filename, gdextension_path)
install_gdextension = env.InstallAs(install_dir / gdextension_filename, build_library)
env.Depends(install_library, build_library)

# Run Scons
default_args = [configure_header, build_library, configure_gdextension, install_library, install_gdextension]
if env["compiledb"]:
    default_args += [env["compiledb_file"]]

Default(*default_args)
