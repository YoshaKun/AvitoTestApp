//
//  SearchCollectionViewCell.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 05.04.2024.
//

import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    private let presenter: SearchCellPresenterInput = SearchCellPresenter()
    private let imgView = UIImageView()
    private let trckName = UILabel()
    private let typeOfMedia = UILabel()
    private let artstName = UILabel()
    private var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Private params
    private var viewWidth: CGFloat = 100
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigureViews
    private func configureViews() {
        viewWidth = contentView.bounds.size.width
        
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 15
        imgView.clipsToBounds = true
        imgView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        trckName.font = .systemFont(ofSize: 16, weight: .semibold)
        trckName.numberOfLines = 1
        trckName.textColor = .black
        
        typeOfMedia.font = .systemFont(ofSize: 14, weight: .regular)
        typeOfMedia.numberOfLines = 1
        typeOfMedia.textColor = .black
        
        artstName.font = .systemFont(ofSize: 14, weight: .regular)
        artstName.numberOfLines = 1
        artstName.textColor = UIColor(resource: .accent)
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        contentView.addSubview(imgView)
        contentView.addSubview(trckName)
        contentView.addSubview(typeOfMedia)
        contentView.addSubview(artstName)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        trckName.translatesAutoresizingMaskIntoConstraints = false
        typeOfMedia.translatesAutoresizingMaskIntoConstraints = false
        artstName.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            
            trckName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trckName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trckName.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 6),
            
            typeOfMedia.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            typeOfMedia.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            typeOfMedia.topAnchor.constraint(equalTo: trckName.bottomAnchor, constant: 6),
            
            artstName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artstName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artstName.topAnchor.constraint(equalTo: typeOfMedia.bottomAnchor, constant: 6),
        ])
    }
    
    // MARK: - Configure Cell
    func configureCell(model: CommonEntity) {
        guard let image = model.artworkUrl100 else { return }
        presenter.getImageForSearchCell(urlStr: image) { data in
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
                self?.imgView.image = UIImage(data: data)
            }
        }
        trckName.text = model.trackName ?? "Not found :("
        typeOfMedia.text = model.kind
        artstName.text = model.artistName
    }
}
