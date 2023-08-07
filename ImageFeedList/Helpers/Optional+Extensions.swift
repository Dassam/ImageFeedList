//
//  Optional+Extensions.swift
//  ImageFeedList
//
//  Created by Dassam on 07.08.2023.
//

import Foundation

extension Optional where Wrapped == Int {
    var number: Int {
        switch self {
        case .some(let number):
            return number
        case .none:
            return 0
        }
    }
}
