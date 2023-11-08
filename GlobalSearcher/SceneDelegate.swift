import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController!
    var rootViewController = RootViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

let baseNavBarAppearance: UINavigationBarAppearance = {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    return appearance
}()

let searchNavBarAppearance: UINavigationBarAppearance = {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundImage = UIImage(named: "search-container-nav-bar")
    appearance.backgroundImageContentMode = .scaleToFill
    appearance.shadowColor = .clear
    return appearance
}()

extension UINavigationController {
    func setAppearance(_ appearance: UINavigationBarAppearance) {
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}
