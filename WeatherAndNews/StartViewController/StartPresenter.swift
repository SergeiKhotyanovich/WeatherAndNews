//
//  StartPresenter.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 27.03.22.
//

import Foundation
import UIKit

protocol startPresenterProtocol{
    init(view:startViewCotrollerProtocol)
    
    func fetchButtonPressed()
}

final class startPresenter:startPresenterProtocol{
    
    private weak var view:startViewCotrollerProtocol?
    
    init(view:startViewCotrollerProtocol){
        self.view = view
    }
    
    func fetchButtonPressed(){
        view?.routeToNextVC()
    }
}
