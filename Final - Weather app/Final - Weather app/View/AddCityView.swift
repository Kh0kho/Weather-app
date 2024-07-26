//
//  AddCityView.swift
//  Final - Weather app
//
//  Created by Luka Khokhiashvili on 20.07.24.
//

import UIKit

class AddCityView: UIView {
    private var delegate: TodayViewController?
    
    // UI Elements
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let promptLabel = UILabel()
    private let textField = UITextField()
    private let addButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
//    private let plusImg = UIImage(systemName: "plus")
    private let errorView = CityErrorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(delegate: TodayViewController){
        self.delegate = delegate
    }
    private func setupView() {
        
        // Blurred Background
        visualEffectView.frame = self.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(visualEffectView)
        
        // Container View
        containerView.backgroundColor = .systemGreen
        containerView.layer.cornerRadius = 30
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        // Title Label
        titleLabel.text = "Add City"
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Prompt Label
        promptLabel.text = "Enter City Name"
        promptLabel.font = .systemFont(ofSize: 16)
        promptLabel.textAlignment = .center
        promptLabel.textColor = .white
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(promptLabel)
        
        // Text Field
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textField)
        
        // Add Button
        if let plusImg = UIImage(systemName: "plus") {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
            let largePlusImg = plusImg.withConfiguration(largeConfig)
            let tintedPlusImg = largePlusImg.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
            addButton.setImage(tintedPlusImg, for: .normal)
        }
        addButton.layer.cornerRadius = 25
        addButton.layer.masksToBounds = true
        addButton.backgroundColor = .white
        addButton.setTitleColor(.white, for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(addButton)
        
        // Activity Indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        
        // Error view
        addSubview(errorView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            // Container View Constraints
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Prompt Label Constraints
            promptLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            promptLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            promptLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Text Field Constraints
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6),
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            // Add Button Constraints
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -26),
            
            // Activity Indicator Constraints
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -26),
            
            // Error View
//            errorView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
//            errorView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1),
            
//            errorView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -300),
//            errorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
//            errorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
//            errorView.heightAnchor.constraint(equalToConstant: 80),
            
            errorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            errorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            errorView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -100),
            errorView.heightAnchor.constraint(equalToConstant: 70),
        ])
        
    }
    
    private func setupActions() {
        // Add Tap Gesture Recognizer to Dismiss View
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        visualEffectView.addGestureRecognizer(tapGesture)
        
        // Configure Add Button Action
        addButton.addTarget(self, action: #selector(addCity), for: .touchUpInside)
    }
    
    @objc private func addCity() {
        guard let city = textField.text, !city.isEmpty else {
//            self.showErrorView() // Show error if the city name is empty
            return
        }
        
        // Hide the Add button and start the activity indicator
        addButton.isHidden = true
        activityIndicator.startAnimating()
        
        delegate?.fetchWeatherData(for: city) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.addButton.isHidden = false
                self.activityIndicator.stopAnimating()
            }
            
            switch result {
            case .success(let weatherData):
                self.delegate?.weatherDataArray.append(weatherData)
                self.delegate?.createCity(name: city)
                DispatchQueue.main.async {
                    self.delegate?.citiesCollectionView?.reloadData()
                    self.delegate?.pageControl.numberOfPages = self.delegate?.weatherDataArray.count ?? 0
                    self.hideErrorView()
                    self.dismissView()
                    
                }
            case .failure(_):
                self.showErrorView()
                print("asdkajsndkjasndjkasdnj")
                DispatchQueue.main.async {
                    self.delegate?.citiesCollectionView?.isHidden = false
                    self.delegate?.pageControl.isHidden = false
                    self.delegate?.errorLabel.isHidden = true
                    self.delegate?.errorIcon.isHidden = true
                    self.delegate?.errorButton.isHidden = true
                }
            }
        }
    }
    
    func showErrorView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.errorView.transform = CGAffineTransform(translationX: 0, y: 100)
                self.errorView.alpha = 1.0
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.hideErrorView()
                }
            }
        }
    }
    
    func hideErrorView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.errorView.transform = CGAffineTransform(translationX: 0, y: -100)
                self.errorView.alpha = 0.0
            }
        }
    }
    
    @objc private func dismissView() {
        self.delegate?.navigationController?.setNavigationBarHidden(false, animated: false)
        self.hideErrorView()
        self.textField.text = ""

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        }) { _ in
            self.transform = .identity
            self.alpha = 1
            self.isHidden = true
        }
    }


}
