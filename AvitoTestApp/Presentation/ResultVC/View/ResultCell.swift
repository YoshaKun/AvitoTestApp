//
//  ResultCell.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 06.04.2024.
//

import UIKit

class ResultCell: UITableViewCell {
    
    // MARK: - Private constants
    private let imgView = UIImageView()
    let label = UILabel()
    private let stackView = UIStackView()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        contentView.backgroundColor = .clear
        
        imgView.image = UIImage(systemName: "clock.arrow.circlepath")
        imgView.tintColor = .black
        imgView.contentMode = .scaleAspectFit
        
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fill
    }
    
    private func setupConstraints() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imgView)
        stackView.addArrangedSubview(label)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            stackView.heightAnchor.constraint(equalToConstant: 45),
            
            imgView.heightAnchor.constraint(equalToConstant: 24),
            imgView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Configure Cell
    func configureCell(text: String) {
        label.text = text
    }
}
