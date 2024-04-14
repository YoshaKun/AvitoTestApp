//
//  ViewController.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 04.04.2024.
//

import UIKit

// MARK: - Delegate protocol for ResultVC
protocol SearchVCProtocol {
    func passEachLetterToResultVC(string: String)
}

final class SearchVC: UIViewController {

    // MARK: - Private Constants
    private let searchController = UISearchController(searchResultsController: ResultVC())
    private let presenter: SearchPresenter
    private let emptyDataLabel = UILabel()
    
    // MARK: - Private variables
    private var collectionView: UICollectionView!
    private var filterButton: UIBarButtonItem?
    private var activityIndicator = UIActivityIndicatorView()
    private var activityIndicatorView = UIView()
    private var dataArray = CommonResult(results: [])
    
    // MARK: - Delegate of SearchVC for ResultVC
    var delegate: SearchVCProtocol?
    
    // MARK: - Life cycle of VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupCollectionView()
        configureConstraints()
    }
    
    // MARK: - Initialization

    init(presenter: SearchPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure Views
    private func configureViews() {
        view.backgroundColor = .systemBackground
        emptyDataLabel.text = "Введите имя артиста или название песни в поисковую строку, например: \"Rap god\""
        emptyDataLabel.numberOfLines = 0
        emptyDataLabel.textAlignment = .center
        emptyDataLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        emptyDataLabel.textColor = .systemGray2
        
        // change navigation Bar and back button
        changeBackButton()
        // setup navigationBar
        if let resultVC = searchController.searchResultsController as? ResultVC {
            resultVC.delegate = self
            delegate = resultVC
        }
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        filterButton = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(didTapFilter)
        )
        navigationItem.rightBarButtonItem = filterButton
        navigationItem.title = "Поиск"
        navigationItem.searchController = searchController
        filterButton?.tintColor = UIColor(resource: .accent)
        activityIndicator.style = .large
    }
    
    @objc private func didTapFilter() {
        let vc = FilterVC()
        self.present(vc, animated: true)
    }
    
    // MARK: - Setup CollectionView
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "searchCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
    }
    
    // MARK: - Configure Constraints
    private func configureConstraints() {
        view.addSubview(collectionView)
        view.addSubview(emptyDataLabel)
        
        emptyDataLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            emptyDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyDataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    private func configureActivityIndicatorView() {
        activityIndicator.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.backgroundColor = .systemBackground
        activityIndicatorView.addSubview(activityIndicator)

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()

        NSLayoutConstraint.activate([
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Setup flow layout
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = (view.bounds.width / 2) - 16 - 8
        layout.itemSize = .init(width: screenWidth, height: screenWidth * 1.5)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset.left = 16
        layout.sectionInset.top = 32
        layout.sectionInset.right = 16
        layout.sectionInset.bottom = 16
        return layout
    }
    
    // MARK: - Update collectionView and GET model Data of search Responder
    private func updateCollectionView() {
        var filterdResultsArray: [CommonEntity] = []
        let result = presenter.getModelData().results

        for filmEntity in result {
            if filmEntity.artworkUrl100 != nil && filmEntity.trackName != nil {
                filterdResultsArray.append(filmEntity)
            }
        }
        dataArray = CommonResult(results: filterdResultsArray)
        collectionView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating
extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        delegate?.passEachLetterToResultVC(string: text)
    }
}

// MARK: - UISearchBarDelegate
extension SearchVC: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchController.showsSearchResultsController = true
        return true
    }
    
    // MARK: - SETUP SEARCH REQUEST !!!!!
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.showsSearchResultsController = false
        guard let searchText = searchBar.text else { return }
        let limitValue = UserDefaults.standard.bool(forKey: "showAllResults") ? "200" : nil
        let mediaValue: MediaType? = determinateMediaFilter() ?? nil
        let explicitValue: Bool? = UserDefaults.standard.bool(forKey: "showExplicitContent") ? nil : false
        let langValue: LanguageType = determinateLangFilter()
        
        presenter.createSearchRequest(
            string: searchText,
            limit: limitValue,
            media: mediaValue,
            isExplicit: explicitValue,
            lang: langValue
        )
        searchBar.resignFirstResponder()
    }
    
    // MARK: - determinate media filter
    func determinateMediaFilter() -> MediaType? {
        if UserDefaults.standard.bool(forKey: "sortByMusic") == true {
            return .music
        } else if UserDefaults.standard.bool(forKey: "sortByMovies") == true {
            return .movie
        } else {
            return nil
        }
    }
    
    // MARK: - determinate language filter
    func determinateLangFilter() -> LanguageType {
        if UserDefaults.standard.bool(forKey: "changeResponseLangToEnglish") == true {
            return .english
        } else if UserDefaults.standard.bool(forKey: "changeResponseLangToJapan") == true {
            return .japanese
        } else if UserDefaults.standard.bool(forKey: "changeResponseLangToRussian") == true {
            return .russian
        } else {
            return .english
        }
    }
}

// MARK: - Search pesenter Output
extension SearchVC: SearchPresenterOutput {
    func didSuccessCreateSearchRequest() {
        DispatchQueue.main.async { [weak self] in
            self?.configureActivityIndicatorView()
            self?.updateCollectionView()
        }
    }
    
    func pushToNextVC(model: CommonEntity?) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(DetailInfoBuilder.build(model: model), animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SearchVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard dataArray.results.count != 0 else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.emptyDataLabel.isHidden = false
                self?.view.bringSubviewToFront(self?.emptyDataLabel ?? UIView())
            }
            return dataArray.results.count
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicatorView.removeFromSuperview()
            self?.emptyDataLabel.isHidden = true
        }
        return dataArray.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataModel = dataArray.results[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        cell.configureCell(model: dataModel)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataModel = dataArray.results[indexPath.row]
        presenter.pushToDetailInfo(model: dataModel)
    }
}

extension SearchVC: ResultVCProtocol {
    func passTextToSearchBar(text: String) {
        searchController.searchBar.text = text
    }
}
