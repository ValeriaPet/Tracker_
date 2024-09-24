import UIKit


class HabitViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let scheduleButton = UIButton(type: .system)
    let categoryButton = UIButton(type: .system)
    let nameTextField = UITextField()
    let createButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)
    
    let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var onCreateTracker: ((TrackerCategory) -> Void)?
    var selectedSchedule: [Weekday] = []
    var selectedCategory: String = ""
    var selectedEmoji: Int?
    var selectedColor: Int?
    
    private let emojiList = ["😊", "🎉", "💀", "😎", "😇", "😄", "💖", "🚀", "🎨", "🎁", "👑", "💪", "🤖", "🎸", "🌈", "🔥", "🍕", "🍔"]
    private let colorNames: [UIColor] = (1...18).compactMap { UIColor(named: "Color\($0)") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupObservers()
        
        nameTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func setupUI() {
        // Добавляем UIScrollView и contentView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Заголовок
        let titleLabel = UILabel()
        titleLabel.text = "Новая привычка"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        nameTextField.leftView = paddingView
        nameTextField.leftViewMode = .always
        
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.borderStyle = .none
        nameTextField.backgroundColor = .backgroundDay
        nameTextField.layer.cornerRadius = 16
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameTextField)
        
        // Контейнер для кнопок категории и расписания
        let container = UIView()
        container.backgroundColor = .backgroundDay
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        
        // Кнопка категории
        let categoryArrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        categoryArrow.tintColor = .gray
        categoryArrow.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(categoryArrow)
        
        categoryButton.backgroundColor = .none
        categoryButton.setTitle("Категория \(selectedCategory)", for: .normal)
        categoryButton.setTitleColor(.black, for: .normal)
        categoryButton.contentHorizontalAlignment = .left
        categoryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        categoryButton.layer.cornerRadius = 16
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        container.addSubview(categoryButton)
        
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(separator)
        
        // Кнопка расписания
        let scheduleArrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        scheduleArrow.tintColor = .gray
        scheduleArrow.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(scheduleArrow)
        
        scheduleButton.backgroundColor = .none
        scheduleButton.setTitle("Расписание", for: .normal)
        scheduleButton.setTitleColor(.black, for: .normal)
        scheduleButton.contentHorizontalAlignment = .left
        scheduleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        scheduleButton.layer.cornerRadius = 16
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        container.addSubview(scheduleButton)
        
        // Добавляем элементы на contentView
        contentView.addSubview(cancelButton)
        contentView.addSubview(createButton)
        
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor.systemRed.withAlphaComponent(0.5), for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.5).cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = .lightGray
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        // Коллекция для Emoji
        let emojiLabel = UILabel()
        emojiLabel.text = "Emoji"
        emojiLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        
        let emojiLayout = UICollectionViewFlowLayout()
        emojiLayout.minimumInteritemSpacing = 5
        emojiLayout.minimumLineSpacing = 10
        let cellWidth = (view.bounds.width - 40) / 6
        emojiLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        emojiCollectionView.collectionViewLayout = emojiLayout
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojiCollectionView.backgroundColor = .clear
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.register(EmojiCollectionCell.self, forCellWithReuseIdentifier: "emojiCell")
        contentView.addSubview(emojiCollectionView)
        
        // Коллекция для цветов
        let colorLabel = UILabel()
        colorLabel.text = "Цвет"
        colorLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorLabel)
        
        let colorLayout = UICollectionViewFlowLayout()
        colorLayout.minimumInteritemSpacing = 5
        colorLayout.minimumLineSpacing = 10
        colorLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        colorCollectionView.collectionViewLayout = colorLayout
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorCollectionView.backgroundColor = .clear
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(ColorCollectionCell.self, forCellWithReuseIdentifier: "colorCell")
        contentView.addSubview(colorCollectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
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
            
            emojiLabel.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 24),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 24),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 163),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 20),
            createButton.widthAnchor.constraint(equalToConstant: 163),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
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
            self?.updateCreateButtonState()
        }
        
        present(scheduleVC, animated: true, completion: nil)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func createButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
        
        guard let selectedEmoji = selectedEmoji, let selectedColor = selectedColor else {
            return
        }
        
        let emoji = emojiList[selectedEmoji]
        let color = colorNames[selectedColor]
        
        let newTracker = Tracker(
            id: UUID(),
            title: name,
            color: color,
            emoji: emoji,
            schedule: selectedSchedule,
            creationDate: Date()
        )
        
        let newCategory = TrackerCategory(name: selectedCategory, trackers: [newTracker])
        
        onCreateTracker?(newCategory)
        dismiss(animated: true, completion: nil)
    }
    
    private func updateCreateButtonState() {
        let isFormValid = !nameTextField.text!.isEmpty && !selectedCategory.isEmpty && !selectedSchedule.isEmpty && selectedEmoji != nil && selectedColor != nil
        createButton.isEnabled = isFormValid
        createButton.backgroundColor = isFormValid ? .black : .lightGray
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == emojiCollectionView ? emojiList.count : colorNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCollectionCell
            let emoji = emojiList[indexPath.item]
            cell.configure(withEmoji: emoji, isSelected: selectedEmoji == indexPath.item)
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionCell
            let color = colorNames[indexPath.item]
            cell.configure(withColor: color, isSelected: selectedColor == indexPath.item)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            selectedEmoji = indexPath.item
        } else {
            selectedColor = indexPath.item
        }
        collectionView.reloadData()
        updateCreateButtonState()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}
