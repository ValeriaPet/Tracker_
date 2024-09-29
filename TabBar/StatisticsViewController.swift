import Foundation
import UIKit

final class StatisticsViewController: UIViewController {
    private var listOfTrackers = [String]()
    
    private lazy var stubImageView: UIImageView = {
        let image = UIImage(named: "stub2")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализ невозможен"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.textColor = UIColor(named: "black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var navigationBar: UINavigationBar = {
        let navigationBar = navigationController?.navigationBar ?? UINavigationBar()
        navigationBar.topItem?.title = "Статистика"
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
        return navigationBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
        setupConstraints()
    }
    
    private func setupView(){
        view.addSubview(stubImageView)
        view.addSubview(stubLabel)
        view.addSubview(navigationBar)
    }
    
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            stubLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            stubLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
