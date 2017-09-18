require 'xcodeproj'
project_path = 'Rapid Router.xcodeproj'
target_name = 'Rapid Router'

def addfiles (direc, current_group, main_target)
    Dir.glob(direc) do |item|
        next if item == '.' or item == '.DS_Store'

        if File.directory?(item)
            new_folder = File.basename(item)
            created_group = current_group.new_group(new_folder, path = new_folder)
            # puts created_group
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

unity_group = project['Unity']

if unity_group['Libraries']
	unity_group['Libraries'].clear()
	unity_group['Libraries'].remove_from_project()
end
if unity_group['Classes']
	unity_group['Classes'].clear()
	unity_group['Classes'].remove_from_project()
end

libraries_group = unity_group.new_group('Libraries', path = 'RapidRouterUnityBuild/Libraries/')
classes_group = unity_group.new_group('Classes', path = 'RapidRouterUnityBuild/Classes/')

# libraries_group = unity_group.new_group('Libraries', path = 'Rapid Router/RapidRouterUnityBuild/Libraries/', source_tree = unity_group)

addfiles('Rapid Router/RapidRouterUnityBuild/Libraries/*', libraries_group, target)
addfiles('Rapid Router/RapidRouterUnityBuild/Classes/*', classes_group, target)

libraries_group['libil2cpp'].remove_from_project()

project.predictabilize_uuids()

project.save(project_path)

