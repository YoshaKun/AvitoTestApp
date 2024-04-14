//
//  ResultVC.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 05.04.2024.
//

import UIKit

protocol ResultVCProtocol {
    func passTextToSearchBar(text: String)
}

class ResultVC: UIViewController {
    
    // MARK: - Private variables
    
    private var tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
    private var searchHistory: [String] = []
    private var filteredArray: [String] = []
    
    // MARK: - DELEGATE for SearchVC
    var delegate: ResultVCProtocol?
    
    private let serviceModel = SearchService()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView()
        configureConstraints()
    }
    
    // MARK: - Setup Table View
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(ResultCell.self, forCellReuseIdentifier: "resultCell")
        tableView.separatorStyle = .none
    }
    
    // MARK: - Configure Constraints
    
    private func configureConstraints() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    #warning("create func which will lounch reloading tableView and getting wrote text in searchBar")
    private func getDataSource() -> [String]{
        if filteredArray.isEmpty {
            let array = serviceModel.getSearchHistory()
            searchHistory = array
            return array
        } else {
            return filteredArray
        }
    }
    
    // MARK: - Filter method for searchBar in previous requests which saved in UserDefaults
    private func filterSavedRequests(_ words: [String], bySubstring substring: String) -> [String] {
        let lowercaseSubstring = substring.lowercased()
        let filteredWords = words.filter { $0.lowercased().contains(lowercaseSubstring) }
        return filteredWords
    }
}

// MARK: - UITableViewDataSource

extension ResultVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #warning("presenter.getSearchHistory().count")
        return getDataSource().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? ResultCell
        #warning("presenter.getSearchHistory().count")
        cell?.configureCell(text: getDataSource()[indexPath.row])
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension ResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        #warning("pass the text from cell to searchBar")
        let someText = getDataSource()[indexPath.row]
        delegate?.passTextToSearchBar(text: someText)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ResultVC: SearchVCProtocol {
    func passEachLetterToResultVC(string: String) {
        filteredArray = self.filterSavedRequests(self.searchHistory, bySubstring: string)
        self.tableView.reloadData()
    }
}
