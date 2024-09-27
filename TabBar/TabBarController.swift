import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBars()
        setUpperLine()
    }
    
    private func setupBars() {
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackers"), selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "stats"), selectedImage: nil)
        
        viewControllers = [trackersViewController, statisticsViewController]
        selectedIndex = 0
        tabBar.tintColor = .systemBlue
    }
    
    private func setUpperLine () {
        let upperLine = UIView()
        upperLine.backgroundColor = .lightGray
        upperLine.translatesAutoresizingMaskIntoConstraints = false
        self.tabBar.addSubview(upperLine)
        
        NSLayoutConstraint.activate([
            upperLine.heightAnchor.constraint(equalToConstant: 0.5),
            upperLine.topAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.topAnchor, constant: 0),
            upperLine.leadingAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            upperLine.trailingAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
}
