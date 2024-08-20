import UIKit

class CreateHabitViewController: UIViewController {
    
    let scheduleButton = UIButton(type: .system) // Переместил кнопку в глобальное пространство
    let categoryButton = UIButton(type: .system) // Добавляем кнопку "Категория"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        // Заголовок
        let titleLabel = UILabel()
        titleLabel.text = "Новая привычка"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Поле для ввода названия
        let nameTextField = UITextField()
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.borderStyle = .none
        nameTextField.backgroundColor = .backgroundDay
        nameTextField.layer.cornerRadius = 16
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        let container = UIView()
        container.backgroundColor = .backgroundDay
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        
        let categoryArrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        categoryArrow.tintColor = .gray
        categoryArrow.translatesAutoresizingMaskIntoConstraints = false
        
        // Кнопка для выбора категории
        categoryButton.backgroundColor = .none
        categoryButton.setTitle("Категория", for: .normal)
        categoryButton.setTitleColor(.black, for: .normal)
        categoryButton.contentHorizontalAlignment = .left
        categoryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0) // Отступ текста от левого края
        categoryButton.layer.cornerRadius = 16
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        container.addSubview(categoryButton)
        container.addSubview(categoryArrow)
        
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(separator)
        
        let scheduleArrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        scheduleArrow.tintColor = .gray
        scheduleArrow.translatesAutoresizingMaskIntoConstraints = false
        
        // Кнопка для выбора расписания
        scheduleButton.backgroundColor = .none
        scheduleButton.setTitle("Расписание", for: .normal)
        scheduleButton.setTitleColor(.black, for: .normal)
        scheduleButton.contentHorizontalAlignment = .left
        scheduleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0) // Отступ текста от левого края
        scheduleButton.layer.cornerRadius = 16
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        container.addSubview(scheduleButton)
        container.addSubview(scheduleArrow)
        
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
        
        // Layout
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            container.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            container.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 150),
            
            categoryArrow.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            categoryArrow.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            
            categoryButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            separator.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            
            scheduleArrow.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),
            scheduleArrow.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            
            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 0),
            scheduleButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            scheduleButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            
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
        // Здесь можно добавить логику для выбора категории
        print("Категория выбрана")
    }
    
    @objc func scheduleButtonTapped() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.modalPresentationStyle = .pageSheet
        
        // Установка замыкания для получения выбранных дней
        scheduleVC.onDaysSelected = { [weak self] selectedShortDays in
            let daysText = selectedShortDays.joined(separator: ", ")
            self?.scheduleButton.setTitle("Расписание: \(daysText)", for: .normal)
        }
        
        present(scheduleVC, animated: true, completion: nil)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createButtonTapped() {
        print("Создание новой привычки")
        // Добавьте код для создания привычки
    }
}
