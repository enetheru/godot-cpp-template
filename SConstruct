#!/usr/bin/env python
from pathlib import Path
from SCons.Script import *

env = Environment(tools=["default"], PLATFORM="")

customs = [Path("custom.py").absolute()]
opts = Variables(customs, ARGUMENTS)

# This library options
opts.Add("extension_name",
         help="The name of the library, will generate files with the name as the prefix",
         default="gde_template")

opts.Add("compatibility_minimum",
         help="The minimum version of Godot to require",
         default="4.2")

opts.Add("compatibility_maximum",
         help="The maximum version of Godot accepted",
         default=None)

opts.Add("autodetect_library_prefix",
         help="",
         default=None)

# Dependency Location
opts.Add(PathVariable(
    key="godotcpp_path",
    help="The path to the godot-cpp source",
    default="ext/godot-cpp"
))

# Installation Location
opts.Add(PathVariable(
    key="project_path",
    help="The path to the project to install the extension to",
    default="test/project"
))

opts.Update(env)

Help(opts.GenerateHelpText(env))

# Pull in the godot-cpp project
env = SConscript(Path(env['godotcpp_path']) / "SConstruct", {"env": env, "customs": customs})

# Library Path/Filename
if env["platform"] == "macos":
    lib_path = Path(f"{env['platform']}.framework") / f"{env['extension_name']}.{env['platform']}.{env['target']}"
else:
    lib_path = Path(env['extension_name']) / f"{env['extension_name']}{env['suffix']}{env['SHLIBSUFFIX']}"

# GDExtension Path/Filename
gdextension_path = Path(env['extension_name']) / f"{env['extension_name']}.gdextension"

# Configuration Variables
feature_flags = f"{env['platform']}.{env['arch']}.{env['target']}"

configure_dict = {
    '${EXTENSION_NAME}': env['extension_name'],
    '${COMPATIBILITY_MINIMUM}': env['compatibility_minimum'],
    '${ENTRY_SYMBOL}': f"{env['target']}_library_init",
    '${FEATURE_FLAGS}': feature_flags,
    '${LIBRARY_FILENAME}': lib_path.name,
}

if env.get('use_hot_reload') is not None:
    configure_dict[';reloadable'] = 'reloadable'
    configure_dict['${ENABLE_HOT_RELOAD}'] = 'true'

if env.get('compatibility_maximum') is not None:
    configure_dict[';compatibility_maximum'] = 'compatibility_maximum'
    configure_dict['${COMPATIBILITY_MAXIMUM}'] = env['compatibility_maximum']

if env.get('autodetect_library_prefix') is not None:
    configure_dict[';autodetect_library_prefix'] = 'autodetect_library_prefix'
    configure_dict['${AUTO_LIB_PREFIX}'] = env['autodetect_library_prefix']

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
install_dir = Path(env['project_path']) / 'gdextensions' / env['extension_name']
install_library = env.InstallAs(install_dir / lib_path.name, lib_path)
install_gdextension = env.InstallAs(install_dir / gdextension_path.name, gdextension_path)
env.Depends(install_library, build_library)

# Run Scons
default_args = [configure_header, build_library, configure_gdextension, install_library, install_gdextension]
if env["compiledb"] is not None:
    default_args.append(env["compiledb_file"])

Default(*default_args)
