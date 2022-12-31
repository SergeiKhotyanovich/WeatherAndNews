//
//  SettingPresenter.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 29.12.22.
//

import UIKit

protocol SettingPresenterProtokol: NSObject {
    init(view: SettingViewControllerPtotokol)
}

class SettingPresenter: NSObject, SettingPresenterProtokol {
    
    
    var view: SettingViewControllerPtotokol?
    
    
    required init(view: SettingViewControllerPtotokol) {
        self.view = view
        super.init()
    }
    
    
    
}
