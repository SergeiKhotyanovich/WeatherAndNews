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
    
    private var viewModels: [CurrentWeatherCollectionVievModel]?
    
    private let currentCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(CurrentCollectionViewCell.self, forCellWithReuseIdentifier: CurrentCollectionViewCell.identifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupCollectionsSetting()
        setupStyle()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayout()
        setupCollectionViewLayout()
    }
    
    func setupUI() {
        addSubviews([tempLabel,weatherPicture,
                     cityNameLabel,weatherDescriptionLabel,
                     currentCollectionView
                    ])
        
        currentCollectionView.backgroundColor = .clear
    }
    
    func setupCollectionsSetting() {
        currentCollectionView.delegate = self
        currentCollectionView.dataSource = self
    }
    
    //MARK: SetupLayout
    
    func setupLayout() {
        
        tempLabel.snp.makeConstraints { make in
            make.width.height.equalTo(self.frame.width/2)
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(weatherPicture.snp.left)
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
    
    //MARK: SetupStyle
    
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
        cityNameLabel.textAlignment = .center
        cityNameLabel.textColor = Color.secondary
        cityNameLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 40)
        cityNameLabel.adjustsFontSizeToFitWidth = true
        cityNameLabel.minimumScaleFactor = 0.6
        cityNameLabel.numberOfLines = 2
    }
    
    func weatherLabelStyle() {
        weatherDescriptionLabel.textAlignment = .center
        weatherDescriptionLabel.textColor = Color.secondary
        weatherDescriptionLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 40)
        weatherDescriptionLabel.adjustsFontSizeToFitWidth = true
        weatherDescriptionLabel.minimumScaleFactor = 0.6
        weatherDescriptionLabel.numberOfLines = 0
    }
    
    func weatherPictureStyle() {
        weatherPicture.tintColor = Color.secondary
        weatherPicture.contentMode = .scaleAspectFit
    }
    
    func updateView(model: CurrentWeatherViewModel) {
        self.weatherPicture.image = model.weatherPicture
        self.cityNameLabel.text = model.cityLabel
        self.weatherDescriptionLabel.text = model.weatherLabel
        self.tempLabel.text = model.tempLabel
        self.currentCollectionView.reloadData()
        
        viewModels = model.currentWeatherCollectionVievModel
    }
}

//MARK: extension CurrentView

extension CurrentView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = viewModels else { return 0 }
        
        return  model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCollectionViewCell.identifier, for: indexPath) as? CurrentCollectionViewCell,
            let collectionViewModel = viewModels else { return UICollectionViewCell() }
        
        cell.updateCellWith(model: collectionViewModel[indexPath.row])
        
        return cell
    }
    
}

