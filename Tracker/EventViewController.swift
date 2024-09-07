import Foundation
import UIKit

class EventViewController: UIViewController, UITextFieldDelegate {
    
    let categoryButton = UIButton(type: .system)
    let nameTextField = UITextField()
    let createButton = UIButton(type: .system)
    
    var onCreateTracker: ((TrackerCategory) -> Void)?
    var selectedCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        setupObservers()
        
        nameTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() 
        return true
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
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
        nameTextField.setLeftPaddingPoints(16)
        view.addSubview(nameTextField)
        
        // Кнопка для выбора категории
        categoryButton.backgroundColor = .backgroundDay
        categoryButton.setTitle("Категория", for: .normal)
        categoryButton.setTitleColor(.black, for: .normal)
        categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
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
        cancelButton.setTitleColor(UIColor.systemRed.withAlphaComponent(0.5), for: .normal)
        
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.5).cgColor
        
        cancelButton.layer.cornerRadius = 16
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        // Кнопка "Создать"
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.backgroundColor = .lightGray
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
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 163),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 163),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupObservers() {
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        
        updateCreateButtonState()
    }
    
    @objc private func categoryButtonTapped() {
        let categorySelectionVC = CategorySelectionViewController()
        categorySelectionVC.onCategorySelected = { [weak self] selectedCategory in
            self?.selectedCategory = selectedCategory
            self?.categoryButton.setTitle("Категория \(selectedCategory)", for: .normal)
            self?.updateCreateButtonState()
        }
        categorySelectionVC.modalPresentationStyle = .pageSheet
        present(categorySelectionVC, animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func createButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
        
        guard !selectedCategory.isEmpty else {
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
    
    private func updateCreateButtonState() {
        let isFormValid = !nameTextField.text!.isEmpty && !selectedCategory.isEmpty
        createButton.backgroundColor = isFormValid ? .black : .lightGray
        createButton.isEnabled = isFormValid
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
