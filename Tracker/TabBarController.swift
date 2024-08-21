import Foundation
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Инициализация контроллеров для вкладок
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackers"), selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "stats"), selectedImage: nil)

        viewControllers = [trackersViewController, statisticsViewController]
        selectedIndex = 0
        tabBar.tintColor = .systemBlue
    }
}
