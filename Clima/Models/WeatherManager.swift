import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager ,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager  {
    var delegate : WeatherManagerDelegate?
    let url =
        "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=3f2f35380b07e31d6310bd3d5438af14"
    func fetchWather(cityName: String) {
        let urlString = "\(url)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func fetchWather(lat: Double, lon: Double) {
        let urlString = "\(url)&lat=\(lat)&lon=\(lon)"
        performRequest(urlString: urlString)
    }

    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(
                WeatherData.self,
                from: weatherData
            )
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(
                conditionId: id,
                cityName: name,
                temperature: temp
            )
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

}


