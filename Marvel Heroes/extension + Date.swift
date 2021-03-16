//
//  extension + Date.swift
//  Marvel Heroes
//
//  Created by Nikita Entin on 04.03.2021.
//

import Foundation

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
