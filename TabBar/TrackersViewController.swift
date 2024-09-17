import UIKit
import CoreData

final class TrackersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TrackerCollectionViewCellDelegate {
    
    private var collectionView: UICollectionView!
    private var categories: [TrackerCategory] = []
    private var filteredTrackerCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date() {
        didSet {
            filterTrackers(by: currentDate)
        }
    }
    
    private var searchBar = UISearchBar()
    private var label = UILabel()
    private var plusButton = UIButton()
    private var datePicker = UIDatePicker()
    private var iconImageView = UIView()
    private var stubImageView = UIImageView()
    private var imageLabel = UILabel()
    
    private var context: NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        setupNavigationBar()
        setupPlusButton()
        setupLabel()
        setupSearchBar()
        setupCollectionView()
        setupDatePicker()
        setupIcon()
        loadTrackers()
        
        filterTrackers(by: currentDate)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.title = "Трекеры"
    }
    
    @objc private func addTapped() {
        let createTrackerVC = TypeSelectionViewController()
        createTrackerVC.onCreateTracker = { [weak self] newCategory in
            self?.addNewTrackerCategory(newCategory)
        }
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
        createTrackerVC.onCreateTracker = { [weak self] newCategory in
            self?.addNewTrackerCategory(newCategory)
        }
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
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        
        do {
            let trackerCoreDataArray = try context.fetch(fetchRequest)
            
            // Преобразуем TrackerCoreData в массив Tracker
            categories = trackerCoreDataArray.map { trackerCoreData in
                let tracker = Tracker(
                    id: UUID(),
                    title: trackerCoreData.title ?? "",
                    color: UIColor(named: trackerCoreData.color as? String ?? "") ?? UIColor.clear,
                    emoji: trackerCoreData.emoji ?? "",
                    schedule: trackerCoreData.schedule?.selectedDays ?? [],
                    creationDate: trackerCoreData.creationDate ?? Date()
                )
                
                let categoryName = trackerCoreData.category?.name ?? "Без категории"
                return TrackerCategory(name: categoryName, trackers: [tracker])
            }
            
        } catch {
            print("Failed to fetch trackers: \(error)")
        }
    }
    
    func isTrackerCompletedToday(_ tracker: Tracker) -> Bool {
        return completedTrackers.contains { $0.trackerID == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
    }
    
    private func filterTrackers(by date: Date) {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date) - 1
        let weekdayEnum = Weekday(rawValue: weekday)!
        
        filteredTrackerCategories = categories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                if tracker.schedule.isEmpty {
                    return calendar.isDate(tracker.creationDate, inSameDayAs: date)
                }
                return tracker.schedule.contains(weekdayEnum) && calendar.compare(tracker.creationDate, to: date, toGranularity: .day) != .orderedDescending
            }
            return TrackerCategory(name: category.name, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
        
        collectionView.reloadData()
        updateIconVisibility()
    }
    
    private func updateIconVisibility() {
        iconImageView.isHidden = !filteredTrackerCategories.isEmpty
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredTrackerCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTrackerCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = filteredTrackerCategories[indexPath.section].trackers[indexPath.item]
        cell.tracker = tracker
        cell.delegate = self
        
        // Обновляем состояние кнопки
        cell.updateButtonAppearance()
        cell.updateDaysCompleted()
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 48) / 2
        return CGSize(width: width, height: 148)
    }
    
    // MARK: - Headers for sections
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerHeaderReusableView.reuseIdentifier, for: indexPath) as? TrackerHeaderReusableView else {
            return UICollectionReusableView()
        }
        
        header.title = filteredTrackerCategories[indexPath.section].name
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
    
    // MARK: - TrackerCollectionViewCellDelegate
    
    func totalCompletions(for tracker: Tracker) -> Int {
        return completedTrackers.filter { $0.trackerID == tracker.id }.count
    }
    
    
    func didCompleteTracker(_ cell: TrackerCollectionViewCell, tracker: Tracker, isCompleted: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        if currentDate > Date() {
            return // Не разрешаем отмечать трекер для будущего времени
        }
        
        // Найдите трекер в Core Data по идентификатору
        guard let coreDataTracker = fetchCoreDataTracker(by: tracker.id) else {
            print("Tracker not found in Core Data")
            return
        }
        
        let record = TrackerRecordCoreData(context: context)
        record.date = currentDate
        record.isCompleted = isCompleted
        record.uuid = coreDataTracker.id

        do {
            try context.save()
        } catch {
            print("Failed to save tracker record: \(error)")
        }
        
        // Обновляем отображение
        collectionView.reloadItems(at: [indexPath])
    }

    
    private func fetchCoreDataTracker(by id: UUID) -> TrackerCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let trackers = try context.fetch(fetchRequest)
            return trackers.first
        } catch {
            print("Failed to fetch tracker: \(error)")
            return nil
        }
    }
    
    
    // MARK: - Adding new tracker to the selected category
    

    private func addNewTrackerCategory(_ newCategory: TrackerCategory) {
        for tracker in newCategory.trackers {
            // Создаем объект сущности для трекера в Core Data
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = tracker.id
            trackerCoreData.title = tracker.title
            trackerCoreData.color = tracker.color
            trackerCoreData.creationDate = tracker.creationDate
            
            // Связь с категорией
            let categoryCoreData = TrackerCategoryCoreData(context: context)
            categoryCoreData.name = newCategory.name
            trackerCoreData.category = categoryCoreData
            
            do {
                try context.save()
            } catch {
                print("Failed to save new tracker: \(error)")
            }
        }
        
        // Обновляем отображение
        loadTrackers()
        filterTrackers(by: currentDate)
        collectionView.reloadData()
    }
    
}
