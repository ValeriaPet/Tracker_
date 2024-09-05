import UIKit

class HabitViewController: UIViewController {
    
    let scheduleButton = UIButton(type: .system)
    let categoryButton = UIButton(type: .system)
    let nameTextField = UITextField()  // Обычный UITextField
    let createButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)
    
    var onCreateTracker: ((TrackerCategory) -> Void)?
    var selectedSchedule: [Weekday] = []
    var selectedCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupObservers()
    }
    
    func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Новая привычка"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        nameTextField.leftView = paddingView
        nameTextField.leftViewMode = .always
        
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
        
        categoryButton.backgroundColor = .none
        categoryButton.setTitle("Категория \(selectedCategory)", for: .normal)
        categoryButton.setTitleColor(.black, for: .normal)
        categoryButton.contentHorizontalAlignment = .left
        categoryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        categoryButton.layer.cornerRadius = 16
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        container.addSubview(categoryButton)
        container.addSubview(categoryArrow)
        
        categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(separator)
        
        let scheduleArrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        scheduleArrow.tintColor = .gray
        scheduleArrow.translatesAutoresizingMaskIntoConstraints = false
        
        scheduleButton.backgroundColor = .none
        scheduleButton.setTitle("Расписание", for: .normal)
        scheduleButton.setTitleColor(.black, for: .normal)
        scheduleButton.contentHorizontalAlignment = .left
        scheduleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        scheduleButton.layer.cornerRadius = 16
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        container.addSubview(scheduleButton)
        container.addSubview(scheduleArrow)
        
        scheduleButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor.systemRed.withAlphaComponent(0.5), for: .normal)
        
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.5).cgColor
        
        cancelButton.layer.cornerRadius = 16
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = .lightGray
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        view.addSubview(createButton)
        
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
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
    
    @objc func textFieldDidChange() {
        updateCreateButtonState()
    }
    
    @objc func categoryButtonTapped() {
        let categorySelectionVC = CategorySelectionViewController()
        categorySelectionVC.onCategorySelected = { [weak self] selectedCategory in
            self?.selectedCategory = selectedCategory
            self?.categoryButton.setTitle("Категория: \(selectedCategory)", for: .normal)
            self?.updateCreateButtonState()
        }
        categorySelectionVC.modalPresentationStyle = .pageSheet
        present(categorySelectionVC, animated: true, completion: nil)
    }
    
    @objc func scheduleButtonTapped() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.modalPresentationStyle = .pageSheet
        
        scheduleVC.onDaysSelected = { [weak self] selectedShortDays in
            self?.selectedSchedule = selectedShortDays.compactMap { shortDay in
                switch shortDay {
                case "Пн": return Weekday.monday
                case "Вт": return Weekday.tuesday
                case "Ср": return Weekday.wednesday
                case "Чт": return Weekday.thursday
                case "Пт": return Weekday.friday
                case "Сб": return Weekday.saturday
                case "Вс": return Weekday.sunday
                default: return nil
                }
            }
            
            let daysText = selectedShortDays.joined(separator: ", ")
            self?.scheduleButton.setTitle("Расписание: \(daysText)", for: .normal)
        }
        
        present(scheduleVC, animated: true, completion: nil)
    }

    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
        
        let newTracker = Tracker(id: UUID(),
                                 title: name,
                                 color: .colorSelection13,
                                 emoji: "💀",
                                 schedule: selectedSchedule,
                                 creationDate: Date())
        
        let newCategory = TrackerCategory(name: selectedCategory, trackers: [newTracker])
        
        onCreateTracker?(newCategory)
        dismiss(animated: true, completion: nil)
    }
    
    private func updateCreateButtonState() {
        let isFormValid = !nameTextField.text!.isEmpty && !selectedCategory.isEmpty && !selectedSchedule.isEmpty
        createButton.isEnabled = isFormValid
        createButton.backgroundColor = isFormValid ? .black : .lightGray
    }
}
