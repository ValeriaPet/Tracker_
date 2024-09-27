import Foundation
import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func addNewCategory(newCategory: String)
}

final class NewCategoryViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.tintColor = .black
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = .lightGray1
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 16
        textField.delegate = self
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Добавить", for: .normal)
        button.tintColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    weak var delegate: NewCategoryViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        view.addSubview(categoryNameTextField)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        guard let categoryName = categoryNameTextField.text, !categoryName.isEmpty else { return }
        delegate?.addNewCategory(newCategory: categoryName)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let isFormValid = !text.isEmpty
        addButton.isEnabled = isFormValid
        addButton.backgroundColor = isFormValid ? .black : .lightGray1
    }
}
