//
//  ForecastView.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 16.10.22.
//

import SnapKit
import UIKit

class ForecastView: UIView {
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    var collectionViewModels: ForecastWeatherViewModel?
    var numberOfSections: [String] = []
    var numberOfRows: [String] = []
    
    var backView = UIView()
    var detailedWeatherView = UIView()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    private var currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "23°"
        label.textAlignment = .center
        label.textColor = Color.secondary
        label.font = UIFont(name: "MarkerFelt-Wide", size: 200)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()

    private var dayLabel: UILabel = {
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([
            tableView,
            backView
        ])
        
        backView.addSubviews([
            blurView,
            detailedWeatherView,
        ])
        detailedWeatherView.addSubviews([
            currentTemperatureLabel, dayLabel,
            weatherDescriptionLabel, currentWeatherImageView,
            timeLabel
        ])
        
        blurView.frame = bounds
        setupStyle()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
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
    }
    
    //MARK: Setuping Layout
    
    func setupLayout() {
        tableView.snp.makeConstraints { make in
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
        currentTemperatureLabel.snp.makeConstraints { make in
            make.left.equalTo(backView.snp.centerX)
            make.top.right.equalToSuperview()
            make.bottom.equalTo(currentWeatherImageView.snp.bottom).inset(40)
        }
        
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(currentTemperatureLabel.snp.bottom).inset(16)
            make.left.equalTo(backView.snp.centerX).offset(16)
            make.bottom.equalTo(currentWeatherImageView.snp.bottom)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherImageView.snp.bottom)
            make.left.equalToSuperview().inset(16)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherImageView.snp.bottom)
            make.left.equalTo(dayLabel.snp.right)
        }
    }
    
    //MARK: Setuping Style
    
    func setupStyle() {
        tableViewStyle()
        detailedWeatherViewStyle()
    }
    
    func tableViewStyle() {
        tableView.backgroundColor = UIColor(named: "main")
    }
    
    func detailedWeatherViewStyle() {
        detailedWeatherView.layer.cornerRadius = 10
        detailedWeatherView.backgroundColor = Color.element
    }
    
    
    //MARK: Setuping Func
    
    func updateSectionCount(sectionsCount:[String], rowsCount: [String]) {
        numberOfSections = sectionsCount
        numberOfRows = rowsCount
        
    }
    
    func updateView(model: ForecastWeatherViewModel) {
        collectionViewModels = model
        tableView.reloadData()
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
    }
}

