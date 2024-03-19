#!/usr/bin/env -S godot -s
extends SceneTree

func _init():
	print( "MODEL=", OS.get_model_name() )
	print( "PROCESSOR=", OS.get_processor_name() )
	print( "SYSTEM=", OS.get_name() )
	print( "DISTRIBUTION=", OS.get_distribution_name() )
	print( "VERSION=", OS.get_version() )

	# In order to actually get the list of features out of the system I will
	# have to test them manually

	# debug
	if OS.has_feature( "debug" ):
		print( "DEBUG_ENABLED=yes" )

	# Build Type
	# editor
	# template
	# template_debug
	# template_release
	# release
	if OS.has_feature( "editor" ):
		print( "TOOLS_ENABLED=yes" )
		print( "BUILD_TYPE=editor" )
	else:
		if OS.has_feature( "debug" ):
			print( "BUILD_TYPE=template_debug" )
		else:
			print( "BUILD_TYPE=template_release" )


	# Float Precision
	# double
	# single
	if OS.has_feature( "double" ):
		print( "FLOAT_PRECISION=double" )
	else:
		print( "FLOAT_PRECISION=single" )

	# BITS
	# 64
	# 32
	if OS.has_feature( "64" ):
		print( "BITS=64" )
	if OS.has_feature( "32" ):
		print( "BITS=32" )

	# Architecture tags
	var archs: Array = [
	                   "x86_64",
	                   "x86_32",
	                   #"x86",
	                   "arm64",
	                   "arm32",
	                   "armv7a",
	                   "armv7",
	                   "armv7s",
	                   "armv7",
	                   #"arm",
	                   "rv64",
	                   "riscv",
	                   "ppc64",
	                   #"ppc",
	                   "wasm64",
	                   "wasm32",
	                   #"wasm"
	                   ]

	print( "Valid arch tags are:" )
	for arch in archs:
		if OS.has_feature( arch ):
			print( "ARCH=", arch )

	# IOS_SIMULATOR
	# simulator
	if OS.has_feature( "simulator" ):
		print( "IOS_SIMULATOR=YES" )

	# There are also a few functions I have not looked into yet.
	# _check_internal_feature_support( feature )
	# has_server_feature_callback( feature )
	# has_custom_feature( feature )

	quit()
