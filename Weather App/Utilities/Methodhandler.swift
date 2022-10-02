//
//  Methodhandler.swift
//  Weather App
//
//  Created by Apple on 10/2/22.
//

import Foundation

class MethodHandler {
    private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            return formatter
        }()
    
    static func getDateformatter(date: Date, formatter: String) -> String {
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: date)
    }
}
