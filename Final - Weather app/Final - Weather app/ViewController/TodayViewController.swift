//
//  TodayViewController.swift
//  Final - Weather app
//
//  Created by Luka Khokhiashvili on 10.07.24.
//

import UIKit
import CoreLocation


class TodayViewController: UIViewController {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var cities = [City]()
    private let locationManager = CLLocationManager()
    var citiesCollectionView: UICollectionView?
    let pageControl = UIPageControl()
    var weatherDataArray = [WeatherData]()
    let errorLabel: UILabel = {
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
    let errorIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "data_load_error")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        return image
    }()
    let errorButton: UIButton = {
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
    
   
    
    let addCityView  = AddCityView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //         Do any additional setup after loading the view.
        getAllCities()
        fetchWeatherData()
        setupBackgound()
        setupNavigationBar()
        setupLocationManager()
        setupPageControl()
        setupCitiesCollectionView()
        setupErrorLabel()
        setupSpinner()
        view.addSubview(addCityView)
        addCityView.configure(delegate: self)
        addCityView.frame = view.bounds
        addCityView.isHidden = true
        
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(add))
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.circlepath"),
            style: .plain,
            target: self,
            action: #selector(reload))
        navigationItem.title = "Today"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    @objc
    private func add() {
        addCityView.isHidden = false
        addCityView.alpha = 0
        addCityView.transform = CGAffineTransform(translationX: 0, y: addCityView.frame.height)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.addCityView.transform = .identity
            self.addCityView.alpha = 1
        }) { _ in
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }


  

    
    
    @objc
    private func reload(){
        citiesCollectionView?.isHidden = true
        pageControl.isHidden = true
        errorLabel.isHidden = true
        errorIcon.isHidden = true
        errorButton.isHidden = true
        spinner.startAnimating()
        locationManager.requestLocation()
        fetchWeatherData()
        citiesCollectionView?.reloadData()
        
        
    }
    
  
    
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func setupCitiesCollectionView() {
        let layout = CustomCarouselFlowLayout()
        
        citiesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        citiesCollectionView?.register(CarouselCell.self, forCellWithReuseIdentifier: "CarouselCell")
        citiesCollectionView?.delegate = self
        citiesCollectionView?.dataSource = self
        citiesCollectionView?.showsHorizontalScrollIndicator = false
        citiesCollectionView?.backgroundColor = .clear
        citiesCollectionView?.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        guard let citiesCollectionView = citiesCollectionView else { return }
        
        view.addSubview(citiesCollectionView)
        setupCitiesCollectionViewConstraints()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        citiesCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    
    private func setupCitiesCollectionViewConstraints() {
        guard let citiesCollectionView = citiesCollectionView else { return }
        
        citiesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            citiesCollectionView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20),
            citiesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            citiesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            citiesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: self.citiesCollectionView)
        if let indexPath = self.citiesCollectionView?.indexPathForItem(at: point) {
            if indexPath.row == 0 {return}
            switch gesture.state {
            case .began:
                showActionSheet(for: indexPath)
            default:
                break
            }
        }
    }
    
    func showActionSheet(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteCity(city: self.cities[indexPath.row - 1])
            self.weatherDataArray.remove(at: indexPath.row)
            self.citiesCollectionView?.reloadData()
            self.pageControl.numberOfPages = self.weatherDataArray.count
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = cities.count + 1
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .systemGray6
        pageControl.currentPageIndicatorTintColor = .systemYellow
        pageControl.isHidden = true
        
        view.addSubview(pageControl)
        setupPageControlConstraints()
    }
    
    private func setupPageControlConstraints() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
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
    
    private func showError() {
        DispatchQueue.main.async {
            self.citiesCollectionView?.isHidden = true
            self.pageControl.isHidden = true
            self.errorLabel.isHidden = false
            self.errorIcon.isHidden = false
            self.errorButton.isHidden = false
            self.spinner.stopAnimating()
        }
    }
}



// MARK: - CLLocationManagerDelegate

extension TodayViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        showAlert(error)
    }
    
    func showAlert(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default))
        present(alert, animated: true)
    }
}


extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        cell.configure(with: weatherDataArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let forecastViewController = ForecastViewController()
        
        if indexPath.row == 0{
            forecastViewController.configure(
                city: nil,
                latitude: locationManager.location?.coordinate.latitude,
                longitude: locationManager.location?.coordinate.longitude)
        }
        else{
            forecastViewController.configure(
                city: cities[indexPath.row - 1].name,
                latitude: nil,
                longitude: nil)
        }
        
        navigationController?.pushViewController(forecastViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.8
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page: Int = Int(ceil(scrollView.contentOffset.x/314.666666667))
        pageControl.currentPage = page
    }
    
}


extension TodayViewController {
    private func getAllCities() {
        let request = City.fetchRequest()
        
        do {
            cities = try context.fetch(request)
        } catch {
            showError()
            fatalError("Error")
        }
    }
    
    func createCity(name: String) {
        let city = City(context: context)
        city.name = name
        
        do {
            try context.save()
            getAllCities()
        } catch {
            showError()
            fatalError("Error")
        }
    }
    
    private func deleteCity(city: City) {
        context.delete(city)
        do {
            try context.save()
            getAllCities()
        } catch {
            showError()
            fatalError("Error")
        }
    }
    
    
    private func fetchWeatherData() {
        var citiesToFetch: [String?] = cities.map { $0.name }
        citiesToFetch.insert(contentsOf: [nil], at: 0)
        
        let dispatchGroup = DispatchGroup()
        
        for city in citiesToFetch {

            dispatchGroup.enter()
            fetchWeatherData(for: city) { [weak self] result in

                switch result {
                case .success(let weatherData):
                    self?.weatherDataArray.append(weatherData)
                case .failure(let error):
                    self?.showError()
                    print("Error fetching weather data: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.sortWeatherDataArray(weatherDataArray: &self.weatherDataArray, citiesToFetch: citiesToFetch)
            self.citiesCollectionView?.reloadData()
            self.citiesCollectionView?.isHidden = false
            self.pageControl.isHidden = false
            self.errorLabel.isHidden = true
            self.errorIcon.isHidden = true
            self.errorButton.isHidden = true
            self.spinner.stopAnimating()
            self.pageControl.numberOfPages = self.weatherDataArray.count
        }
    }
    //ძაან ცუდი სოლუშენია ვიცი :D
    func sortWeatherDataArray(weatherDataArray: inout [WeatherData], citiesToFetch: [String?]) {
        var newWeatherDataArray: [WeatherData] = []
        
        for cityName in citiesToFetch {
            guard let cityName = cityName else {
                continue
            }
            

            if let index = weatherDataArray.firstIndex(where: { $0.cityName?.caseInsensitiveCompare(cityName) == .orderedSame }) {
                let weatherData = weatherDataArray.remove(at: index)
                
                newWeatherDataArray.append(weatherData)
            }
        }
        if weatherDataArray.first != nil{
            newWeatherDataArray.insert(weatherDataArray.first!, at: 0)
        }
        weatherDataArray = newWeatherDataArray
    }
    
    
    func fetchWeatherData(for city: String?, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        var urlcomponent = URLComponents()
        urlcomponent.scheme = "https"
        urlcomponent.host = "api.openweathermap.org"
        urlcomponent.path = "/data/2.5/weather"
        
        var queryItems = [URLQueryItem]()
        
        if let city = city {
            queryItems.append(URLQueryItem(name: "q", value: city))
        } else if let location = locationManager.location {
            queryItems.append(URLQueryItem(name: "lat", value: "\(location.coordinate.latitude)"))
            queryItems.append(URLQueryItem(name: "lon", value: "\(location.coordinate.longitude)"))
        }
        
        queryItems.append(URLQueryItem(name: "appid", value: "fc39e5ab5953b93de27eae5f85acab7e"))
        queryItems.append(URLQueryItem(name: "units", value: "metric"))
        
        urlcomponent.queryItems = queryItems
        
        guard let url = urlcomponent.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            showError()
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                self.showError()
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                self.showError()
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(TodayWeather.self, from: data)
                let locale = Locale(identifier: "en_US")
                let country = locale.localizedString(forRegionCode: weatherData.sys.country)
                let weather = WeatherData(
                    cityName: weatherData.name,
                    countryName: country,
                    temperature: weatherData.main.temp,
                    main: weatherData.weather[0].main,
                    iconURL: "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon)@2x.png",
                    cloudiness: weatherData.clouds.all,
                    humidity: weatherData.main.humidity,
                    windSpeed: weatherData.wind.speed,
                    windDirection: self.windDirectionConvert(from: Double(weatherData.wind.deg))
                )
                completion(.success(weather))
            } catch {
                self.showError()
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func windDirectionConvert(from degrees: Double) -> String {
        switch degrees {
        case 0..<22.5, 337.5...360:
            return "N"
        case 22.5..<67.5:
            return "NE"
        case 67.5..<112.5:
            return "E"
        case 112.5..<157.5:
            return "SE"
        case 157.5..<202.5:
            return "S"
        case 202.5..<247.5:
            return "SW"
        case 247.5..<292.5:
            return "W"
        case 292.5..<337.5:
            return "NW"
        default:
            return ""
        }
    }
}
