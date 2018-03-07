# Contributor Development Guide

## Installation

### Prerequisites:
- Xcode 9.2
- Unity 2017.3.0f3

1. Clone this project
2. Download the latest [Rapid Router Unity build](https://github.com/ocadotechnology/rapid-router-unity/releases)
3. Install [Carthage](https://github.com/Carthage/Carthage#installing-carthage)
4. Install `xcodeproj` for the ruby scripts by running `gem install xcodeproj` in the terminal

### Build Xcode Project

> You will need a physical device to run the project. This is due to the Unity generated project only supporting ARM-based processors and the iOS simulator runs on the laptop/desktop's processor.

1. Make sure Xcode is closed and open up a terminal window and `cd` into the project
2. Update and build any dependencies `carthage update --platform iOS`
2. Create a folder called *RapidRouterUnityBuild* inside of the *Rapid Router* folder at the root of the project if it doesn't already exist
3. Unzip the Unity build into the *Rapid Router* folder. You should end up with `Rapid Router/RapidRouterUnityBuild`
4. Modify the Unity build by running: `ruby projectRefresh.rb`. This makes it possible for the [Unity release to run within another iOS app](https://medium.com/ocadotechnology/unity-and-blockly-a-match-almost-made-in-heaven-ff2eafcdd220)
5. Delete Classes group, remove References
6. Delete Libraries group, remove References
7. Drag and drop the "Classes" folder inside *RapidRouterUnityBuild* into the Unity group in Xcode. (Select "Create groups" and add to the "Rapid Router" target only)
8. Drag and drop the "Libraries" folder inside *RapidRouterUnityBuild* into the Unity group in Xcode. (Select "Create groups" and add to the "Rapid Router" target only. Don't copy the items)
9. Add Classes from *RapidRouterUnityBuild* inside of the Unity group in Xcode
10. Remove the Unity/Libraries/libl2cpp group in Xcode (click "Remove references" when prompted) 
11. Remove the `*.h` header files from the Unity/Classes/Native group in Xcode
12. Run the project on a physical device

> If you want to update the Unity build, skip steps 1 and 2

> If you want to update the iOS dependencies,  run step 1 only

### Run Project

Just open Xcode, make sure you have selected a **physical** device and press play!

