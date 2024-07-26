//
//  ForecastCell.swift
//  Final - Weather app
//
//  Created by Luka Khokhiashvili on 18.07.24.
//

import UIKit
import Kingfisher

class ForecastCell: UITableViewCell {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor(named: "AccentColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    func configure(icon: String, time: String, desctipton: String, temp: Int) {
        // Set icon if needed
        iconImageView.kf.setImage(with: URL(string: "https://openweathermap.org/img/wn/\(icon).png"))
        timeLabel.text = time
        descriptionLabel.text = desctipton
        tempLabel.text = "\(temp)°"
        
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .clear
        addSubview(iconImageView)
        addSubview(stack)
        stack.addArrangedSubview(timeLabel)
        stack.addArrangedSubview(descriptionLabel)
        addSubview(tempLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            stack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            tempLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

