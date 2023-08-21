//
//  Date+Extension.swift
//  ImageFeedList
//
//  Created by Dassam on 14.08.2023.
//

import Foundation

extension Date {
    
    func toStringDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "RU_ru")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: self)
    }
}
