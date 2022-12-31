//
//  SettingViewController.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 29.12.22.
//

import UIKit
import SnapKit
import MapKit

protocol SettingViewControllerPtotokol {
    
}

class SettingViewController: UIViewController, SettingViewControllerPtotokol {
    
    var presenter: SettingPresenterProtokol!
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Color.element
        button.setTitle("Close", for: .normal)
        button.setTitleColor(Color.secondary, for: .normal)
        button.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 20)
        return button
    }()
    
    let languageLabel: UILabel = {
        let label = UILabel()
        label.text = "Language:"
        label.textAlignment = .center
        label.textColor = Color.secondary
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 30)
        return label
    }()
    
    let themeLabel: UILabel = {
        let label = UILabel()
        label.text = "Theme:"
        label.textAlignment = .center
        label.textColor = Color.secondary
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 30)
        return label
    }()
    
    let languageSegmentControl: UISegmentedControl = {
        let items = ["Eng", "Ru"]
        let view = UISegmentedControl(items: items)
        view.selectedSegmentIndex = 0
        view.selectedSegmentTintColor = Color.secondary
        view.backgroundColor = .gray
        return view
    }()
    
    let themeSegmentControl: UISegmentedControl = {
        let items = ["Light", "Dark"]
        let view = UISegmentedControl(items: items)
        view.selectedSegmentIndex = 0
        view.selectedSegmentTintColor = Color.secondary
        view.backgroundColor = .gray
        return view
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Temperature:"
        label.textAlignment = .center
        label.textColor = Color.secondary
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 30)
        return label
    }()
    
    let temperatureSegmentControl: UISegmentedControl = {
        let items = ["°C", "°F"]
        let view = UISegmentedControl(items: items)
        view.selectedSegmentIndex = 0
        view.selectedSegmentTintColor = Color.secondary
        view.backgroundColor = .gray
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
    }
    
    func setupUI() {
        
        view.addSubviews([
            languageLabel,
            themeLabel,
            languageSegmentControl,
            themeSegmentControl,
            temperatureLabel,
            temperatureSegmentControl,
            closeButton
        ])
        view.backgroundColor = Color.main
        
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        
    }
    
    //MARK: SETUP LAYOUT
    
    func setupLayout() {
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.left.equalTo(view.frame.width / 6)
            make.height.equalTo(40)
        }
        
        temperatureSegmentControl.snp.makeConstraints { make in
            make.centerY.equalTo(temperatureLabel.snp.centerY)
            make.left.equalTo(temperatureLabel.snp.right).offset(15)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(20)
            make.left.equalTo(view.frame.width / 6)
            make.height.equalTo(40)
        }
        
        languageSegmentControl.snp.makeConstraints { make in
            make.centerY.equalTo(languageLabel.snp.centerY)
            make.left.equalTo(temperatureLabel.snp.right).offset(15)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        
        themeLabel.snp.makeConstraints { make in
            make.top.equalTo(languageLabel.snp.bottom).offset(20)
            make.left.equalTo(view.frame.width / 6)
            make.height.equalTo(40)
        }
        
        themeSegmentControl.snp.makeConstraints { make in
            make.centerY.equalTo(themeLabel.snp.centerY)
            make.left.equalTo(temperatureLabel.snp.right).offset(15)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        
        closeButton.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    
   @objc func closeButtonPressed() {
       
       switch temperatureSegmentControl.selectedSegmentIndex {
       case 0:
           UserTemperature.shared.userTemperature = "metric"
       case 1:
           UserTemperature.shared.userTemperature = "imperial"
       default:
           UserTemperature.shared.userTemperature = "metric"
       }
       
       switch languageSegmentControl.selectedSegmentIndex {
       case 0:
           UserLanguage.shared.userLanguage = "en"
       case 1:
           UserLanguage.shared.userLanguage = "ru"
       default:
           UserLanguage.shared.userLanguage = "en"
       }
       
       switch themeSegmentControl.selectedSegmentIndex {
       case 0:
           UserTheme.shared.userTheme = "Light"
       case 1:
           UserTheme.shared.userTheme = "Dark"
       default:
           UserTheme.shared.userTheme = "Light"
       }
       
       let vc = WeatherBuilder.build()
       vc.presenter.updateWeatherButtonPressed(temperature: UserTemperature.shared.userTemperature,
                                               language: UserLanguage.shared.userLanguage)

       dismiss(animated: true, completion: nil)
 
    }
}
