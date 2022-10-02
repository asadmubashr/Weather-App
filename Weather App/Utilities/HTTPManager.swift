//
//  HTTPManager.swift
//  Weather App
//
//  Created by Apple on 10/2/22.
//

import Foundation
import Alamofire

class HTTPManager: APIHandler {
    static let shared: HTTPManager = HTTPManager()
    
    public func getWeatherForecast<T: Codable>(_ city: String, completion: @escaping (_ response: T?) -> Void)
    {
        let url = "http://api.weatherapi.com/v1/forecast.json?key=" + Constants.api_key + "&q=" + city + "&days=3&aqi=no&alerts=no"

        print(url)
        AF.request(url)
            .validate()
            .responseDecodable { [weak self] (response: DataResponse<T, AFError>) in
                guard let weakSelf = self else { return }
                guard let response = weakSelf.handleResponse(response) as? T else {
                    completion(nil)
                    return
                }
                completion(response)
            }
    }
}
