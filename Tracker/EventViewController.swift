import Foundation
import UIKit

class EventViewController: UIViewController {
    
    let categoryButton = UIButton(type: .system)
    let nameTextField = UITextField()
    
    var onCreateTracker: ((TrackerCategory) -> Void)?
    var selectedCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        // Заголовок
        let titleLabel = UILabel()
        titleLabel.text = "Новое нерегулярное событие"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Поле для ввода названия
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.borderStyle = .none
        nameTextField.backgroundColor = .backgroundDay
        nameTextField.layer.cornerRadius = 16
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        // Кнопка для выбора категории
        categoryButton.backgroundColor = .backgroundDay
        categoryButton.setTitle("Категория", for: .normal)
        categoryButton.setTitleColor(.black, for: .normal)
        categoryButton.contentHorizontalAlignment = .left
        categoryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        categoryButton.layer.cornerRadius = 16
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        view.addSubview(categoryButton)
        
        // Стрелка рядом с кнопкой "Категория"
        let eventCategoryArrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        eventCategoryArrow.tintColor = .gray
        eventCategoryArrow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventCategoryArrow)
        
        // Кнопка "Отменить"
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        // Кнопка "Создать"
        let createButton = UIButton(type: .system)
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = .gray
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            categoryButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            eventCategoryArrow.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            eventCategoryArrow.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            
            cancelButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            
            createButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            createButton.widthAnchor.constraint(equalToConstant: 161),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func categoryButtonTapped() {
        let categorySelectionVC = CategorySelectionViewController()
        categorySelectionVC.onCategorySelected = { [weak self] selectedCategory in
            self?.selectedCategory = selectedCategory
            self?.categoryButton.setTitle("Категория \(selectedCategory)", for: .normal)
        }
        categorySelectionVC.modalPresentationStyle = .pageSheet
        present(categorySelectionVC, animated: true, completion: nil)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            // Покажите сообщение о необходимости ввести название
            return
        }
        
        guard !selectedCategory.isEmpty else {
            // Покажите сообщение о необходимости выбрать категорию
            return
        }
        
        let newTracker = Tracker(id: UUID(),
                                 title: name,
                                 color: .colorSelection10,
                                 emoji: "🤡",
                                 schedule: [], // Нерегулярные события не имеют расписания
                                 creationDate: Date())
        
        let newCategory = TrackerCategory(name: selectedCategory, trackers: [newTracker])
        
        onCreateTracker?(newCategory)
        dismiss(animated: true, completion: nil)
    }
}
