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