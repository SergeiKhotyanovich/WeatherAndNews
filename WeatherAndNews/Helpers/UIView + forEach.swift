//
//  Extension.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 29.03.22.
//

import UIKit

extension UIView{
    func addSubviews(_ array: [UIView]){
        array.forEach{
            addSubview($0)
        }
    }
    
}

