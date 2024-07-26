//
//  CityErrorView.swift
//  Final - Weather app
//
//  Created by Luka Khokhiashvili on 21.07.24.
//

import UIKit

class CityErrorView: UIView {
    private let errorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Error Occurred"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "City with that name was not found!"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupErrorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupErrorView() {
        self.backgroundColor = .red
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.alpha = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stack)
        stack.addArrangedSubview(errorTitleLabel)
        stack.addArrangedSubview(errorMessageLabel)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
}
