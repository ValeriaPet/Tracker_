import Foundation
import UIKit

class TrackersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TrackerCollectionViewCellDelegate {
    
    private var collectionView: UICollectionView!
    private var trackerCategories: [TrackerCategory] = []
    private var filteredTrackerCategories: [TrackerCategory] = []
    
    private var searchBar = UISearchBar()
    private var label = UILabel()
    private var plusButton = UIButton()
    private var datePicker = UIDatePicker()
    private var iconImageView = UIView()
    private var stubImageView = UIImageView()
    private var imageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupPlusButton()
        setupLabel()
        setupSearchBar()
        setupCollectionView()
        setupDatePicker()
        setupIcon()
        loadTrackers()
        
        filterTrackers(by: Date())
    }
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.title = "Трекеры"
    }
    
    @objc private func addTapped() {
        let createTrackerVC = TypeSelectionViewController()
        createTrackerVC.modalPresentationStyle = .pageSheet
        present(createTrackerVC, animated: true, completion: nil)
    }
    
    private func setupPlusButton() {
        guard let plusButtonImage = UIImage(named: "icadd_tracker") else {
            return
        }
        plusButton = UIButton.systemButton(with: plusButtonImage, target: self, action: #selector(plusButtonAction))
        plusButton.tintColor = .black
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            plusButton.widthAnchor.constraint(equalToConstant: 44),
            plusButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func plusButtonAction() {
        let createTrackerVC = TypeSelectionViewController()
        createTrackerVC.modalPresentationStyle = .pageSheet
        present(createTrackerVC, animated: true, completion: nil)
    }
    
    private func setupLabel() {
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupSearchBar() {
        searchBar.layer.cornerRadius = 8
        searchBar.placeholder = "Поиск"
        searchBar.searchTextField.textColor = .black
        searchBar.searchBarStyle = .minimal
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            datePicker.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -53),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 282),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    private func setupIcon() {
        iconImageView.backgroundColor = .none
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(iconImageView)
        
        let image = UIImage(named: "mainIcon")
        stubImageView = UIImageView(image: image)
        stubImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.addSubview(stubImageView)
        
        imageLabel.text = "Что будем отслеживать?"
        imageLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        imageLabel.textColor = .black
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.addSubview(imageLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 110),
            
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.bottomAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            stubImageView.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
            
            imageLabel.heightAnchor.constraint(equalToConstant: 18),
            imageLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            imageLabel.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier)
        
        // Регистрация хедера для секций
        collectionView.register(TrackerHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeaderReusableView.reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadTrackers() {
        let calendar = Calendar.current
        let today = Date()
        
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
        
        // Создаем примеры категорий и трекеров с учетом количества дней выполнения
        trackerCategories = [
            TrackerCategory(name: "Happy House", trackers: [
                Tracker(id: UUID(),
                        category: "Happy House",
                        title: "Поливать растения",
                        daysCompleted: 1,
                        isCompletedForToday: false,
                        color: .colorSelection1,
                        emoji: "🌱",
                        creationDate: twoDaysAgo,
                        totalCompletions: 2)
            ]),
            TrackerCategory(name: "Favorite things", trackers: [
                Tracker(id: UUID(),
                        category: "Favorite things",
                        title: "Кошка заслонила камеру на созвоне",
                        daysCompleted: 1,
                        isCompletedForToday: false,
                        color: .colorSelection2,
                        emoji: "🐱",
                        creationDate: twoDaysAgo,
                        totalCompletions: 2),
                
                Tracker(id: UUID(),
                        category: "Favorite things",
                        title: "Бабушка прислала открытку в WhatsApp",
                        daysCompleted: 1,
                        isCompletedForToday: false,
                        color: .colorSelection3,
                        emoji: "👵",
                        creationDate: twoDaysAgo,
                        totalCompletions: 2)
            ])
        ]
        filterTrackers(by: today)
    }

    private func filterTrackers(by date: Date) {
        // Фильтруем трекеры, созданные на указанную дату
        filteredTrackerCategories = trackerCategories.map { category in
            let filteredTrackers = category.trackers.filter { Calendar.current.isDate($0.creationDate, inSameDayAs: date) }
            return TrackerCategory(name: category.name, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
        
        collectionView.reloadData()
        updateIconVisibility()
    }

    private func updateIconVisibility() {
        // Если нет трекеров для отображения, показываем заглушку
        iconImageView.isHidden = !filteredTrackerCategories.isEmpty
    }

    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        filterTrackers(by: sender.date)
    }

    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackerCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = trackerCategories[indexPath.section].trackers[indexPath.item]
        cell.tracker = tracker
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 48) / 2 // Два элемента в ряду
        return CGSize(width: width, height: 148) // Увеличен размер ячейки для размещения двух блоков
    }
    
    // MARK: - Хэдеры для секций
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerHeaderReusableView.reuseIdentifier, for: indexPath) as? TrackerHeaderReusableView else {
            return UICollectionReusableView()
        }
        
        header.title = trackerCategories[indexPath.section].name
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18) // Высота хедера
    }
    
    // MARK: - TrackerCollectionViewCellDelegate
    
    func didCompleteTracker(_ cell: TrackerCollectionViewCell, tracker: Tracker, isCompleted: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        var updatedTracker = trackerCategories[indexPath.section].trackers[indexPath.item]
        
        if isCompleted {
            updatedTracker.isCompletedForToday = true
            updatedTracker.daysCompleted += 1
        } else {
            updatedTracker.isCompletedForToday = false
            updatedTracker.daysCompleted -= 1
        }
        
        trackerCategories[indexPath.section].trackers[indexPath.item] = updatedTracker
        collectionView.reloadItems(at: [indexPath])
    }
}
