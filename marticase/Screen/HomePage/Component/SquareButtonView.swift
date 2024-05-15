//
//  SquareButtonView.swift
//  marticase
//
//  Created by safa uslu on 15.05.2024.
//

import UIKit

class SquareButtonView: UIView {
    var didTap: VoidHandler?
    private lazy var centerMeButtonIcon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(buttonWH: Double = 50,
                       imagePath: String,
                       tintColor: UIColor = .systemBlue) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        backgroundColor = AppColors.squareButtonColor
        layer.shadowColor = AppColors.shadowColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: buttonWH),
            self.widthAnchor.constraint(equalToConstant: buttonWH),
        ])
        
        centerMeButtonIcon.centerToView(of: self)
        centerMeButtonIcon.image = UIImage(systemName: imagePath)
        centerMeButtonIcon.tintColor = tintColor

    }
    
    @objc private func buttonTapped() {
        didTap?()
    }
}
