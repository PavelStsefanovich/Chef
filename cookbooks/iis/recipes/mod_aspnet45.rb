#
# Author:: Blair Hamilton (<blairham@me.com>)
# Cookbook:: iis
# Recipe:: mod_aspnet45
#
# Copyright:: 2011-2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'iis'
include_recipe 'iis::mod_isapi'

features = if Opscode::IIS::Helper.older_than_windows2008r2?
             %w(NET-Framework)
           else
             %w(NetFx4Extended-ASPNET45 IIS-NetFxExtensibility45 IIS-ASPNET45)
           end

features.each do |feature|
  windows_feature feature do
    action :install
		timeout 1200
  end
end
