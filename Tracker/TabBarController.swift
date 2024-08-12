//
//  ViewController.swift
//  Trecker
//
//  Created by LERÄ on 31.07.24.
//

import UIKit

class TabBarController: UIViewController {
    
    private var searchBar = UISearchBar()
    private var label = UILabel()
    private var iconImage = UIImage()
    private var tabBar = UITabBar()
    private var plusButton = UIButton()
    private var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchBar()
        setupIcon()
        setupLabel()
        setupTabBar()
        setupPlusButton()
        setupDatePicker()
    }
    
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.title = "Трекеры"
    }
    
    @objc func addTapped() {
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
            searchBar.widthAnchor.constraint(equalToConstant: 343),
            searchBar.topAnchor.constraint(equalTo: searchBar.safeAreaLayoutGuide.topAnchor, constant: 92),
            searchBar.bottomAnchor.constraint(equalTo: searchBar.safeAreaLayoutGuide.bottomAnchor, constant: 556),
            searchBar.leadingAnchor.constraint(equalTo: searchBar.safeAreaLayoutGuide.leadingAnchor, constant: -16)
        ])
    }
    
    func setupIcon() {
        let iconImage = UIImageView(image: UIImage(systemName: "mainIcon"))
        iconImage.contentMode = .scaleAspectFill
        iconImage.tintColor = .gray
        self.view.addSubview(iconImage)
        
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImage.heightAnchor.constraint(equalToConstant: 80),
            iconImage.widthAnchor.constraint(equalToConstant: 80),
            iconImage.bottomAnchor.constraint(equalTo: iconImage.safeAreaLayoutGuide.bottomAnchor, constant: 246),
            iconImage.trailingAnchor.constraint(equalTo: iconImage.safeAreaLayoutGuide.trailingAnchor, constant: 148)
        ])
        
    }
    
    func setupLabel() {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont(name: "SFPro", size: 34)
        label.textAlignment = .left
        label.textColor = .black
        view.addSubview(label)
        self.label = label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 41),
            label.widthAnchor.constraint(equalToConstant: 254),
            label.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: 7),
            label.trailingAnchor.constraint(equalTo: label.safeAreaLayoutGuide.trailingAnchor, constant: 105),
            label.leadingAnchor.constraint(equalTo: label.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
    }
    
    func setupTabBar() {
        let tabBar = UITabBar()
        let trackerItem = UITabBarItem(title: "Трекеры", image: UIImage(systemName: "Trackers"), tag: 0)
        let statisticItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "stats"), tag: 0)
        tabBar.items = [trackerItem, statisticItem]
        view.addSubview(tabBar)
        self.tabBar = tabBar
        
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
//    func setupPlusButton() {
//        guard let plusButtonImage = UIImage(named: "icadd_tracker") else {
//            return
//        }
//        let plusButton = UIButton.systemButton(with: plusButtonImage, target: self, action: #selector(plusButtonAction))
//        plusButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(plusButton)  // Добавление кнопки в иерархию view
//        
//        NSLayoutConstraint.activate([
//            plusButton.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: 49),  // Расстояние от searchBar
//            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),   // Отступ слева
//            plusButton.widthAnchor.constraint(equalToConstant: 42),  // Ширина кнопки
//            plusButton.heightAnchor.constraint(equalToConstant: 42)   // Высота кнопки
//        ])
//    }
    
    
    //    func setupDatePicker() {
    //        let datePicker = UIDatePicker()
    //        datePicker.datePickerMode = .date  // Режим выбора только даты
    //        datePicker.translatesAutoresizingMaskIntoConstraints = false
    //        view.addSubview(datePicker)  // Добавление datePicker в иерархию view
    //
    //        NSLayoutConstraint.activate([
    //            datePicker.heightAnchor.constraint(equalToConstant: 34),
    //            datePicker.widthAnchor.constraint(equalToConstant: 77),
    //            datePicker.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 49),
    //            datePicker.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor, constant: 234),
    //            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16)
    //        ])
    //    }
    
    func setupPlusButton() {
        guard let plusButtonImage = UIImage(named: "icadd_tracker") else {
            return
        }
        let plusButton = UIButton.systemButton(with: plusButtonImage, target: self, action: #selector(plusButtonAction))
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plusButton)  // Добавление кнопки в иерархию view
        self.plusButton = plusButton

        NSLayoutConstraint.activate([
            plusButton.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),  // Изменено для упрощения позиционирования
            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker) 
        self.datePicker = datePicker// Убедитесь, что datePicker добавлен в ту же view

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 16), // Исправленный констрейнт
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc func plusButtonAction() {
        // Тут будет логика нажатия на кнопку +
        print("Нажата кнопка +")
    }
    
    }
