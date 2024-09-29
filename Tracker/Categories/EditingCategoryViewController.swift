import Foundation
import UIKit

protocol EditingCategoryViewControllerDelegate: AnyObject {
    func saveEditingCategory(editingCategory: String)
}

final class EditingCategoryViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var categoryNameEditing: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.tintColor = .black
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = .backgroundDay
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 16
        textField.delegate = self
        return textField
    }()
    
    private lazy var saveCategoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .grayasset
        button.setTitle("Готово", for: .normal)
        button.tintColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveEditingCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Редактирование категории"
        title.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    } ()
    
    // MARK: - Properties
    var editingCategory = ""
    weak var delegate: EditingCategoryViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        categoryNameEditing.text = editingCategory
        setupUI()
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        view.addSubview(categoryNameEditing)
        view.addSubview(saveCategoryButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            categoryNameEditing.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameEditing.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryNameEditing.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryNameEditing.heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    @objc private func saveEditingCategoryButtonTapped() {
        delegate?.saveEditingCategory(editingCategory: editingCategory)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension EditingCategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let newText = textField.text else { return }
        let isNameFilled = !newText.isEmpty
        saveCategoryButton.isEnabled = isNameFilled
        saveCategoryButton.backgroundColor = isNameFilled ? .black : .grayasset
        editingCategory = newText
    }
}
