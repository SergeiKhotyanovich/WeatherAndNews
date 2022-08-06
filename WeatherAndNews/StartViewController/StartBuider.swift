//
//  StartBuider.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 29.03.22.
//

import Foundation

final class StartBuilder{
    static func build() -> StartViewCotroller{
        let view = StartViewCotroller()
        let presenter = startPresenter(view: view)
        
        view.presenter = presenter
        return view
    }
    
    
    
}
