//
//  AdressSheetViewController.swift
//  marticase
//
//  Created by safa uslu on 15.05.2024.
//

import UIKit
import MapKit

class AdressSheetViewController: UIViewController {
    var address: String?
    let padding: Double = 24
    let contentPadding: Double = 12
    
    private var titleLabel:UILabel!
    
    private var addressLabel: UILabel!
    
    private var annotationView: UIImageView!
    
    private var buttonView: UIView = {
        let holder = UIView()
        holder.backgroundColor = AppColors.buttonColor
        holder.layer.cornerRadius = 8
        holder.translatesAutoresizingMaskIntoConstraints = false
        holder.heightAnchor.constraint(equalToConstant: 40).isActive = true
        let buttonLabel = UILabel()
        buttonLabel.text = "Tamam"
        buttonLabel.font = .boldSystemFont(ofSize: 20)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.centerToView(of: holder)
        return holder
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setUI()
    }
    
    private func setUI() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Seçilen Adres:"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: padding / 2),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        annotationView = UIImageView(image: UIImage(systemName: "signpost.right.and.left.fill"))
        annotationView.tintColor = .systemGreen
        annotationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(annotationView)
        NSLayoutConstraint.activate([
            annotationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            annotationView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: contentPadding),
        ])
        
        addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressLabel)
        addressLabel.text = address
        addressLabel.font = .boldSystemFont(ofSize: 18)
        addressLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: annotationView.trailingAnchor, constant: contentPadding),
            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: contentPadding),
            addressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
        
        view.addSubview(buttonView)
        buttonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapButton)))
        NSLayoutConstraint.activate([
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding)
        ])
    }
    
    @objc func didTapButton() {
        self.dismiss(animated: true)
    }
}
