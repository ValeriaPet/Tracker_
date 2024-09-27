import Foundation
import UIKit

final class TypeSelectionViewController: UIViewController {
    
    // Замыкание для передачи нового трекера обратно
    var onCreateTracker: ((TrackerCategory) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        // Заголовок
        let titleLabel = UILabel()
        titleLabel.text = "Создание трекера"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Кнопка "Привычка"
        let habitButton = UIButton(type: .system)
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        habitButton.backgroundColor = .black
        habitButton.setTitleColor(.white, for: .normal)
        habitButton.layer.cornerRadius = 16
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        view.addSubview(habitButton)
        
        // Кнопка "Нерегулярное событие"
        let eventButton = UIButton(type: .system)
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        eventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        eventButton.backgroundColor = .black
        eventButton.setTitleColor(.white, for: .normal)
        eventButton.layer.cornerRadius = 16
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
        view.addSubview(eventButton)
        
        // Layout
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 295),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func habitButtonTapped() {
        let createHabitVC = HabitViewController()
        createHabitVC.onCreateTracker = { [weak self] newCategory in
            self?.onCreateTracker?(newCategory)
        }
        createHabitVC.modalPresentationStyle = .pageSheet
        present(createHabitVC, animated: true, completion: nil)
    }
    
    @objc func eventButtonTapped() {
        let createEventVC = EventViewController()
        createEventVC.onCreateTracker = { [weak self] newCategory in
            self?.onCreateTracker?(newCategory)
        }
        createEventVC.modalPresentationStyle = .pageSheet
        present(createEventVC, animated: true, completion: nil)
    }
}
