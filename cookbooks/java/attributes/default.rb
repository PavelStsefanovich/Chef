# Cookbook:: java
# Attributes:: default

default["java"][8]["jdk"]["major_version_directory"] = "Java/8"
default["java"][8]["jdk"]["packagefile"] = "jdk-8u161-windows-x64.exe"
default["java"][8]["jdk"]["installname"] = "Java SE Development Kit 8 Update 161 (64-bit)"
default["java"][8]["jdk"]["arguments"] = "/s ADDLOCAL=\"ToolsFeature,SourceFeature\""
default["java"][8]["jdk"]["setJavaHome"] = "true"

default["java"][8]["jre"]["major_version_directory"] = "Java/8"
default["java"][8]["jre"]["packagefile"] = "jre-8u161-windows-x64.exe"
default["java"][8]["jre"]["installname"] = "Java 8 Update 161 (64-bit)"
default["java"][8]["jre"]["arguments"] = "/s"
default["java"][8]["jre"]["setJavaHome"] = "false"

default["java"][10]["jdk"]["major_version_directory"] = "Java/10"
default["java"][10]["jdk"]["packagefile"] = "jdk-10.0.1_windows-x64_bin.exe"
default["java"][10]["jdk"]["installname"] = "Java(TM) SE Development Kit 10.0.1 (64-bit)"
default["java"][10]["jdk"]["arguments"] = "/s ADDLOCAL=\"ToolsFeature,SourceFeature\""
default["java"][10]["jdk"]["setJavaHome"] = "true"

default["java"][10]["jre"]["major_version_directory"] = "Java/10"
default["java"][10]["jre"]["packagefile"] = "jre-10.0.1_windows-x64_bin.exe"
default["java"][10]["jre"]["installname"] = "Java 10.0.1 (64-bit)"
default["java"][10]["jre"]["arguments"] = "/s"
default["java"][10]["jre"]["setJavaHome"] = "false"