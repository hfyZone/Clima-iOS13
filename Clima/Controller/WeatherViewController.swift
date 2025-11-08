//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!

    var weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 将搜索框的动态变化监听委托给viewController
        searchTextField.delegate = self
        weatherManager.delegate = self

    }

}
// MARK: - UITextFieldDelegate
// The extension helps to organize the code
// 可以加入code snippet实现自定义简写
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    // Inherited from UITextFieldDelegate.XX
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            textField.placeholder = "Type Something Here!"
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWather(cityName: city)
        }

        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(
        _ weatherManager: WeatherManager,
        weather: WeatherModel
    ) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(
                systemName: weather.conditionName
            )
            self.cityLabel.text = weather.cityName
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
