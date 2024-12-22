#! /bin/bash
set -x #echo on

# godot engine version number
godot_engine_ver_num="4.2.2-stable"
# Path to godot engine source code.
godot_engine_source_path="./GodotEngineSource/godot-$godot_engine_ver_num"

# Switch into godot code folder.
cd $godot_engine_source_path

# Create Tempalte Output Directory
mkdir -p ../../Template/$godot_engine_ver_num

# Compile 64 bit Linux Debug
scons platform=linuxbsd target=template_debug arch=x86_64

# Move target build into template directory.
mv ./bin/godot.linuxbsd.template_debug.x86_64 "../../Template/$godot_engine_ver_num/linux_debug.x86_64"

# Compile 64 bit Linux Release
scons platform=linuxbsd target=template_release arch=x86_64

# Move target build into template directory.
mv ./bin/godot.linuxbsd.template_release.x86_64 "../../Template/$godot_engine_ver_num/linux_release.x86_64"

