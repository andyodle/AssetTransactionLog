#! /bin/bash
set -x #echo on

# AssetTransactionLog variables
atl_app_name=AssetTransactionLog.x86_64

# Update the .desktop file.
echo "Name=Asset Transaction Log" >> ./AssetTransacitonLog.desktop
echo "Exec=$HOME/.AssetTransactionLog/$atl_app_name" >> ./AssetTransacitonLog.desktop
echo "Icon=$HOME/.AssetTransactionLog/Icon.png" >> ./AssetTransacitonLog.desktop

# Make directory to store ATL files.
mkdir -p ~/.AssetTransactionLog/

# Copy AssetTransactionLog to /.AssetTransactionLog/
cp -rf ./AssetTransactionLog.x86_64 ~/.AssetTransactionLog/$atl_app_name

# Coppy App Icon to /.AssetTransactionLog/
cp -rf ./Icon.png ~/.AssetTransactionLog/Icon.png

# Copy .desktop shotcut file to ~/.local/share/applications/
cp -rf ./AssetTransacitonLog.desktop ~/.local/share/applications/AssetTransacitonLog.desktop


