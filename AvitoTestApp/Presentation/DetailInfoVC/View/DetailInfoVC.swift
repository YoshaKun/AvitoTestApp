//
//  DetailInfoVC.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 12.04.2024.
//

import UIKit

final class DetailInfoVC: UIViewController {
    
    // MARK: - Private constants
    private let scrollView = UIScrollView()
    private let fonImgView = UIView()
    private let imgView = UIImageView()
    private let stackView = UIStackView()
    private let nameContentLabel = UILabel()
    private let artistLabel = UILabel()
    private let typeContentLabel = UILabel()
    private let mediaLinkButton = UIButton() // Link to media content in iTunes
    private let descriptionLabel = UILabel()
    private let fonDescriptionText = UIView()
    private let textDescriptionLabel = UILabel()
    private let readMoreButton = UIButton()
    private let artistLinkButton = UIButton() // Link to Artist info
    
    // Lookup block about Artist
    private let lookupLabel = UILabel()
    private let lookupTextFon = UIView()
    private let lookupTextLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Private variables
    private var presenter: DetailInfoPresenterInput
    private var model: CommonEntity?
    private var artistLink: String?
    private var flagReadMoreIsTapped: Bool = false
    
    // MARK: - Initialization
    init(
        dataModel: CommonEntity?,
        presenter: DetailInfoPresenterInput
        ) {
        self.model = dataModel
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        updateArtistInfo()
    }
    
    // MARK: - Update Artist Info
    private func updateArtistInfo() {
        presenter.makeLookupRequest(artistId: model?.artistId ?? 0)
        activityIndicator.startAnimating()
    }
    
    // MARK: - Configure Views
    private func configureViews() {
        if model?.longDescription == nil {
            readMoreButton.isHidden = true
        }
        view.backgroundColor = .systemGray5
        
        scrollView.showsHorizontalScrollIndicator = false
        activityIndicator.style = .large
        
        imgView.layer.cornerRadius = 15
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        fonImgView.addGreyShadow()
        
        guard let imgString = model?.artworkUrl100 else {
            return imgView.backgroundColor = .systemYellow
        }
        presenter.getImageForDetailVC(urlStr: imgString)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(nameContentLabel)
        stackView.addArrangedSubview(artistLabel)
        stackView.addArrangedSubview(typeContentLabel)
        stackView.addArrangedSubview(mediaLinkButton)
        
        nameContentLabel.text = model?.trackName
        nameContentLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameContentLabel.numberOfLines = 0
        nameContentLabel.textAlignment = .center
        nameContentLabel.textColor = .black
        
        artistLabel.text = model?.artistName
        artistLabel.font = .systemFont(ofSize: 28, weight: .regular)
        artistLabel.numberOfLines = 2
        artistLabel.textAlignment = .center
        artistLabel.textColor = .systemPink
        
        typeContentLabel.text = model?.kind
        typeContentLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        typeContentLabel.textColor = .systemGray2
        
        mediaLinkButton.setTitle("  Preview", for: .normal)
        mediaLinkButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        mediaLinkButton.addTarget(self, action: #selector(didTapHiperRefButton), for: .touchUpInside)
        mediaLinkButton.setTitleColor(.systemBlue, for: .normal)
        mediaLinkButton.tintColor = .systemBlue
        mediaLinkButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        descriptionLabel.text = "Описание"
        descriptionLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        descriptionLabel.textColor = .black
        
        textDescriptionLabel.text = model?.longDescription ?? "\(model?.artistName ?? "") - \(model?.trackName ?? "")"
        textDescriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        textDescriptionLabel.textColor = .systemGray
        textDescriptionLabel.numberOfLines = 4
        
        fonDescriptionText.backgroundColor = .white
        fonDescriptionText.layer.cornerRadius = 15
        fonDescriptionText.clipsToBounds = true
        
        readMoreButton.setTitle("Показать", for: .normal)
        readMoreButton.setTitleColor(.systemPink, for: .normal)
        readMoreButton.addTarget(self, action: #selector(didTapReadMore(_:)), for: .touchUpInside)
        
        lookupLabel.text = "Информация об артисте"
        lookupLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        lookupLabel.textColor = .black
        
        lookupTextFon.backgroundColor = .white
        lookupTextFon.layer.cornerRadius = 15
        lookupTextFon.clipsToBounds = true
        
        lookupTextLabel.font = .systemFont(ofSize: 16, weight: .regular)
        lookupTextLabel.textColor = .systemGray
        lookupTextLabel.numberOfLines = 0
        
        artistLinkButton.setTitle("Info about artist", for: .normal)
        artistLinkButton.addTarget(self, action: #selector(didTapArtistLink), for: .touchUpInside)
        artistLinkButton.setTitleColor(.systemBlue, for: .normal)
        artistLinkButton.tintColor = .systemBlue
        artistLinkButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        lookupLabel.isHidden = true
        lookupTextFon.isHidden = true
        lookupTextLabel.isHidden = true
        artistLinkButton.isHidden = true
    }
    
    // MARK: - @Objc methods
    @objc func didTapHiperRefButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: model?.trackViewUrl ?? "")!, options: [:], completionHandler: nil)
    }
    
    @objc func didTapArtistLink(_ sender: Any) {
        guard let link = artistLink, artistLink != "" else {
            artistLinkButton.setTitleColor(.systemGray5, for: .normal)
            return
        }
        UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
    }
    
    @objc func didTapReadMore(_ sender: UIButton) {
        
        if flagReadMoreIsTapped == false {
            flagReadMoreIsTapped = true
            UIView.animate(withDuration: 0.4) {
                self.textDescriptionLabel.numberOfLines = 0
                self.view.layoutIfNeeded()
            }
            sender.setTitle("Скрыть", for: .normal)
        } else {
            flagReadMoreIsTapped = false
            UIView.animate(withDuration: 0.4) {
                self.textDescriptionLabel.numberOfLines = 4
                self.view.layoutIfNeeded()
            }
            sender.setTitle("Показать", for: .normal)
        }
    }
    
    // MARK: - Configure Constraints
    private func configureConstraints() {
        let screenWidth = (view.bounds.width / 1.7)
        
        view.addSubview(scrollView)
        scrollView.addSubview(fonImgView)
        fonImgView.addSubview(imgView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(fonDescriptionText)
        fonDescriptionText.addSubview(textDescriptionLabel)
        scrollView.addSubview(readMoreButton)
        scrollView.addSubview(lookupLabel)
        scrollView.addSubview(lookupTextFon)
        lookupTextFon.addSubview(lookupTextLabel)
        lookupTextFon.addSubview(artistLinkButton)
        scrollView.addSubview(activityIndicator)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        fonImgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        fonDescriptionText.translatesAutoresizingMaskIntoConstraints = false
        textDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        readMoreButton.translatesAutoresizingMaskIntoConstraints = false
        lookupLabel.translatesAutoresizingMaskIntoConstraints = false
        lookupTextFon.translatesAutoresizingMaskIntoConstraints = false
        lookupTextLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLinkButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            scrollView.heightAnchor.constraint(equalToConstant: screenWidth * 10),
            
            fonImgView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            fonImgView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            fonImgView.widthAnchor.constraint(equalToConstant: screenWidth),
            fonImgView.heightAnchor.constraint(equalToConstant: screenWidth),
            
            imgView.centerXAnchor.constraint(equalTo: fonImgView.centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: fonImgView.centerYAnchor),
            imgView.widthAnchor.constraint(equalToConstant: screenWidth),
            imgView.heightAnchor.constraint(equalToConstant: screenWidth),
            
            stackView.topAnchor.constraint(equalTo: fonImgView.bottomAnchor, constant: 32),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: (screenWidth * 0.75)),
            stackView.widthAnchor.constraint(equalToConstant: view.bounds.width - 64),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            fonDescriptionText.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            fonDescriptionText.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            fonDescriptionText.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            fonDescriptionText.widthAnchor.constraint(equalToConstant: view.bounds.width - 32),
            
            textDescriptionLabel.leadingAnchor.constraint(equalTo: fonDescriptionText.leadingAnchor, constant: 16),
            textDescriptionLabel.topAnchor.constraint(equalTo: fonDescriptionText.topAnchor, constant: 16),
            textDescriptionLabel.trailingAnchor.constraint(equalTo: fonDescriptionText.trailingAnchor, constant: -16),
            textDescriptionLabel.bottomAnchor.constraint(equalTo: fonDescriptionText.bottomAnchor, constant: -16),
            
            readMoreButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            readMoreButton.topAnchor.constraint(equalTo: fonDescriptionText.bottomAnchor, constant: 4),
            readMoreButton.widthAnchor.constraint(equalToConstant: 130),
            
            lookupLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            lookupLabel.topAnchor.constraint(equalTo: readMoreButton.bottomAnchor, constant: 16),
            lookupLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            lookupTextFon.topAnchor.constraint(equalTo: lookupLabel.bottomAnchor, constant: 16),
            lookupTextFon.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            lookupTextFon.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            lookupTextFon.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            lookupTextFon.widthAnchor.constraint(equalToConstant: view.bounds.width - 32),
            
            lookupTextLabel.leadingAnchor.constraint(equalTo: lookupTextFon.leadingAnchor, constant: 16),
            lookupTextLabel.topAnchor.constraint(equalTo: lookupTextFon.topAnchor, constant: 16),
            lookupTextLabel.trailingAnchor.constraint(equalTo: lookupTextFon.trailingAnchor, constant: -16),
            
            artistLinkButton.leadingAnchor.constraint(equalTo: lookupTextFon.leadingAnchor, constant: 16),
            artistLinkButton.topAnchor.constraint(equalTo: lookupTextLabel.bottomAnchor, constant: 4),
            artistLinkButton.bottomAnchor.constraint(equalTo: lookupTextFon.bottomAnchor, constant: -4),
            
            activityIndicator.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: readMoreButton.bottomAnchor, constant: 8)
        ])
    }
}

// MARK: - DetailInfoPresenterOutput implementation
extension DetailInfoVC: DetailInfoPresenterOutput {
    func didSuccessGettingArtistInfo(data: LookupRequest) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            let lookupModel = data.results.first
            guard lookupModel?.artistLinkUrl != nil, lookupModel?.primaryGenreName != nil else {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
                return
            }
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.removeFromSuperview()
            self?.lookupLabel.isHidden = false
            self?.lookupTextFon.isHidden = false
            self?.lookupTextLabel.isHidden = false
            self?.artistLinkButton.isHidden = false
            self?.artistLink = lookupModel?.artistLinkUrl ?? ""
            self?.lookupTextLabel.text = """
            Имя: \(lookupModel?.artistName ?? "")
            ID автора: \(self?.model?.artistId ?? 00)
            Основной жанр: \(lookupModel?.primaryGenreName ?? "Not found")
            """
        }
    }
    
    func didFailureGettingArtistInfo() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.removeFromSuperview()
        }
    }
    
    func didSuccessGettingImage(data: Data) {
        DispatchQueue.main.async { [weak self] in
            self?.imgView.image = UIImage(data: data)
        }
    }
}
