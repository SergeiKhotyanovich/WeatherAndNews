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
    private let sityLabel = UILabel()
    private let weatherLabel = UILabel()
    private let bigScreenWidth = 570

    private var collectionViewModels: CurrentWeatherCollectionViewModel?
    
    private let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(CurrentCollectionViewCell.self, forCellWithReuseIdentifier: CurrentCollectionViewCell.identifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([tempLabel,weatherPicture,sityLabel,weatherLabel,collectionView])
        setupStyle()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
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
            make.right.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        sityLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
            make.height.equalTo(self.frame.width/7)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherPicture.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalTo(self.snp.centerX)
            make.height.equalTo(self.frame.width/7)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sityLabel.snp.bottom).offset(16)
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
                height: collectionView.frame.height / 3 - 8
            )
        } else {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(
                width: ((frame.width / 3) - 16 ),
                height: (collectionView.frame.height - 32)
            )
        }
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 1
        collectionView.collectionViewLayout = layout
    }
    
    //MARK: Setuping Style
    
    func setupStyle() {
        tempLabelStyle()
        sityLabelStyle()
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
    
    func sityLabelStyle() {
        sityLabel.text = "Minsk"
        sityLabel.textAlignment = .center
        sityLabel.textColor = Color.secondary
        sityLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 100)
        sityLabel.adjustsFontSizeToFitWidth = true
        sityLabel.minimumScaleFactor = 0.2
    }
    
    func weatherLabelStyle() {
        weatherLabel.text = "Sunny"
        weatherLabel.textAlignment = .center
        weatherLabel.textColor = Color.secondary
        weatherLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 100)
        weatherLabel.adjustsFontSizeToFitWidth = true
        weatherLabel.minimumScaleFactor = 0.01
        weatherLabel.numberOfLines = 0
    }
    
    func weatherPictureStyle() {
        weatherPicture.tintColor = Color.secondary
    }

    func updateView(model: CurrentWeatherCollectionViewModel) {
        weatherPicture.image = model.weatherPicture
        sityLabel.text = model.sityLabel
        weatherLabel.text = model.weatherLabel
        tempLabel.text = model.tempLabel
        collectionViewModels = model
        collectionView.reloadData()
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
            cell.label.text = model?.sityLabel
        }
        return cell
    }
    
}

