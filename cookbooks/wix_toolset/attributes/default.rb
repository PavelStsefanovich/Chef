# Cookbook:: wix_toolset
# Attributes:: default

default["wix_toolset"]["zip"][3]["major_version_directory"] = "Wix/3"
default["wix_toolset"]["zip"][3]["packagefile"] = "wix.3.14.zip"
default["wix_toolset"]["zip"][3]["installdir"] = "wix"
default["wix_toolset"]["zip"][3]["envpath"] = "wix/wix.3.14.0"
default["wix_toolset"]["zip"][3]["replace"] = "true"

default["wix_toolset"]["exe"][3]["major_version_directory"] = "Wix/3"
default["wix_toolset"]["exe"][3]["packagefile"] = "wix314.exe"
default["wix_toolset"]["exe"][3]["installname"] = "WiX Toolset v3.14.0.1703"
default["wix_toolset"]["exe"][3]["arguments"] = "/install /quiet /norestart"
