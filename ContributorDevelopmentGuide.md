# Contributor Development Guide

## Prerequisites:
- Clone [RapidRouter iOS Project](https://github.com/ocadotechnology/rapid-router-ios)
- Clone [RapidRouter Unity Project](https://github.com/ocadotechnology/rapid-router-unity)
- Install [Carthage](https://github.com/Carthage/Carthage#installing-carthage)

## Build Unity
- Switch to iOS platform
- Select Release for Xcode run type
- Click Development Build checkbox
- Choose Player Settings… -> Device
    - Select Other Settings
        - Change “Colour Space*” to “Gamma”
        - Tick “Auto Graphics API”
        - Change Target SDK from Device SDK to Simulator SDK
        
        ![PlayerSettings](https://github.com/ocadotechnology/rapid-router-ios/blob/AddReadMe/images/UnityPlayerSettings.png)
        
- Build project
    - Select to save at root/RapidRouter of iOS project, with name RapidRouterUnityBuild
    
    ![UnityBuild](https://github.com/ocadotechnology/rapid-router-ios/blob/AddReadMe/images/UnityiOSBuild.png)

## Build Xcode Project
- Ensure Unity folder folder is properly linked to RapidRouter/RapidRouterUnityBuild
- Remove all .h files from Unity/Classes/Native
- Go to Unity/Classes/main.mm and rename the `main` method to `unity_main`
- Copy method from UnityBridge.h and replace the getAppController method in `UnityAppController.h`
- Open terminal at root of project and run `carthage update`
- Open rapid-router-ios/Carthage/Checkouts/blockly-ios/Blockly.xcodeproj
    - Select Manage Schemes
    
    ![ManageBlocklySchemes](https://github.com/ocadotechnology/rapid-router-ios/blob/AddReadMe/images/XcodeManageSchemes.png)
    
    - Only BlocklyTests will have `Shared` enabled. Tick `Shared` for the Blockly framework as well and click `Done`
    
    ![ShareBlocklyFramework](https://github.com/ocadotechnology/rapid-router-ios/blob/AddReadMe/images/ShareBlocklyFramework.png)
    
- At the root of the iOS project, run `carthage build`
