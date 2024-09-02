import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TrackerCell"
    
    private let coloredView = UIView()
    private let titleLabel = UILabel()
    private let emojiLabel = UILabel()
    private let completionButton = UIButton()
    private let daysLabel = UILabel()  // Label для отображения количества выполнений
    
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    var tracker: Tracker? {
        didSet {
            guard let tracker = tracker else { return }
            titleLabel.text = tracker.title
            emojiLabel.text = tracker.emoji
            coloredView.backgroundColor = tracker.color
            updateButtonAppearance()
            updateDaysCompleted()
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
        
        daysLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        daysLabel.textColor = .black
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(daysLabel)
        
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        completionButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        contentView.addSubview(completionButton)
        
        NSLayoutConstraint.activate([
            coloredView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coloredView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coloredView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coloredView.heightAnchor.constraint(equalToConstant: 100),
            
            emojiLabel.topAnchor.constraint(equalTo: coloredView.topAnchor, constant: 8),
            emojiLabel.leadingAnchor.constraint(equalTo: coloredView.leadingAnchor, constant: 8),
            
            titleLabel.leadingAnchor.constraint(equalTo: coloredView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: coloredView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: coloredView.bottomAnchor, constant: -8),
            
            daysLabel.topAnchor.constraint(equalTo: coloredView.bottomAnchor, constant: 8),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            completionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            completionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            completionButton.widthAnchor.constraint(equalToConstant: 34),
            completionButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    func updateButtonAppearance() {
        guard let tracker = tracker else { return }
        updateCompletionButton(for: tracker)
    }
    
    private func updateCompletionButton(for tracker: Tracker) {
        guard let isCompleted = delegate?.isTrackerCompletedToday(tracker) else { return }
        let originalColor = tracker.color

        if isCompleted {
            completionButton.tintColor = originalColor.withAlphaComponent(0.5)
            completionButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            completionButton.tintColor = originalColor
            completionButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        }
    }
    
    func updateDaysCompleted() {
        guard let tracker = tracker, let totalCompletions = delegate?.totalCompletions(for: tracker) else { return }
        daysLabel.text = "\(totalCompletions) дней"
    }
    
    @objc private func completionButtonTapped() {
        guard let tracker = tracker else { return }
        let isCompleted = delegate?.isTrackerCompletedToday(tracker) ?? false
        delegate?.didCompleteTracker(self, tracker: tracker, isCompleted: !isCompleted)
    }
}
