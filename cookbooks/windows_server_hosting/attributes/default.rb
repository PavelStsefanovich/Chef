# Cookbook:: windows_server_hosting
# Attributes:: default

default["windows_server_hosting"][111]["major_version_directory"] = "WindowsServerHosting/111"
default["windows_server_hosting"][111]["packagefile"] = "DotNetCore.1.0.4_1.1.1-WindowsHosting.exe"
default["windows_server_hosting"][111]["installname"] = "Microsoft .NET Core 1.0.4 & 1.1.1 - Windows Server Hosting"
default["windows_server_hosting"][111]["arguments"] = "/q /norestart"

default["windows_server_hosting"][210]["major_version_directory"] = "WindowsServerHosting/210"
default["windows_server_hosting"][210]["packagefile"] = "dotnet-hosting-2.1.0-win.exe"
default["windows_server_hosting"][210]["installname"] = "Microsoft .NET Core Runtime - 2.1.0 (x64)"
default["windows_server_hosting"][210]["arguments"] = "/q /norestart"

default["windows_server_hosting"][2]["major_version_directory"] = "WindowsServerHosting/2"
default["windows_server_hosting"][2]["packagefile"] = "dotnet-hosting-2.1.7-win.exe"
default["windows_server_hosting"][2]["installname"] = "Microsoft .NET Core Runtime - 2.1.7 (x64)"
default["windows_server_hosting"][2]["arguments"] = "/q /norestart"
