//
//  ForecastViewController.swift
//  Final - Weather app
//
//  Created by Luka Khokhiashvili on 17.07.24.
//

import UIKit

class ForecastViewController: UIViewController {
    private var urlcomponent: URLComponents!
    private var weatherData: ForecastWeather? = nil
    
    private var city: String?
    private var latitude: Double?
    private var longitude: Double?
    
    private let forecastTableView = UITableView(frame: .zero, style: .grouped)
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Error occurred while loading data"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let errorIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "data_load_error")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        return image
    }()
    private let errorButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reload", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(reload), for: .touchUpInside)
        return button
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    func configure(city: String?, latitude: Double?, longitude: Double?) {
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgound()
        setupNavigationBar()
        
        setupUrlComponent(city: city, latitude: latitude, longitude: longitude)
        fetchData()
       
        setupTableView()
        setupErrorLabel()
        setupSpinner()
    }
    
    private func setupBackgound() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor(named: "bg-gradient-start")!.cgColor,
            UIColor(named: "bg-gradient-end")!.cgColor
        ]
        view.layer.addSublayer(gradient)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.circlepath"),
            style: .plain,
            target: self,
            action: #selector(reload))
    }
    
    @objc
    private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func reload() {
        forecastTableView.isHidden = true
        errorLabel.isHidden = true
        errorIcon.isHidden = true
        errorButton.isHidden = true
        spinner.startAnimating()
        fetchData()
    }
    
    private func setupTableView() {
        view.addSubview(forecastTableView)
        forecastTableView.dataSource = self
        forecastTableView.delegate = self
        forecastTableView.translatesAutoresizingMaskIntoConstraints = false
        forecastTableView.backgroundColor = .clear
        forecastTableView.register(ForecastCell.self, forCellReuseIdentifier: "ForecastCell")
        NSLayoutConstraint.activate([
            forecastTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            forecastTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            forecastTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            forecastTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupErrorLabel() {
        view.addSubview(errorIcon)
        view.addSubview(errorLabel)
        view.addSubview(errorButton)
        NSLayoutConstraint.activate([
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            errorIcon.widthAnchor.constraint(equalToConstant: 100),
            errorIcon.heightAnchor.constraint(equalToConstant: 100),
            errorIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorIcon.bottomAnchor.constraint(equalTo: errorLabel.topAnchor, constant: -10),
            errorButton.heightAnchor.constraint(equalToConstant: 40),
            errorButton.widthAnchor.constraint(equalToConstant: 110),
            errorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 10),
        ])
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        spinner.startAnimating()
    }
}

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupWeatherDataByDay().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupWeatherDataByDay()[section].1.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupWeatherDataByDay()[section].0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = UIColor(named: "AccentColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = groupWeatherDataByDay()[section].0
        
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        
        let groupedData = groupWeatherDataByDay()
        let weather = groupedData[indexPath.section].1[indexPath.row]
        
        let icon = weather.weather.first?.icon ?? ""
        let time = getHourAndMinutes(from: weather.dt) ?? ""
        let description = weather.weather.first?.description.rawValue ?? ""
        let temp = Int(weather.main.temp)
        
        cell.configure(
            icon: icon,
            time: time,
            desctipton: description,
            temp: temp
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getWeekday(from dt: Int?) -> String? {
        guard let dt = dt else { return nil }
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    func getHourAndMinutes(from dt: Int?) -> String? {
        guard let dt = dt else { return nil }
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    private func groupWeatherDataByDay() -> [(String, [FList])] {
        var groupedData = [String: [FList]]()
        var orderedWeekdays = [String]()
        
        weatherData?.list.forEach { weather in
            let weekday = getWeekday(from: weather.dt) ?? "Unknown"
            if groupedData[weekday] != nil {
                groupedData[weekday]?.append(weather)
            } else {
                groupedData[weekday] = [weather]
                orderedWeekdays.append(weekday)
            }
        }
        
        return orderedWeekdays.map { (weekday) in
            (weekday, groupedData[weekday] ?? [])
        }
    }
}

extension ForecastViewController {
    private func setupUrlComponent(city: String?, latitude: Double?, longitude: Double?) {
        urlcomponent = URLComponents()
        urlcomponent.scheme = "https"
        urlcomponent.host = "api.openweathermap.org"
        urlcomponent.path = "/data/2.5/forecast"
        
        var queryItems = [URLQueryItem]()
        
        if let city = city {
            queryItems.append(URLQueryItem(name: "q", value: city))
        }
        
        if let latitude = latitude, let longitude = longitude {
            queryItems.append(URLQueryItem(name: "lat", value: "\(latitude)"))
            queryItems.append(URLQueryItem(name: "lon", value: "\(longitude)"))
        }
        
        queryItems.append(URLQueryItem(name: "appid", value: "fc39e5ab5953b93de27eae5f85acab7e"))
        queryItems.append(URLQueryItem(name: "units", value: "metric"))
        
        urlcomponent.queryItems = queryItems
    }
    
    private func fetchData() {
        guard let url = urlcomponent.url else {
            showError()
            print("Invalid URL")
            return
        }
        print(url)
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                self?.showError()
                print("data error: \(String(describing: error))")
                return
            }
            do {
                let weatherData = try JSONDecoder().decode(ForecastWeather.self, from: data)
                DispatchQueue.main.async {
                    self?.weatherData = weatherData
                    self?.navigationItem.title = weatherData.city.name
                    self?.forecastTableView.reloadData()
                    self?.forecastTableView.isHidden = false
                    self?.errorLabel.isHidden = true
                    self?.errorIcon.isHidden = true
                    self?.errorButton.isHidden = true
                    self?.spinner.stopAnimating()
                }
            } catch {
                self?.showError()
                print("decoding error: \(error)")
            }
        }.resume()
    }
    
    private func showError() {
        DispatchQueue.main.async {
            self.forecastTableView.isHidden = true
            self.errorLabel.isHidden = false
            self.errorIcon.isHidden = false
            self.errorButton.isHidden = false
            self.spinner.stopAnimating()
        }
    }
}
