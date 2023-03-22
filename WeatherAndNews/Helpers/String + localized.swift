//
//  UISegmentControll + localized.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 21.03.23.
//

import Foundation
import UIKit


extension String {
    func localized() -> String {
        NSLocalizedString(self,
                          tableName: "Localizable",
                          bundle: .main,
                          value: self,
                          comment: self)
    }
}
