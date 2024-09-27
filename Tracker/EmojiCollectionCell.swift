import UIKit

final class EmojiCollectionCell: UICollectionViewCell {
    
    private var backgroundCellView = UIView()
    private var emojiLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withEmoji emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        backgroundCellView.backgroundColor = isSelected ? .lightGray1.withAlphaComponent(1) : .clear
    }
    
    private func setupUI() {
        
        backgroundCellView.layer.masksToBounds = true
        backgroundCellView.layer.cornerRadius = 16
        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(backgroundCellView)
        
        emojiLabel.font = UIFont.systemFont(ofSize: 28)
        emojiLabel.textAlignment = .center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            backgroundCellView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            backgroundCellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            backgroundCellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            backgroundCellView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            emojiLabel.centerXAnchor.constraint(equalTo: backgroundCellView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: backgroundCellView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalTo: backgroundCellView.widthAnchor, multiplier: 0.62),
            emojiLabel.heightAnchor.constraint(equalTo: backgroundCellView.heightAnchor, multiplier: 0.62)
        ])
    }
}
