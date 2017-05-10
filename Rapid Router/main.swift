import Foundation
import UIKit

// overriding @UIApplicationMain
// http://stackoverflow.com/a/24021180/1060314

custom_unity_init(CommandLine.argc, CommandLine.unsafeArgv)
let newUnsafeArgv = UnsafeMutableRawPointer( CommandLine.unsafeArgv ).bindMemory( to: UnsafeMutablePointer<Int8>.self, capacity: Int( CommandLine.argc ) )
UIApplicationMain( CommandLine.argc, newUnsafeArgv , NSStringFromClass( UIApplication.self ), NSStringFromClass( AppDelegate.self ) )
