//
//  ForecastView.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 16.10.22.
//

import SnapKit
import UIKit

class ForecastView: UIView {
    
    var forecastTableView = UITableView(frame: .zero, style: .grouped)
    var collectionViewModels: ForecastWeatherViewModel?
    var numberOfSections: [String] = []
    var numberOfRows: [String] = []
    var indexPathRow = 0
    
    private var backView = UIView()
    var detailedWeatherView = UIView()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    private var tempDetailedView: UILabel = {
        let label = UILabel()
        label.text = "23°"
        label.textAlignment = .center
        label.textColor = Color.secondary
        label.font = UIFont(name: "MarkerFelt-Wide", size: 200)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    
    private var dayOfTheWeekLabel: UILabel = {
        let label = UILabel()
        label.text = "Понедельник,"
        label.textAlignment = .center
        label.textColor = Color.secondary
        label.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    
    private var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Sunny"
        label.textAlignment = .center
        label.textColor = Color.secondary
        label.font = UIFont(name: "MarkerFelt-Wide", size: 50)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    
    private lazy var currentWeatherImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "sun.max")
        view.tintColor = Color.secondary
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "9:00"
        label.textAlignment = .center
        label.textColor = Color.secondary
        label.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    
    private lazy var detailedWeatherСollectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(
            DetailedWeatherCollectionViewCell.self,
            forCellWithReuseIdentifier: DetailedWeatherCollectionViewCell.identifier
        )
        view.backgroundColor = .clear
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([
            forecastTableView,
            backView
        ])
        
        backView.addSubviews([
            blurView,
            detailedWeatherView,
        ])
        detailedWeatherView.addSubviews([
            tempDetailedView, dayOfTheWeekLabel,
            weatherDescriptionLabel, currentWeatherImageView,
            timeLabel, detailedWeatherСollectionView
        ])
        
        blurView.frame = bounds
        setupStyle()
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        detailedWeatherСollectionView.delegate = self
        detailedWeatherСollectionView.dataSource = self
        
        forecastTableView.showsVerticalScrollIndicator = false
        backView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
        blurView.addGestureRecognizer(tap)
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
        forecastTableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
        }
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        detailedWeatherView.snp.makeConstraints { make in
            make.height.equalTo(self.frame.width )
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        currentWeatherImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(8)
            make.right.equalTo(backView.snp.centerX)
            make.height.equalTo((backView.frame.width - 16) / 2)
        }
        tempDetailedView.snp.makeConstraints { make in
            make.left.equalTo(backView.snp.centerX)
            make.top.right.equalToSuperview()
            make.bottom.equalTo(currentWeatherImageView.snp.bottom).inset(40)
        }
        
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(tempDetailedView.snp.bottom).inset(16)
            make.left.equalTo(backView.snp.centerX).offset(16)
            make.bottom.equalTo(currentWeatherImageView.snp.bottom)
            make.right.equalToSuperview().inset(8)
        }
        
        dayOfTheWeekLabel.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherImageView.snp.bottom)
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(detailedWeatherView.snp.centerX).inset(8)
            
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherImageView.snp.bottom)
            make.left.equalTo(dayOfTheWeekLabel.snp.right)
            make.right.equalToSuperview().inset(8)
           
        }
        detailedWeatherСollectionView.snp.makeConstraints { make in
            make.top.equalTo(dayOfTheWeekLabel.snp.bottom).offset(8)
            make.left.bottom.right.equalToSuperview().inset(8)
        }
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: frame.width / 3 - 16,
                                 height: detailedWeatherСollectionView.frame.height / 2 - 16)
        
        layout.minimumInteritemSpacing = 8
        detailedWeatherСollectionView.collectionViewLayout = layout
    }
    
    //MARK: Setuping Style
    
    func setupStyle() {
        tableViewStyle()
        detailedWeatherViewStyle()
    }
    
    func tableViewStyle() {
        forecastTableView.backgroundColor = UIColor(named: "main")
    }
    
    func detailedWeatherViewStyle() {
        detailedWeatherView.layer.cornerRadius = 10
        detailedWeatherView.backgroundColor = Color.main
    }
    
    
    //MARK: Setuping Func
    
    func updateSectionCount(sectionsCount:[String], rowsCount: [String]) {
        numberOfSections = sectionsCount
        numberOfRows = rowsCount
        
    }
    
    func updateView(model: ForecastWeatherViewModel) {
        collectionViewModels = model
        forecastTableView.reloadData()
    }
    
    func updateDetailedView(temperature: String, image: UIImage, description: String, time: String) {
        tempDetailedView.text = temperature + "°C"
        currentWeatherImageView.image = image
        weatherDescriptionLabel.text = description
        timeLabel.text = time
    }
    
    @objc private func hideView() {
        self.detailedWeatherView.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.blurView.layer.opacity = 0
            let transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.detailedWeatherView.transform = transform
        } completion: { _ in
            self.backView.isHidden = true
        }
    }
    func showView(){
        detailedWeatherСollectionView.reloadData()
        backView.isHidden = false
        
        let transform = CGAffineTransform(scaleX: 0, y: 0)
        detailedWeatherView.transform = transform
        blurView.layer.opacity = 0
        
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.blurView.layer.opacity = 1
            self.detailedWeatherView.transform = CGAffineTransform.identity
        }
    }
}

extension ForecastView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = Color.secondary
        header.textLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 25)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
        case 0:
            return numberOfRows.count
        case 1:
            return 8
        case 2:
            return 8
        case 3:
            return 8
        case 4:
            return 8
        case 5:
            return 8 - numberOfRows.count
        default:
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as? ForecastTableViewCell,
            let model = collectionViewModels else { return UITableViewCell() }
        
        cell.backgroundColor = Color.element
        cell.layer.borderColor = Color.main?.cgColor
        cell.layer.borderWidth = 4
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        cell.selectionStyle = .none
        
        if indexPath.section == 0{
            let link = model.collectionViewForHourModels[indexPath.row]
            cell.updateCell(
                temperature: link.temperature,
                image: link.image,
                description: link.description,
                time: link.hour)
            
        }else if indexPath.section == 1{
            let link = model.collectionViewForHourModels[indexPath.row + numberOfRows.count]
            cell.updateCell(
                temperature: link.temperature,
                image: link.image,
                description: link.description,
                time: link.hour)
            
        }else if indexPath.section == 2{
            let link = model.collectionViewForHourModels[indexPath.row + 8 + numberOfRows.count]
            cell.updateCell(
                temperature: link.temperature,
                image: link.image,
                description: link.description,
                time: link.hour)

        }else if indexPath.section == 3{
            let link = model.collectionViewForHourModels[indexPath.row + 16 + numberOfRows.count]
            cell.updateCell(
                temperature: link.temperature,
                image: link.image,
                description: link.description,
                time: link.hour)
            
        }else if indexPath.section == 4{
            let link = model.collectionViewForHourModels[indexPath.row + 24 + numberOfRows.count]
            cell.updateCell(
                temperature: link.temperature,
                image: link.image,
                description: link.description,
                time: link.hour)
            
        }else if indexPath.section == 5{
            let link = model.collectionViewForHourModels[indexPath.row + 32 + numberOfRows.count]
            cell.updateCell(
                temperature: link.temperature,
                image: link.image,
                description: link.description,
                time: link.hour)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if numberOfSections.count != 0 {
            switch section{
            case 0:
                return numberOfSections[0]
            case 1:
                return numberOfSections[1]
            case 2:
                return numberOfSections[2]
            case 3:
                return numberOfSections[3]
            case 4:
                return numberOfSections[4]
            case 5:
                return numberOfSections[5]
            default:
                return ""
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showView()
        
        guard let model = collectionViewModels else { return }
        
        if indexPath.section == 0{
            let link = model.collectionViewForHourModels[indexPath.row]
            updateDetailedView(temperature: link.temperature,
                               image: link.image,
                               description: link.description,
                               time: link.hour)
            dayOfTheWeekLabel.text = numberOfSections[0] + ","
            indexPathRow = indexPath.row
            
        }else if indexPath.section == 1{
            let link = model.collectionViewForHourModels[indexPath.row + numberOfRows.count]
            updateDetailedView(temperature: link.temperature,
                               image: link.image,
                               description: link.description,
                               time: link.hour)
            dayOfTheWeekLabel.text = numberOfSections[1] + ","
            indexPathRow = indexPath.row + numberOfRows.count
            
        }else if indexPath.section == 2{
            let link = model.collectionViewForHourModels[indexPath.row + 8 + numberOfRows.count]
            updateDetailedView(temperature: link.temperature,
                               image: link.image,
                               description: link.description,
                               time: link.hour)
            dayOfTheWeekLabel.text = numberOfSections[2] + ","
            indexPathRow = indexPath.row + numberOfRows.count + 8
            
        }else if indexPath.section == 3{
            let link = model.collectionViewForHourModels[indexPath.row + 16 + numberOfRows.count]
            
            updateDetailedView(temperature: link.temperature,
                               image: link.image,
                               description: link.description,
                               time: link.hour)
            dayOfTheWeekLabel.text = numberOfSections[3] + ","
            indexPathRow = indexPath.row + numberOfRows.count + 16
            
        }else if indexPath.section == 4{
            let link = model.collectionViewForHourModels[indexPath.row + 24 + numberOfRows.count]
            
            updateDetailedView(temperature: link.temperature,
                               image: link.image,
                               description: link.description,
                               time: link.hour)
            dayOfTheWeekLabel.text = numberOfSections[4] + ","
            indexPathRow = indexPath.row + numberOfRows.count + 24
            
        }else if indexPath.section == 5{
            let link = model.collectionViewForHourModels[indexPath.row + 32 + numberOfRows.count]
            
            updateDetailedView(temperature: link.temperature,
                               image: link.image,
                               description: link.description,
                               time: link.hour)
            dayOfTheWeekLabel.text = numberOfSections[5] + ","
            indexPathRow = indexPath.row + numberOfRows.count + 32
        }
    }
}

extension ForecastView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedWeatherCollectionViewCell.identifier, for: indexPath) as! DetailedWeatherCollectionViewCell
        
        switch indexPath.row {
        case 0:
            let link = collectionViewModels?.collectionViewForHourModels[indexPathRow]
            cell.label.text = link?.pressure
            cell.imageView.image = UIImage(systemName: "thermometer")
        case 1:
            let link = collectionViewModels?.collectionViewForHourModels[indexPathRow]
            cell.label.text = link?.humidity
            cell.imageView.image = UIImage(systemName: "humidity")
        case 2:
            let link = collectionViewModels?.collectionViewForHourModels[indexPathRow]
            cell.label.text = link?.visibility
            cell.imageView.image = UIImage(systemName: "eye.fill")
        case 3:
            let link = collectionViewModels?.collectionViewForHourModels[indexPathRow]
            cell.label.text = link?.feelsLike
            cell.imageView.image = UIImage(systemName: "figure.stand")
        case 4:
            let link = collectionViewModels?.collectionViewForHourModels[indexPathRow]
            cell.label.text = link?.windiness
            cell.imageView.image = UIImage(systemName: "wind")
        default:
            cell.label.text = "111"
        }
        
        return cell
    }
}

