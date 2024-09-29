import UIKit

enum Key: String {
    case isFirstLaunch
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let isFirstLaunch = UserDefaults.standard.object(forKey: Key.isFirstLaunch.rawValue)
        if isFirstLaunch != nil {
            showTrackerViewController()
        } else {
            showOnboardingScreen()
        }
    }
    
    private func showTrackerViewController() {
        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    private func showOnboardingScreen() {
        let pageViewController = PageViewController()
        window?.rootViewController = pageViewController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataHelper.shared.saveContext()
    }
}
