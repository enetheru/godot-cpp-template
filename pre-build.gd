#!/usr/bin/env -S godot -s
extends SceneTree

func _init():
	print( "OS:: Functions to get information about the executable" )
	print( "Model:     ", OS.get_model_name() )
	print( "Processor: ", OS.get_processor_name() )
	print( "System:    ", OS.get_name() )
	print( "Variant:   ", OS.get_distribution_name() )
	print( "Version:   ", OS.get_version() )

	# In order to actually get the list of features out of the system I will
	# have to test them manually

	# debug
	if OS.has_feature( "debug" ):
		print( "#define DEBUG_ENABLED" )

	# Build Type
	# editor
	# template
	# template_debug
	# template_release
	# release
	if OS.has_feature( "editor" ):
		print( "#define TOOLS_ENABLED" )
		print( "Build Type: editor" )
	else:
		if OS.has_feature( "debug" ):
			print( "build type: template_debug" )
		else:
			print( "build type: template_release" )


	# Float Precision
	# double
	# single
	if OS.has_feature( "double" ):
		print( "float is double precision" )
		print( "#define REAL_T_IS_DOUBLE" )
	else:
		print( "float is single precision" )

	# BITS
	# 64
	# 32
	if OS.has_feature( "64" ):
		print( "compiled in 64 bit mode" )
	if OS.has_feature( "32" ):
		print( "compiled in 32 bit mode" )

	# Architecture tags
	var archs: Array = [
	                   "x86_64",
	                   "x86_32",
	                   "x86",
	                   "arm64",
	                   "arm32",
	                   "armv7a",
	                   "armv7",
	                   "armv7s",
	                   "armv7",
	                   "arm",
	                   "rv64",
	                   "riscv",
	                   "ppc64",
	                   "ppc",
	                   "wasm64",
	                   "wasm32",
	                   "wasm"
	                   ]

	print( "Valid arch tags are:" )
	for arch in archs:
		if OS.has_feature( arch ):
			print( "\t", arch )

	# IOS_SIMULATOR
	# simulator
	if OS.has_feature( "simulator" ):
		print( "#define IOS_SIMULATOR" )

	# There are also a few functions I have not looked into yet.
	# _check_internal_feature_support( feature )
	# has_server_feature_callback( feature )
	# has_custom_feature( feature )

	quit()
