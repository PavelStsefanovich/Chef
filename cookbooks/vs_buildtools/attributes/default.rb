# Cookbook:: vs_buildtools
# Attributes:: default

default["vs_buildtools"][2017]["major_version_directory"] = "VisualStudio/VsBuildTools/2017"
default["vs_buildtools"][2017]["packagefile"] = "vs_buildtools_2017.exe"
default["vs_buildtools"][2017]["installname"] = "Visual Studio Build Tools 2017"
default["vs_buildtools"][2017]["registryKeyName"] = "VsBuildTools"
default["vs_buildtools"][2017]["arguments"] = "--add Microsoft.VisualStudio.Workload.NetCoreBuildTools --wait --norestart -q"
default["vs_buildtools"][2017]["envpath"] = "C:/Program Files (x86)/Microsoft Visual Studio/2017/BuildTools/MSBuild/15.0/Bin"