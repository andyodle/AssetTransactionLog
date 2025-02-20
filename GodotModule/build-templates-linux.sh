#! /bin/bash
set -x #echo on

# godot engine version number
godot_engine_ver_num="$1-stable"
# Path to godot engine source code.
godot_engine_source_path="godot-$godot_engine_ver_num"

# Switch into godot code folder.
cd ./$pwd/GodotEngineSource/$godot_engine_source_path/

# Create Tempalte Output Directory
mkdir -p ../Template/$godot_engine_ver_num

# Compile 64 bit Linux Debug
scons platform=linuxbsd target=template_debug arch=x86_64

# Move target build into template directory.
mv ./bin/godot.linuxbsd.template_debug.x86_64 "../Template/$godot_engine_ver_num/linux_debug.x86_64"

# Compile 64 bit Linux Release
scons platform=linuxbsd target=template_release arch=x86_64

# Move target build into template directory.
mv ./bin/godot.linuxbsd.template_release.x86_64 "../Template/$godot_engine_ver_num/linux_release.x86_64"

# Compile 64 bit Windows Debug
scons platform=windows target=template_debug arch=x86_64

# Move target build into template directory.
mv ./bin/godot.windows.template_debug.x86_64.console.exe "../Template/$godot_engine_ver_num/windows_debug_x86_64_console.exe"
mv ./bin/godot.windows.template_debug.x86_64.exe "../Template/$godot_engine_ver_num/windows_debug_x86_64.exe"

# Compile 64 bit Windows release
scons platform=windows target=template_release arch=x86_64

# Move target build into template directory.
mv ./bin/godot.windows.template_release.x86_64.console.exe "../Template/$godot_engine_ver_num/windows_release_x86_64_console.exe"
mv ./bin/godot.windows.template_release.x86_64.exe "../Template/$godot_engine_ver_num/windows_release_x86_64.exe"
