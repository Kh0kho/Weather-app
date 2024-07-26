//
//  CarouselCell.swift
//  Final - Weather app
//
//  Created by Luka Khokhiashvili on 17.07.24.
//

import UIKit
import Kingfisher

class CarouselCell: UICollectionViewCell {
    private let mainView = UIView()
    private var urlcomponent: URLComponents!
    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()    
    private let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let icon: UIImageView = {
        let img = UIImageView()
//        img.contentMode = .scaleAspectFit
        return img
    }()
    
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AccentColor")
        label.font = .systemFont(ofSize: 26)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let cityName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let gradientLayer = CAGradientLayer()

    private let cloudiness: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor(named: "AccentColor")
        label.textAlignment = .right
        return label
    }()
    private let humidity: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor(named: "AccentColor")
        label.textAlignment = .right
        return label
    }()
    private let windSpeed: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor(named: "AccentColor")
        label.textAlignment = .right
        return label
    }()
    private let windDirection: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor(named: "AccentColor")
        label.textAlignment = .right
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupMainView()
        setupTopStack()
        setupBottomStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = mainView.bounds
    }
    
    private func setupBackground() {
        guard let startColor = UIColor(named: "blue-gradient-start")?.cgColor,
              let endColor = UIColor(named: "blue-gradient-end")?.cgColor else {
            return
        }
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.cornerRadius = 30
        mainView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupMainView() {
        setupBackground()
//        mainView.backgroundColor = .systemCyan
        addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1)
        ])
    }
    
    private func setupTopStack() {
        mainView.addSubview(topStack)
        topStack.addArrangedSubview(icon)
        topStack.addArrangedSubview(cityName)
        topStack.addArrangedSubview(tempLabel)
        icon.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalToConstant: 150)
        ])
        NSLayoutConstraint.activate([
            topStack.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            topStack.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 50)
        ])
    } 
    
    private func setupBottomStack() {
        mainView.addSubview(bottomStack)
        bottomStack.addArrangedSubview(
            ReusableStack(
                icon: "raining",
                description: "Cloudiness",
                value: cloudiness))
        bottomStack.addArrangedSubview(
            ReusableStack(
                icon: "drop",
                description: "Humidity",
                value: humidity))
        bottomStack.addArrangedSubview(
            ReusableStack(
                icon: "wind",
                description: "Wind Speed",
                value: windSpeed))
        bottomStack.addArrangedSubview(
            ReusableStack(
                icon: "compass",
                description: "Wind Direction",
                value: windDirection))
        
        NSLayoutConstraint.activate([
            bottomStack.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 30),
            bottomStack.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -30),
            bottomStack.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -80)
        ])
    }
    
    func configure(with weatherData: WeatherData) {
        icon.kf.setImage(with: URL(string: weatherData.iconURL))
        tempLabel.text = "\(Int(weatherData.temperature))°C | \(weatherData.main)"
        cityName.text = "\(String(weatherData.cityName!)), \(String(weatherData.countryName!))"
        cloudiness.text = "\(weatherData.cloudiness) %"
        humidity.text = "\(weatherData.humidity) mm"
        windSpeed.text = "\(weatherData.windSpeed) km/h"
        windDirection.text = weatherData.windDirection
    }
    
   
    
}

class ReusableStack: UIStackView {
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(icon: String, description: String, value: UILabel) {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.distribution = .fill
        self.spacing = 8
        self.translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.image = UIImage(named: icon)
        descriptionLabel.text = description
        
        addArrangedSubview(iconImageView)
        addArrangedSubview(descriptionLabel)
        addArrangedSubview(value)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

