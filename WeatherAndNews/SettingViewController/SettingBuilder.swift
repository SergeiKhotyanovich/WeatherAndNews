//
//  SettingBuilder.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 29.12.22.
//

import Foundation


class SettingBuilder {
    static func build() -> SettingViewController {
        let view = SettingViewController()
        
        let presenter = SettingPresenter(view: view)
        
        view.presenter = presenter
        return view
    }
}
