# Code for Life
#
# Copyright (C) 2017, Ocado Innovation Limited
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# ADDITIONAL TERMS – Section 7 GNU General Public Licence
#
# This licence does not grant any right, title or interest in any “Ocado” logos,
# trade names or the trademark “Ocado” or any other trademarks or domain names
# owned by Ocado Innovation Limited or the Ocado group of companies or any other
# distinctive brand features of “Ocado” as may be secured from time to time. You
# must not distribute any modification of this program using the trademark
# “Ocado” or claim any affiliation or association with Ocado or its employees.
#
# You are not authorised to use the name Ocado (or any of its trade names) or
# the names of any author or contributor in advertising or for publicity purposes
# pertaining to the distribution of this program, without the prior written
# authorisation of Ocado.
#
# Any propagation, distribution or conveyance of this program must include this
# copyright notice and these terms. You must not misrepresent the origins of this
# program; modified versions of the program must be marked as such and not
# identified as the original program.

require 'xcodeproj'
project_path = 'Rapid Router.xcodeproj'
target_name = 'Rapid Router'

def addfiles (direc, current_group, main_target)
    Dir.glob(direc) do |item|
        next if item == '.' or item == '.DS_Store'

        if File.directory?(item)
            new_folder = File.basename(item)
            created_group = current_group.new_group(new_folder, path = new_folder)
            addfiles("#{item}/*", created_group, main_target)
        else
          new_item = File.basename(item)
          if not (current_group.name == 'Native' and new_item.include? ".h")
          	i = current_group.new_file(new_item)
          end
          if new_item.include? ".mm" or new_item.include? ".cpp"
              main_target.add_file_references([i])
          elsif new_item.include? ".a"
          	  main_target.frameworks_build_phase.add_file_reference(i, true)
          end
        end
    end
end

project = Xcodeproj::Project.open(project_path)

target = nil

project.targets.each do |t|
  if t.name == target_name
  	target = t
  end
end

# get the Unity group in the project
unity_group = project['Unity']

# remove Libraries and Classes groups if they already exist
if unity_group['Libraries']
	unity_group['Libraries'].clear()
	unity_group['Libraries'].remove_from_project()
end
if unity_group['Classes']
	unity_group['Classes'].clear()
	unity_group['Classes'].remove_from_project()
end

# Create the Libraries and Classes group
libraries_group = unity_group.new_group('Libraries', path = 'RapidRouterUnityBuild/Libraries/')
classes_group = unity_group.new_group('Classes', path = 'RapidRouterUnityBuild/Classes/')

# Add all the necessary files to those groups
addfiles('Rapid Router/RapidRouterUnityBuild/Libraries/*', libraries_group, target)
addfiles('Rapid Router/RapidRouterUnityBuild/Classes/*', classes_group, target)

# Remove the libil2cpp group from the project
libraries_group['libil2cpp'].remove_from_project()

# Make the project file uuids deterministic
# project.predictabilize_uuids()

# Save the changes to the project file
project.save(project_path)
