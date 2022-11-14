//
//  CurrentView.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 16.10.22.
//

import Foundation
import UIKit


class CurrentView: UIView {
    
    private let tempLabel = UILabel()
    private let weatherPicture = UIImageView()
    private let cityNameLabel = UILabel()
    private let weatherDescriptionLabel = UILabel()
    private let bigScreenWidth = 570

    private var collectionViewModels: CurrentWeatherCollectionViewModel?
    
    private let currentCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(CurrentCollectionViewCell.self, forCellWithReuseIdentifier: CurrentCollectionViewCell.identifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([tempLabel,weatherPicture,cityNameLabel,weatherDescriptionLabel,currentCollectionView])
        setupStyle()
        currentCollectionView.delegate = self
        currentCollectionView.dataSource = self
        currentCollectionView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayout()
        setupCollectionViewLayout()
    }
    
    //MARK: Setuping Layout
    
    func setupLayout() {
        
        tempLabel.snp.makeConstraints { make in
            make.width.height.equalTo(self.frame.width/2)
            make.top.left.equalToSuperview()
        }
        
        weatherPicture.snp.makeConstraints { make in
            make.width.equalTo(self.frame.width/2)
            make.height.equalTo(self.frame.width/2 - 20)
            make.right.equalToSuperview().inset(8)
            make.top.equalToSuperview()
        }
        
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).inset(25)
            make.left.equalToSuperview().inset(8)
            make.right.equalTo(self.snp.centerX)
            make.height.equalTo(self.frame.width/5)
        }
        
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherPicture.snp.bottom)
            make.right.equalToSuperview().inset(8)
            make.left.equalTo(self.snp.centerX).offset(8)
            make.height.equalTo(self.frame.width/5)
            make.bottom.equalTo(currentCollectionView.snp.top).inset(-16)
        }
        
        currentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(16)
            make.right.left.equalTo(self).inset(16)
            make.bottom.equalTo(self).inset(4)
        }
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        if Int(self.frame.height) > bigScreenWidth {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(
                width: frame.width / 3 - 16,
                height: currentCollectionView.frame.height / 3 - 8
            )
        } else {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(
                width: ((frame.width / 3) - 16 ),
                height: (currentCollectionView.frame.height - 32)
            )
        }
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 1
        currentCollectionView.collectionViewLayout = layout
    }
    
    //MARK: Setuping Style
    
    func setupStyle() {
        tempLabelStyle()
        cityLabelStyle()
        weatherLabelStyle()
        weatherPictureStyle()
    }
    
    func tempLabelStyle() {
        tempLabel.textAlignment = .center
        tempLabel.textColor = Color.secondary
        tempLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 300)
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.minimumScaleFactor = 0.01
        tempLabel.numberOfLines = 0
    }
    
    func cityLabelStyle() {
        cityNameLabel.text = "Minsk"
        cityNameLabel.textAlignment = .center
        cityNameLabel.textColor = Color.secondary
        cityNameLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 40)
        cityNameLabel.adjustsFontSizeToFitWidth = true
        cityNameLabel.minimumScaleFactor = 0.6
        cityNameLabel.numberOfLines = 2
    }
    
    func weatherLabelStyle() {
        weatherDescriptionLabel.text = "Sunny"
        weatherDescriptionLabel.textAlignment = .center
        weatherDescriptionLabel.textColor = Color.secondary
        weatherDescriptionLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 40)
        weatherDescriptionLabel.adjustsFontSizeToFitWidth = true
        weatherDescriptionLabel.minimumScaleFactor = 0.6
        weatherDescriptionLabel.numberOfLines = 0
    }
    
    func weatherPictureStyle() {
        weatherPicture.tintColor = Color.secondary
    }

    func updateView(model: CurrentWeatherCollectionViewModel) {
        
        UIView.animate(withDuration: 2, delay: 0) {
            self.weatherPicture.image = model.weatherPicture
            self.cityNameLabel.text = model.cityLabel
            self.weatherDescriptionLabel.text = model.weatherLabel
            self.tempLabel.text = model.tempLabel
            self.currentCollectionView.reloadData()
        }
        collectionViewModels = model
    }
}

//MARK: extension currentView

extension CurrentView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCollectionViewCell.identifier, for: indexPath) as! CurrentCollectionViewCell
        
        let model = collectionViewModels
        
        switch indexPath.row{
        case 0:
            if let pressure = model?.currentWeatherCollectionModel.pressure.descriptions{
                cell.label.text = pressure
            }
            cell.imageView.image = model?.currentWeatherCollectionModel.pressure.image
        case 3:
            if let humidity = model?.currentWeatherCollectionModel.humidity.descriptions{
                cell.label.text = humidity
            }
            
            cell.imageView.image = model?.currentWeatherCollectionModel.humidity.image
        case 6:
            if let windSpeed = model?.currentWeatherCollectionModel.windSpeed.descriptions{
                cell.label.text = windSpeed
            }
            cell.imageView.image = model?.currentWeatherCollectionModel.windSpeed.image
        case 1:
            if let visibility = model?.currentWeatherCollectionModel.visibility.descriptions{
                cell.label.text = visibility
            }
            cell.imageView.image = model?.currentWeatherCollectionModel.visibility.image
        case 4:
            if let clouds = model?.currentWeatherCollectionModel.сloudiness.descriptions{
                cell.label.text = clouds
            }
            cell.imageView.image = model?.currentWeatherCollectionModel.сloudiness.image
        case 7:
            if let feelsLike = model?.currentWeatherCollectionModel.feelsLike.descriptions{
                cell.label.text = feelsLike
            }
            cell.imageView.image = model?.currentWeatherCollectionModel.feelsLike.image
        case 2:
            if let rainfall = model?.currentWeatherCollectionModel.rainfall.descriptions{
                cell.label.text = rainfall
            }
            cell.imageView.image = model?.currentWeatherCollectionModel.rainfall.image
        case 5:
            if let tempMax = model?.currentWeatherCollectionModel.tempMax.descriptions{
                cell.label.text = tempMax
            }
            cell.imageView.image = model?.currentWeatherCollectionModel.tempMax.image
        case 8:
            if let tempMin = model?.currentWeatherCollectionModel.tempMin.descriptions{
                cell.label.text = tempMin
            }
            cell.imageView.image = model?.currentWeatherCollectionModel.tempMin.image
        default:
            cell.label.text = model?.cityLabel
        }
        return cell
    }
    
}

