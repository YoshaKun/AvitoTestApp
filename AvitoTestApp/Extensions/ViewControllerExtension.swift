//
//  ViewControllerExtension.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 12.04.2024.
//

import UIKit

// MARK: - UIViewController
extension UIViewController {
    public func changeBackButton() {
        // Adjustment BackButton and NavigationBar
        let yourBackImage = UIImage(systemName: "arrow.backward")
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.backIndicatorImage = yourBackImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        navigationController?.navigationBar.tintColor = UIColor(resource: .accent)
        navigationItem.title = ""
    }
}

// MARK: - UIView
extension UIView {
    func addGreyShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.31).cgColor
        layer.shadowOpacity = 2
        layer.shadowOffset = CGSize(width: 2, height: 6)
        layer.shadowRadius = 12
    }
}
