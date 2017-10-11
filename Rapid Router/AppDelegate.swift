

import ReSwift

let mainStore = Store<AppState>(
    reducer: levelChangeReducer,
    state: nil,
    middleware: [unityComunicatorMiddleware]
)

class AppDelegate: UIResponder, UIApplicationDelegate {
    @objc var currentUnityController: UnityAppController?
    var application: UIApplication?
    var isUnityRunning = false
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        self.application = application
        currentUnityController = UnityAppController()
        currentUnityController!.application(application, didFinishLaunchingWithOptions: launchOptions)

        startUnity()
        stopUnity()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if isUnityRunning {
            currentUnityController?.applicationWillResignActive(application)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if isUnityRunning {
            currentUnityController?.applicationDidEnterBackground(application)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if isUnityRunning {
            currentUnityController?.applicationWillEnterForeground(application)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if isUnityRunning {
            currentUnityController?.applicationDidBecomeActive(application)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if isUnityRunning {
            currentUnityController?.applicationWillTerminate(application)
        }
    }

    func startUnity() {
        if !isUnityRunning {
            isUnityRunning = true
            currentUnityController!.applicationDidBecomeActive(application!)
        }
    }

    func stopUnity() {
        if isUnityRunning {
            currentUnityController!.applicationWillResignActive(application!)
            isUnityRunning = false
        }
    }
}
