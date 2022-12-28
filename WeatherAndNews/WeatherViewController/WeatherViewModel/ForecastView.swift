//
//  ForecastView.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 16.10.22.
//

import SnapKit
import UIKit

class ForecastView: UIView {
    
    private var forecastTableView = UITableView(frame: .zero, style: .grouped)
    private var collectionViewModels: ForecastWeatherViewModel?
    private var numberOfSections: [String] = []
    private var numberOfRows: [Int] = []
    private var indexPathRow = 0
    private var indexPathSection = 0
    private let heightForRowAt = CGFloat(80)
    
    private var backgroundView = UIView()
    private var detailedWeatherView = UIView()
    
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
        addSubviews([
            forecastTableView,
            backgroundView
        ])
        
        backgroundView.addSubviews([
            blurView,
            detailedWeatherView,
        ])
        detailedWeatherView.addSubviews([
            tempDetailedView, dayOfTheWeekLabel,
            weatherDescriptionLabel, currentWeatherImageView,
            timeLabel, detailedWeatherСollectionView
        ])
        
        blurView.frame = bounds
        forecastTableView.showsVerticalScrollIndicator = false
        backgroundView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
        blurView.addGestureRecognizer(tap)
    }
    
    func setupCollectionsSetting() {
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        detailedWeatherСollectionView.delegate = self
        detailedWeatherСollectionView.dataSource = self
    }
    
    //MARK: SetupLayout
    
    func setupLayout() {
        forecastTableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
        }
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        detailedWeatherView.snp.makeConstraints { make in
            make.height.equalTo(self.frame.width )
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        currentWeatherImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(8)
            make.right.equalTo(backgroundView.snp.centerX)
            make.height.equalTo((backgroundView.frame.width - 16) / 2)
        }
        tempDetailedView.snp.makeConstraints { make in
            make.left.equalTo(backgroundView.snp.centerX)
            make.right.equalToSuperview().inset(16)
            make.top.right.equalToSuperview()
            make.bottom.equalTo(currentWeatherImageView.snp.bottom).inset(40)
        }
        
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(tempDetailedView.snp.bottom).inset(16)
            make.left.equalTo(backgroundView.snp.centerX).offset(16)
            make.bottom.equalTo(currentWeatherImageView.snp.bottom)
            make.right.equalToSuperview().inset(16)
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
    
    //MARK: SetupStyle
    
    func setupStyle() {
        setupTableViewStyle()
        setupDetailedWeatherViewStyle()
    }
    
    func setupTableViewStyle() {
        forecastTableView.backgroundColor = UIColor(named: "main")
    }
    
    func setupDetailedWeatherViewStyle() {
        detailedWeatherView.layer.cornerRadius = 10
        detailedWeatherView.backgroundColor = Color.main
    }
    
    //MARK: SetupFunc
    
    func updateSectionCount(sectionsCount:[String], rowsCount: [Int]) {
        numberOfSections = sectionsCount
        numberOfRows = rowsCount
        
    }
    
    func updateView(model: ForecastWeatherViewModel) {
        collectionViewModels = model
        forecastTableView.reloadData()
    }
    
    func updateDetailedView(forecastModel: ForecastForHourCollectionViewModel, dayModel: String) {
        tempDetailedView.text = forecastModel.temperature + "°C"
        currentWeatherImageView.image = forecastModel.image
        weatherDescriptionLabel.text = forecastModel.description
        timeLabel.text = forecastModel.hour
        dayOfTheWeekLabel.text = dayModel
    }
    
    @objc private func hideView() {
        self.detailedWeatherView.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.blurView.layer.opacity = 0
            let transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.detailedWeatherView.transform = transform
        } completion: { _ in
            self.backgroundView.isHidden = true
        }
    }
    func showView(){
        detailedWeatherСollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        detailedWeatherСollectionView.reloadData()
        backgroundView.isHidden = false
        
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
            return numberOfRows[0]
        case 1:
            return numberOfRows[1]
        case 2:
            return numberOfRows[2]
        case 3:
            return numberOfRows[3]
        case 4:
            return numberOfRows[4]
        case 5:
            return numberOfRows[5]
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
            let model = collectionViewModels?.collectionViewForHourModels else { return UITableViewCell() }
        
        cell.backgroundColor = Color.element
        cell.layer.borderColor = Color.main?.cgColor
        cell.layer.borderWidth = 4
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            cell.updateCell(model: model[0][indexPath.row])
        case 1:
            cell.updateCell(model: model[1][indexPath.row])
        case 2:
            cell.updateCell(model: model[2][indexPath.row])
        case 3:
            cell.updateCell(model: model[3][indexPath.row])
        case 4:
            cell.updateCell(model: model[4][indexPath.row])
        case 5:
            cell.updateCell(model: model[5][indexPath.row])
        
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowAt
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
        
        guard let forecastModel = collectionViewModels?.collectionViewForHourModels else { return }
        
        
        switch indexPath.section {
        case 0:
            updateDetailedView(forecastModel: forecastModel[0][indexPath.row], dayModel: numberOfSections[indexPath.section])
            indexPathRow = indexPath.row
            indexPathSection = indexPath.section
        case 1:
            updateDetailedView(forecastModel: forecastModel[1][indexPath.row], dayModel: numberOfSections[indexPath.section])
            indexPathRow = indexPath.row
            indexPathSection = indexPath.section
        case 2:
            updateDetailedView(forecastModel: forecastModel[2][indexPath.row], dayModel: numberOfSections[indexPath.section])
            indexPathRow = indexPath.row
            indexPathSection = indexPath.section
        case 3:
            updateDetailedView(forecastModel: forecastModel[3][indexPath.row], dayModel: numberOfSections[indexPath.section])
            indexPathRow = indexPath.row
            indexPathSection = indexPath.section
        case 4:
            updateDetailedView(forecastModel: forecastModel[4][indexPath.row], dayModel: numberOfSections[indexPath.section])
            indexPathRow = indexPath.row
            indexPathSection = indexPath.section
        case 5:
            updateDetailedView(forecastModel: forecastModel[5][indexPath.row], dayModel: numberOfSections[indexPath.section])
            indexPathRow = indexPath.row
            indexPathSection = indexPath.section
        default:
            updateDetailedView(forecastModel: forecastModel[5][indexPath.row], dayModel: numberOfSections[indexPath.section])
        }
        

        }
}

extension ForecastView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedWeatherCollectionViewCell.identifier, for: indexPath) as! DetailedWeatherCollectionViewCell
        if let model = collectionViewModels?.collectionViewForHourModels {

        switch indexPath.row {
        case 0:
            cell.label.text = model[indexPathSection][indexPathRow].humidity
            cell.imageView.image = WeatherImages.humidity
        case 1:
            cell.label.text = model[indexPathSection][indexPathRow].windiness
            cell.imageView.image = WeatherImages.windSpeed
        case 2:
            cell.label.text = model[indexPathSection][indexPathRow].visibility
            cell.imageView.image = WeatherImages.visibility
        case 3:
            cell.label.text = model[indexPathSection][indexPathRow].feelsLike
            cell.imageView.image = WeatherImages.feelsLike
        case 4:
            cell.label.text = model[indexPathSection][indexPathRow].pressure
            cell.imageView.image = WeatherImages.pressure
        default:
            cell.label.text = "111"
            }
        }
        return cell
    }
}

