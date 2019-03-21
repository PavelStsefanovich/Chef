# Cookbook:: windows_sdk
# Attributes:: default

default["windows_sdk"][8]["major_version_directory"] = "WindowsSDK/8"
default["windows_sdk"][8]["packagefile"] = "sdksetup.exe"
default["windows_sdk"][8]["installname"] = "Windows Software Development Kit"
default["windows_sdk"][8]["arguments"] = "/q /norestart"
default["windows_sdk"][8]["signtoolPath"] = "Program Files (x86)/Windows Kits/8.0/bin/x64"