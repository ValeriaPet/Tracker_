import Foundation
import UIKit

protocol CategorySelectionDelegate: AnyObject {
    func didSelectCategory(_ category: String)
}

final class CategorySelectionViewController: UIViewController {
    
    //MARK: - UI Elements
    private var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var stubImageView: UIImageView = {
        let image = UIImage(named: "mainIcon")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно объединить по смыслу"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var addCategoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Добавить категорию", for: .normal)
        button.tintColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()

    //MARK: - Properties
    private var categoriesArray: [String] = []
    var selectedCategory: String?
    private var selectedIndexPath: IndexPath?
    private var editingIndex: Int?
    weak var delegate: CategorySelectionDelegate?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        categoriesArray = UserDefaults.standard.array(forKey: "categoriesArray") as? [String] ?? []
        listTableView.dataSource = self
        listTableView.delegate = self
        setupUI()
        createNavigationBar()
        setupConstraints()
        conditionStubs()
    }

    // MARK: - Private Functions
    
    
    private func setupUI() {
        view.addSubview(listTableView)
        view.addSubview(addCategoryButton)
        view.addSubview(stubImageView)
        view.addSubview(stubLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            listTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            listTableView.heightAnchor.constraint(equalToConstant: CGFloat(categoriesArray.count * 75)),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            stubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            stubLabel.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func createNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = "Категория"
    }

    private func conditionStubs() {
        if categoriesArray.isEmpty {
            listTableView.isHidden = true
            stubLabel.isHidden = false
            stubImageView.isHidden = false
        } else {
            listTableView.isHidden = false
            stubLabel.isHidden = true
            stubImageView.isHidden = true
        }
    }
    
    private func createSeparatorImageView(cell: UITableViewCell) {
        let separatorImageView = UIImageView()
        separatorImageView.image = UIImage(named: "custom_separator")
//        separatorImageView.tintColor = .gray
        separatorImageView.tag = 100
        separatorImageView.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(separatorImageView)
        
        NSLayoutConstraint.activate([
            separatorImageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16),
            separatorImageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -16),
            separatorImageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            separatorImageView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func updateTableView() {
        let heightConstraints = listTableView.constraints.filter { $0.firstAttribute == .height }
        listTableView.removeConstraints(heightConstraints)
        listTableView.heightAnchor.constraint(equalToConstant: CGFloat(categoriesArray.count * 75)).isActive = true
        listTableView.reloadData()
        view.layoutIfNeeded()
        listTableView.reloadData()
    }

    // MARK: - Actions
    @objc private func addCategoryButtonTapped() {
        if let selectedCategory = selectedCategory {
            delegate?.didSelectCategory(selectedCategory)
            dismiss(animated: true, completion: nil)
        } else {
            let newCategoryVC = NewCategoryViewController()
            newCategoryVC.delegate = self
            let navVC = UINavigationController(rootViewController: newCategoryVC)
            present(navVC, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension CategorySelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .lightGray1
        cell.textLabel?.text = categoriesArray[indexPath.row]
        cell.accessoryView = nil
        
        if categoriesArray[indexPath.row] == selectedCategory {
            selectedIndexPath = indexPath
            let checkmarkImageView = UIImageView(image: UIImage(named: "Done"))
            cell.accessoryView = checkmarkImageView
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CategorySelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
            tableView.cellForRow(at: indexPath)?.accessoryView = nil
            self.selectedIndexPath = nil
            self.selectedCategory = nil
        } else {
            if let prevSelectedIndexPath = selectedIndexPath {
                tableView.cellForRow(at: prevSelectedIndexPath)?.accessoryView = nil
            }
            let checkmarkImageView = UIImageView(image: UIImage(named: "Done"))
            tableView.cellForRow(at: indexPath)?.accessoryView = checkmarkImageView
            selectedIndexPath = indexPath
            selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(75)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать", image: nil) { [weak self] _ in
                guard let self = self else { return }
                self.editingIndex = indexPath.row
                let editingCategoryVC = EditingCategoryViewController()
                editingCategoryVC.delegate = self
                editingCategoryVC.editingCategory = self.categoriesArray[indexPath.row]
                let navVC = UINavigationController(rootViewController: editingCategoryVC)
                self.present(navVC, animated: true)
            }
            let deleteAction = UIAction(title: "Удалить", image: nil, attributes: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.categoriesArray.remove(at: indexPath.row)
                UserDefaults.standard.set(self.categoriesArray, forKey: "categoriesArray")
                if let selectedIndexPath = self.selectedIndexPath, selectedIndexPath == indexPath {
                    self.selectedIndexPath = nil
                    self.selectedCategory = nil
                }
                for visibleIndexPath in tableView.indexPathsForVisibleRows ?? [] {
                    if visibleIndexPath != indexPath {
                        tableView.cellForRow(at: visibleIndexPath)?.accessoryView = nil
                    }
                }
                self.conditionStubs()
                self.updateTableView()
            }
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
        return configuration
    }
}

// MARK: - NewCategoryViewControllerDelegate
extension CategorySelectionViewController: NewCategoryViewControllerDelegate {
    func addNewCategory(newCategory: String) {
        categoriesArray.append(newCategory)
        UserDefaults.standard.set(categoriesArray, forKey: "categoriesArray")
        selectedCategory = newCategory
        selectedIndexPath = IndexPath(row: categoriesArray.count - 1, section: 0)
        conditionStubs()
        updateTableView()
    }
}

// MARK: - EditingCategoryViewControllerDelegate
extension CategorySelectionViewController: EditingCategoryViewControllerDelegate {
    func saveEditingCategory(editingCategory: String) {
        guard let editingIndex = editingIndex else { return }
        categoriesArray[editingIndex] = editingCategory
        UserDefaults.standard.set(categoriesArray, forKey: "categoriesArray")
        selectedCategory = editingCategory
        updateTableView()
    }
}
