#! /bin/bash
set -x #echo on

godot_engine_version=$1
godot_source_path="godot-$godot_engine_version-stable"

# Create place to hold godot engine.
mkdir -p GodotEngineSource/

# Download the godot engine source code.
wget -O ./GodotEngineSource/$godot_engine_version-stable.zip https://github.com/godotengine/godot/archive/refs/tags/$godot_engine_version-stable.zip

# Extract godot engine source code.
unzip -o ./GodotEngineSource/$godot_engine_version-stable.zip -d "./GodotEngineSource/"

# Copy calculator module into engine source code dir.
cp -rf ./GodotModule/calculator ./GodotEngineSource/$godot_source_path/modules/calculator

# Copy template install script into engine source code dir.
cp -rf ./GodotModule/build-templates-linux.sh ./GodotEngineSource/build-templates-linux.sh

# Switch to GodotEngineSource dir.
cd ./GodotEngineSource/$godot_source_path/

# List available platforms.
echo ''
temp_list=`scons platform=list`
green='\033[0;32m'
white='\033[0;32m'
echo -e "$green$temp_list$white"

# Get witch platform to compile.
read -p "Witch platform will you be developing on? " dev_platform

# Compile godot engine for developer platform.
scons platform=$dev_platform

# Switch to script dir.
cd ../../

# Compile Target Platform Templates
./GodotEngineSource/build-templates-linux.sh $godot_engine_version

# Create Release Folders.
mkdir -p Release/Windows
mkdir -p Release/Linux
