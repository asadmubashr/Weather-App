//
//  HomeViewModel.swift
//  Weather App
//
//  Created by Apple on 10/2/22.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var isSuccess = false
    @Published var isLoading = false
    @Published var isError = false
    
    @Published var location: Location?
    @Published var current: Current?
    @Published var forecast: Forecast?
    
    func getWeatherForecast(city: String, completion: @escaping (_ response: Bool) -> Void) {
        self.isLoading = true

        HTTPManager.shared.getWeatherForecast(city) { (response: Weather_Base?) in
            guard let response = response else {
                self.isError = true
                completion(false)
                return
            }

            self.location = response.location
            self.current = response.current
            self.forecast = response.forecast
            
            self.isLoading = false
            self.isError = false
            completion(true)
        }
    }
}
