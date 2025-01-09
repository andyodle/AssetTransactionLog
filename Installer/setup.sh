#! /bin/bash
set -x #echo on

# AssetTransactionLog variables
atl_app_name=AssetTransactionLog.x86_64

# Update the .desktop file Name setting.
if grep -q "Name=Asset Transaction Log" ./AssetTransacitonLog.desktop; then
	echo ".desktop NAME already set."
else
	# Update the .desktop file.
	echo "Name=Asset Transaction Log" >> ./AssetTransacitonLog.desktop
fi

# Update the .desktop file Exec setting.
if grep -q "Exec=$HOME/.AssetTransactionLog/$atl_app_name" ./AssetTransacitonLog.desktop; then
	echo ".desktop Exec already set."
else	
	echo "Exec=$HOME/.AssetTransactionLog/$atl_app_name" >> ./AssetTransacitonLog.desktop
fi

# Update the .desktop file Icon setting.
if grep -q "Icon=$HOME/.AssetTransactionLog/Icon.png" ./AssetTransacitonLog.desktop; then
	echo ".desktop Icon already set."
else
	echo "Icon=$HOME/.AssetTransactionLog/Icon.png" >> ./AssetTransacitonLog.desktop
fi

# Make directory to store ATL files.
mkdir -p ~/.AssetTransactionLog/

# Copy AssetTransactionLog to /.AssetTransactionLog/
cp -rf ./AssetTransactionLog.x86_64 ~/.AssetTransactionLog/$atl_app_name

# Coppy App Icon to /.AssetTransactionLog/
cp -rf ./Icon.png ~/.AssetTransactionLog/Icon.png

# Copy .desktop shotcut file to ~/.local/share/applications/
cp -rf ./AssetTransacitonLog.desktop ~/.local/share/applications/AssetTransacitonLog.desktop


