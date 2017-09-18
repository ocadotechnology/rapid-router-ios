
def replace_in_file(file_path, expression, replacement)
	contents = File.read(file_path)
	new_contents = contents.gsub(expression, replacement)

	if contents != new_contents
		File.open(file_path, "w") {|file| file.puts new_contents }
	end
end

# Replace method in UnityAppController.h
app_controller_h_path = "Rapid Router/RapidRouterUnityBuild/Classes/UnityAppController.h"

expression = /inline UnityAppController\*  GetAppController\(\)\n{\n *return \(UnityAppController\*\)\[UIApplication sharedApplication\]\.delegate;\n}/

replacement = %q(NS_INLINE UnityAppController* GetAppController\(\){
	NSObject<UIApplicationDelegate>* delegate = [UIApplication sharedApplication].delegate;
	UnityAppController* currentUnityController = \(UnityAppController *\)[delegate valueForKey:@"currentUnityController"];
	return currentUnityController;
})

replace_in_file(app_controller_h_path, expression, replacement)

# Correct bundle in UnityAppController.mm
app_controller_mm_path = "Rapid Router/RapidRouterUnityBuild/Classes/UnityAppController.mm"

expression = /    UnityInitApplicationNoGraphics\(\[\[\[NSBundle mainBundle\] bundlePath\] UTF8String\]\);/

replacement = %q(	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UnityInitApplicationNoGraphics\([[bundle bundlePath] UTF8String]\);)

replace_in_file(app_controller_mm_path, expression, replacement)


# Rename Unity generated method
unity_main_path = "Rapid Router/RapidRouterUnityBuild/Classes/main.mm"

expression = /int main\(int argc, char\* argv\[\]\)/

replacement = "int unity_main(int argc, char* argv[])"

replace_in_file(unity_main_path, expression, replacement)