
import Foundation
import UIKit

struct Tracker {
    let id: UUID
    let category: String
    let title: String
    var daysCompleted: Int
    var isCompletedForToday: Bool
    let color: UIColor
    let emoji: String
    let creationDate: Date
    let totalCompletions: Int // Количество необходимых выполнений
}


struct TrackerCategory {
    let name: String
    var trackers: [Tracker]
}

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func didCompleteTracker(_ cell: TrackerCollectionViewCell, tracker: Tracker, isCompleted: Bool)
}

class TrackerCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TrackerCell"
    
    private let coloredView = UIView()
    private let titleLabel = UILabel()
    private let emojiLabel = UILabel()
    
    private let completionView = UIView()
    private let daysLabel = UILabel()
    private let completionButton = UIButton()
    
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    var tracker: Tracker? {
        didSet {
            guard let tracker = tracker else { return }
            titleLabel.text = tracker.title
            emojiLabel.text = tracker.emoji
            daysLabel.text = "\(tracker.daysCompleted) дней"
            updateCompletionButton(for: tracker.isCompletedForToday)
            coloredView.backgroundColor = tracker.color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
        // Настройка цветного блока
        coloredView.layer.cornerRadius = 16
        coloredView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(coloredView)
        
        emojiLabel.font = UIFont.systemFont(ofSize: 24)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        coloredView.addSubview(emojiLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 3
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        coloredView.addSubview(titleLabel)
        
        // Настройка бесцветного блока
        completionView.backgroundColor = .white
        completionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(completionView)
        
        daysLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        daysLabel.textColor = .black
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        completionView.addSubview(daysLabel)
        
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        completionButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        completionView.addSubview(completionButton)
        
        // Установка констрейнтов
        NSLayoutConstraint.activate([
            // Цветной блок
            coloredView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coloredView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coloredView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coloredView.heightAnchor.constraint(equalToConstant: 100),
            
            emojiLabel.topAnchor.constraint(equalTo: coloredView.topAnchor, constant: 8),
            emojiLabel.leadingAnchor.constraint(equalTo: coloredView.leadingAnchor, constant: 8),
            
            titleLabel.leadingAnchor.constraint(equalTo: coloredView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: coloredView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: coloredView.bottomAnchor, constant: -8),
            
            // Бесцветный блок
            completionView.topAnchor.constraint(equalTo: coloredView.bottomAnchor),
            completionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            completionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            completionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            daysLabel.leadingAnchor.constraint(equalTo: completionView.leadingAnchor, constant: 8),
            daysLabel.centerYAnchor.constraint(equalTo: completionView.centerYAnchor),
            
            completionButton.trailingAnchor.constraint(equalTo: completionView.trailingAnchor, constant: -8),
            completionButton.centerYAnchor.constraint(equalTo: completionView.centerYAnchor),
            completionButton.widthAnchor.constraint(equalToConstant: 34),
            completionButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    private func updateCompletionButton(for isCompleted: Bool) {
        guard let tracker = tracker else { return }
        let originalColor = tracker.color
        
        if isCompleted {
            // Приглушаем цвет, уменьшая альфа-канал
            completionButton.tintColor = originalColor.withAlphaComponent(0.5)
            completionButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            // Восстанавливаем исходный цвет
            completionButton.tintColor = originalColor
            completionButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        }
    }
    
    @objc private func completionButtonTapped() {
        guard let tracker = tracker else { return }
        delegate?.didCompleteTracker(self, tracker: tracker, isCompleted: !tracker.isCompletedForToday)
    }
}



