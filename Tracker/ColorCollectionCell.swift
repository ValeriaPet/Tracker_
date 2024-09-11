import UIKit

final class ColorCollectionCell: UICollectionViewCell {

    private var backgroundCellView = UIView()
    private var colorView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(withColor color: UIColor, isSelected: Bool) {
        // Устанавливаем цвет из ассетов
        colorView.backgroundColor = color
        
        backgroundCellView.layer.borderColor = isSelected ? color.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
        backgroundCellView.layer.borderWidth = isSelected ? 2 : 0
    }



    private func setupUI() {
        backgroundCellView.layer.masksToBounds = true
        backgroundCellView.layer.cornerRadius = 12
        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(backgroundCellView)

        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 8
        colorView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(colorView)

        NSLayoutConstraint.activate([
            backgroundCellView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            backgroundCellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            backgroundCellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            backgroundCellView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),

            colorView.topAnchor.constraint(equalTo: backgroundCellView.topAnchor, constant: 5),
            colorView.bottomAnchor.constraint(equalTo: backgroundCellView.bottomAnchor, constant: -5),
            colorView.leadingAnchor.constraint(equalTo: backgroundCellView.leadingAnchor, constant: 5),
            colorView.trailingAnchor.constraint(equalTo: backgroundCellView.trailingAnchor, constant: -5)
        ])
    }
}
