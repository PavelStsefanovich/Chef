# Cookbook:: notepad_pp

puts " - initializing: [notepad_pp::default]"

puts "	Notepad++ version recipe not specified."
puts "	Default version will be installed: Notepad++ 7.5.6"

include_recipe 'notepad_pp::install_npp_756'
