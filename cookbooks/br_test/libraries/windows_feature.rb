module BR_TEST
	module WIN_FEATURE
		
		def install(feature_name, all = true)
			powershell_script "Install #{feature_name}" do
				code <<-EOH
					write-host "!!Installing #{feature_name}"
					write-host "all=#{all}"
					'success'
				EOH
				
			end
			# windows_feature_powershell "Install #{feature_name}" do
				
			# end
		end
	end
end

Chef::Recipe.send(:include, BR_TEST::WIN_FEATURE)