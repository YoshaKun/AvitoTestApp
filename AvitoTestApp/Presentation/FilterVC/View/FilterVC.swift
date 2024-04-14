//
//  ViewController.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 06.04.2024.
//

import UIKit

class FilterVC: UIViewController {

    // MARK: - Private constants
    private let filterLabel = UILabel()
    private let entityLabel = UILabel()
    private let expliсitLabel = UILabel()
    private let languageLabel = UILabel()
    private let showAllResultsLabel = UILabel()
    // close button
    private let closeButton = UIButton()
    
    // Entities buttons
    private let ebookButton = UIButton()
    private let musicButton = UIButton()
    private let movieButton = UIButton()
    private let allEntitiesButton = UIButton()
    // Explicit content switcher (default need be ON state)
    private let explicitSwitcher = UISwitch()
    // Language buttons
    private let englishLangButton = UIButton()
    private let japanLangButton = UIButton()
    private let russianLangButton = UIButton()
    // Show all results switcher
    private let showAllResultsSwitcher = UISwitch()
    // Save button
    private let saveButton = UIButton()
    
    // stackViews
    private let entitiesStack = UIStackView()
    private let languageStack = UIStackView()
    
    // MARK: - Private sort params
    var sortByMusic = false
    var sortByMovies = false
    var sortAllEntities = true
    var showExplicitContent = true
    var changeResponseLangToEnglish = true
    var changeResponseLangToJapan = false
    var changeResponseLangToRussian = false
    var showAllResults = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupStackViews()
        setupConstraints()
        setupFiltersState()
    }
    
    // MARK: - setupViews
    private func setupViews() {
        view.backgroundColor = .white
        
        filterLabel.text = "Фильтр"
        filterLabel.font = .systemFont(ofSize: 24, weight: .bold)
        filterLabel.tintColor = .black
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        
        entityLabel.text = "Тип контента"
        entityLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        entityLabel.tintColor = .black
        
        ebookButton.backgroundColor = .systemGray5
        ebookButton.layer.cornerRadius = 10
        ebookButton.clipsToBounds = true
        ebookButton.setTitleColor(.black, for: .normal)
        ebookButton.setTitle("Эл. книги", for: .normal)
        ebookButton.addTarget(self, action: #selector(didTapEntities(_:)), for: .touchUpInside)
        ebookButton.tag = 0
        
        musicButton.backgroundColor = .systemGray5
        musicButton.layer.cornerRadius = 10
        musicButton.clipsToBounds = true
        musicButton.setTitleColor(.black, for: .normal)
        musicButton.setTitle("Музыка", for: .normal)
        musicButton.addTarget(self, action: #selector(didTapEntities(_:)), for: .touchUpInside)
        musicButton.tag = 1
        
        movieButton.backgroundColor = .systemGray5
        movieButton.layer.cornerRadius = 10
        movieButton.clipsToBounds = true
        movieButton.setTitleColor(.black, for: .normal)
        movieButton.setTitle("Фильмы", for: .normal)
        movieButton.addTarget(self, action: #selector(didTapEntities(_:)), for: .touchUpInside)
        movieButton.tag = 2
        
        allEntitiesButton.backgroundColor = .systemGray5
        allEntitiesButton.layer.cornerRadius = 10
        allEntitiesButton.clipsToBounds = true
        allEntitiesButton.setTitleColor(.black, for: .normal)
        allEntitiesButton.setTitle("Всё", for: .normal)
        allEntitiesButton.addTarget(self, action: #selector(didTapEntities(_:)), for: .touchUpInside)
        allEntitiesButton.tag = 3
        
        expliсitLabel.text = "Без цензуры"
        expliсitLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        expliсitLabel.tintColor = .black
        
        explicitSwitcher.addTarget(self, action: #selector(didSwitchExplicit), for: .valueChanged)
        explicitSwitcher.onTintColor = UIColor(resource: .accent)
        
        languageLabel.text = "Язык"
        languageLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        languageLabel.tintColor = .black
        
        englishLangButton.backgroundColor = .systemGray5
        englishLangButton.layer.cornerRadius = 10
        englishLangButton.clipsToBounds = true
        englishLangButton.setTitleColor(.black, for: .normal)
        englishLangButton.setTitle("Английский", for: .normal)
        englishLangButton.addTarget(self, action: #selector(didTapLang(_:)), for: .touchUpInside)
        englishLangButton.tag = 4
        
        japanLangButton.backgroundColor = .systemGray5
        japanLangButton.layer.cornerRadius = 10
        japanLangButton.clipsToBounds = true
        japanLangButton.setTitleColor(.black, for: .normal)
        japanLangButton.setTitle("Японский", for: .normal)
        japanLangButton.addTarget(self, action: #selector(didTapLang(_:)), for: .touchUpInside)
        japanLangButton.tag = 5
        
        russianLangButton.backgroundColor = .systemGray5
        russianLangButton.layer.cornerRadius = 10
        russianLangButton.clipsToBounds = true
        russianLangButton.setTitleColor(.black, for: .normal)
        russianLangButton.setTitle("Русский", for: .normal)
        russianLangButton.addTarget(self, action: #selector(didTapLang(_:)), for: .touchUpInside)
        russianLangButton.tag = 6
        
        showAllResultsLabel.text = "Показать всё"
        showAllResultsLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        showAllResultsLabel.tintColor = .black
        
        showAllResultsSwitcher.addTarget(self, action: #selector(didSwitchAllResults), for: .valueChanged)
        showAllResultsSwitcher.onTintColor = UIColor(resource: .accent)
        
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = UIColor(resource: .accent)
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
    }
    
    // MARK: - Detecting what the filter is On
    func setupFiltersState() {
        sortByMusic = UserDefaults.standard.bool(forKey: "sortByMusic")
        sortByMovies = UserDefaults.standard.bool(forKey: "sortByMovies")
        showExplicitContent = UserDefaults.standard.bool(forKey: "showExplicitContent")
        changeResponseLangToEnglish = UserDefaults.standard.bool(forKey: "changeResponseLangToEnglish")
        changeResponseLangToJapan = UserDefaults.standard.bool(forKey: "changeResponseLangToJapan")
        changeResponseLangToRussian = UserDefaults.standard.bool(forKey: "changeResponseLangToRussian")
        showAllResults = UserDefaults.standard.bool(forKey: "showAllResults")
        
        if sortByMusic == true {
            didTapEntities(musicButton)
        }
        if sortByMovies == true {
            didTapEntities(movieButton)
        }
        if sortAllEntities == true {
            didTapEntities(allEntitiesButton)
        }
        if changeResponseLangToEnglish == true {
            didTapLang(englishLangButton)
        }
        if changeResponseLangToJapan == true {
            didTapLang(japanLangButton)
        }
        if changeResponseLangToRussian == true {
            didTapLang(russianLangButton)
        }
        showAllResultsSwitcher.setOn(showAllResults, animated: true)
        explicitSwitcher.setOn(showExplicitContent, animated: true)
    }
    
    // MARK: - @objc methods
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc private func didTapEntities(_ sender: UIButton) {
        setupEntitiesButtons(
            sender: sender,
            firstBtn: musicButton,
            secondBtn: movieButton,
            thirdBtn: allEntitiesButton,
            firstFlag: sortByMusic,
            secondFlag: sortByMovies,
            thirdFlag: sortAllEntities
        )
    }
    
    @objc private func didTapLang(_ sender: UIButton) {
        setupLanguageButtons(
            sender: sender,
            firstBtn: englishLangButton,
            secondBtn: japanLangButton,
            thirdBtn: russianLangButton,
            firstFlag: changeResponseLangToEnglish,
            secondFlag: changeResponseLangToJapan, 
            thirdFlag: changeResponseLangToRussian
        )
    }
    
    @objc private func didSwitchExplicit() {
        showExplicitContent = !showExplicitContent
        explicitSwitcher.setOn(showExplicitContent, animated: true)
    }
    
    @objc private func didSwitchAllResults() {
        showAllResults = !showAllResults
        showAllResultsSwitcher.setOn(showAllResults, animated: true)
    }
    
    @objc private func didTapSave() {
        UserDefaults.standard.setValue(sortByMusic, forKey: "sortByMusic")
        UserDefaults.standard.setValue(sortByMovies, forKey: "sortByMovies")
        UserDefaults.standard.setValue(showExplicitContent, forKey: "showExplicitContent")
        UserDefaults.standard.setValue(changeResponseLangToEnglish, forKey: "changeResponseLangToEnglish")
        UserDefaults.standard.setValue(changeResponseLangToJapan, forKey: "changeResponseLangToJapan")
        UserDefaults.standard.setValue(changeResponseLangToRussian, forKey: "changeResponseLangToRussian")
        UserDefaults.standard.setValue(showAllResults, forKey: "showAllResults")
        dismiss(animated: true)
    }
    
    // MARK: - setup stack Views
    private func setupStackViews() {
        entitiesStack.axis = .horizontal
        entitiesStack.distribution = .fillEqually
        entitiesStack.spacing = 10
        
        languageStack.axis = .horizontal
        languageStack.distribution = .fillEqually
        languageStack.spacing = 10
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        view.addSubview(filterLabel)
        view.addSubview(closeButton)
        view.addSubview(entityLabel)
        view.addSubview(entitiesStack)
        entitiesStack.addArrangedSubview(musicButton)
        entitiesStack.addArrangedSubview(movieButton)
        entitiesStack.addArrangedSubview(allEntitiesButton)
        view.addSubview(expliсitLabel)
        view.addSubview(explicitSwitcher)
        view.addSubview(languageLabel)
        view.addSubview(languageStack)
        languageStack.addArrangedSubview(englishLangButton)
        languageStack.addArrangedSubview(japanLangButton)
        languageStack.addArrangedSubview(russianLangButton)
        view.addSubview(showAllResultsLabel)
        view.addSubview(showAllResultsSwitcher)
        view.addSubview(saveButton)
        
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        entityLabel.translatesAutoresizingMaskIntoConstraints = false
        entitiesStack.translatesAutoresizingMaskIntoConstraints = false
        musicButton.translatesAutoresizingMaskIntoConstraints = false
        movieButton.translatesAutoresizingMaskIntoConstraints = false
        allEntitiesButton.translatesAutoresizingMaskIntoConstraints = false
        expliсitLabel.translatesAutoresizingMaskIntoConstraints = false
        explicitSwitcher.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        languageStack.translatesAutoresizingMaskIntoConstraints = false
        englishLangButton.translatesAutoresizingMaskIntoConstraints = false
        japanLangButton.translatesAutoresizingMaskIntoConstraints = false
        russianLangButton.translatesAutoresizingMaskIntoConstraints = false
        showAllResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        showAllResultsSwitcher.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            filterLabel.widthAnchor.constraint(equalToConstant: 120),
            
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.centerYAnchor.constraint(equalTo: filterLabel.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            
            entityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            entityLabel.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: 48),
            
            entitiesStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            entitiesStack.topAnchor.constraint(equalTo: entityLabel.bottomAnchor, constant: 16),
            entitiesStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            expliсitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            expliсitLabel.topAnchor.constraint(equalTo: entitiesStack.bottomAnchor, constant: 48),
            expliсitLabel.trailingAnchor.constraint(equalTo: explicitSwitcher.leadingAnchor, constant: -16),
            
            explicitSwitcher.centerYAnchor.constraint(equalTo: expliсitLabel.centerYAnchor),
            explicitSwitcher.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            languageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            languageLabel.topAnchor.constraint(equalTo: expliсitLabel.bottomAnchor, constant: 48),
            
            languageStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            languageStack.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 16),
            languageStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            showAllResultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            showAllResultsLabel.topAnchor.constraint(equalTo: languageStack.bottomAnchor, constant: 48),
            showAllResultsLabel.trailingAnchor.constraint(equalTo: showAllResultsSwitcher.leadingAnchor, constant: 16),
            
            showAllResultsSwitcher.centerYAnchor.constraint(equalTo: showAllResultsLabel.centerYAnchor),
            showAllResultsSwitcher.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Entities buttons setup method
    private func setupEntitiesButtons(
        sender: UIButton,
        firstBtn: UIButton,
        secondBtn: UIButton,
        thirdBtn: UIButton,
        firstFlag: Bool,
        secondFlag: Bool,
        thirdFlag: Bool
    ) {
        // set all buttons at inactive state
        firstBtn.setTitleColor(.black, for: .normal)
        secondBtn.setTitleColor(.black, for: .normal)
        thirdBtn.setTitleColor(.black, for: .normal)
        firstBtn.backgroundColor = .systemGray5
        secondBtn.backgroundColor = .systemGray5
        thirdBtn.backgroundColor = .systemGray5
        
        // set active button
        if sender == firstBtn {
            if firstFlag == sortByMusic {
                setupChoosingSortButton(sender: sender)
                sortByMusic = true
                sortByMovies = false
                sortAllEntities = false
            }
        }
        if sender == secondBtn {
            if secondFlag == sortByMovies {
                setupChoosingSortButton(sender: sender)
                sortByMusic = false
                sortByMovies = true
                sortAllEntities = false
            }
        }
        if sender == thirdBtn {
            if thirdFlag == sortAllEntities {
                setupChoosingSortButton(sender: sender)
                sortByMovies = false
                sortByMusic = false
                sortAllEntities = true
            }
        }
    }
    
    // MARK: - Language buttons setup method
    private func setupLanguageButtons(
        sender: UIButton,
        firstBtn: UIButton,
        secondBtn: UIButton,
        thirdBtn: UIButton,
        firstFlag: Bool,
        secondFlag: Bool,
        thirdFlag: Bool
    ) {
        // set all buttons at inactive state
        firstBtn.setTitleColor(.black, for: .normal)
        secondBtn.setTitleColor(.black, for: .normal)
        thirdBtn.setTitleColor(.black, for: .normal)
        firstBtn.backgroundColor = .systemGray5
        secondBtn.backgroundColor = .systemGray5
        thirdBtn.backgroundColor = .systemGray5
        
        // set active button
        if sender == firstBtn {
            if firstFlag == changeResponseLangToEnglish {
                setupChoosingSortButton(sender: sender)
                changeResponseLangToEnglish = true
                changeResponseLangToJapan = false
                changeResponseLangToRussian = false
            }
        }
        if sender == secondBtn {
            if secondFlag == changeResponseLangToJapan {
                setupChoosingSortButton(sender: sender)
                changeResponseLangToEnglish = false
                changeResponseLangToJapan = true
                changeResponseLangToRussian = false
            }
        }
        if sender == thirdBtn {
            if thirdFlag == changeResponseLangToRussian {
                setupChoosingSortButton(sender: sender)
                changeResponseLangToEnglish = false
                changeResponseLangToJapan = false
                changeResponseLangToRussian = true
            }
        }
    }
    
    private func setupChoosingSortButton(sender: UIButton) {
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = UIColor(resource: .accent)
    }

}
