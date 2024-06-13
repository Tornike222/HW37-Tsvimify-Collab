//
//  DoubleExtensions.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Temur Chitashvili on 13.06.24.
//

import Foundation

extension Double {
    func getTimeStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
    
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        
        let monthAndDate = dateFormatter.string(from: date).prefix(6)
        
        return String(monthAndDate)
    }
    
    func dayOfWeek() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
}
