import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let daysOfWeek: [String] = [] // Используем локализованные названия дней недели
    var selectedDays: [Bool] = Array(repeating: false, count: 7)
    
    // Замыкание для передачи выбранных дней
    var onDaysSelected: (([String]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        // Заголовок
        let titleLabel = UILabel()
        titleLabel.text = "Расписание"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Контейнер для таблицы
        let containerView = UIView()
        containerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Таблица для дней недели
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .lightGray
        tableView.backgroundColor = .clear
        tableView.rowHeight = 75
        tableView.tableFooterView = UIView()
        containerView.addSubview(tableView)
        
        // Кнопка "Готово"
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = .black
        doneButton.layer.cornerRadius = 16
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        view.addSubview(doneButton)
        
        // Layout
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 525),
            
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            doneButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 24),
            doneButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc func doneButtonTapped() {
        let selectedShortDays = daysOfWeek.enumerated().compactMap { index, day in
            return selectedDays[index] ? getShortName(for: day) : nil
        }
        onDaysSelected?(selectedShortDays)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDelegate и UITableViewDataSource методы
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "dayCell")
        cell.textLabel?.text = daysOfWeek[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        // Добавляем переключатель (UISwitch) к каждой ячейке
        let daySwitch = UISwitch()
        daySwitch.isOn = selectedDays[indexPath.row]
        daySwitch.onTintColor = .systemBlue
        daySwitch.tag = indexPath.row
        daySwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = daySwitch
        
        // Настройка фона ячейки
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        return cell
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        selectedDays[sender.tag] = sender.isOn
    }
    
    // Функция для получения сокращенного названия дня
    func getShortName(for day: String) -> String {
        switch day {
        case "Понедельник":
            return "Пн"
        case "Вторник":
            return "Вт"
        case "Среда":
            return "Ср"
        case "Четверг":
            return "Чт"
        case "Пятница":
            return "Пт"
        case "Суббота":
            return "Сб"
        case "Воскресенье":
            return "Вс"
        default:
            return ""
        }
    }
}
