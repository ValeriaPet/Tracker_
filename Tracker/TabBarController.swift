import UIKit

class TabBarController: UIViewController {

    private var searchBar = UISearchBar()
    private var label = UILabel()
    private var iconImageView = UIView()
    private var stubImageView = UIImageView()
    private var iconImage = UIImage()
    private var imageLabel = UILabel()
    private var tabBar = UITabBar()
    private var plusButton = UIButton()
    private var datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        setupNavigationBar()
        setupPlusButton()
        setupLabel()
        setupSearchBar()
        setupIcon()
        setupTabBar()
        setupDatePicker()
    }


    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.title = "Трекеры"
    }

    @objc func addTapped() {
    }

    func setupPlusButton() {
        guard let plusButtonImage = UIImage(named: "icadd_tracker") else {
            return
        }
        let plusButton = UIButton.systemButton(with: plusButtonImage, target: self, action: #selector(plusButtonAction))
        plusButton.tintColor = .black

        plusButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plusButton)
        self.plusButton = plusButton

        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            plusButton.widthAnchor.constraint(equalToConstant: 44),
            plusButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    @objc func plusButtonAction() {
        let createTrackerVC = CreateTrackerViewController()
        createTrackerVC.modalPresentationStyle = .pageSheet // Можно использовать .overFullScreen для прозрачного фона
        present(createTrackerVC, animated: true, completion: nil)
    }


    func setupLabel() {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
        view.addSubview(label)
        self.label = label

        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 0)
        ])
    }

    func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.layer.cornerRadius = 8
        searchBar.placeholder = "Поиск"
        searchBar.searchTextField.textColor = .black
        searchBar.searchBarStyle = .minimal

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        self.searchBar = searchBar

        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    func setupIcon() {

        let iconImageView = UIView()
        iconImageView.backgroundColor = .none
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(iconImageView)
        self.iconImageView = iconImageView

        let image = UIImage(named:"mainIcon")
        let stubImageView = UIImageView(image: image)
        stubImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.addSubview(stubImageView)
        self.stubImageView = stubImageView

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

    func setupTabBar() {
        let tabBar = UITabBar()

        // Create Tab Bar Items
        let trackerItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackers"),
            selectedImage: nil)
        let statisticItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "stats"),
            selectedImage: nil)
        tabBar.items = [trackerItem, statisticItem]
        tabBar.selectedItem = trackerItem
        tabBar.tintColor = .systemBlue

        // Add the TabBar to the view hierarchy
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)
        self.tabBar = tabBar


        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 84)
        ])
    }


    func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        self.datePicker = datePicker

        NSLayoutConstraint.activate([
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            datePicker.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -53),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 282),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
