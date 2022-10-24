//
//  ForecastView.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 16.10.22.
//

import Foundation
import UIKit


class ForecastView: UIView {

    var tableView = UITableView(frame: .zero, style: .grouped)
    var collectionViewModels: ForecastWeatherViewModel?
    var numberOfSections: [String] = []
    var numberOfRows: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([tableView])
        setupStyle()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
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
    }
    
    //MARK: Setuping Style
    
    func setupStyle() {
        tableViewStyle()
    }
    
    func tableViewStyle() {
        tableView.backgroundColor = UIColor(named: "main")
    }
    
    func updateSectionCount(sectionsCount:[String], rowsCount: [String]) {
        numberOfSections = sectionsCount
        numberOfRows = rowsCount
        
    }
    
    func updateView(model: ForecastWeatherViewModel) {
        collectionViewModels = model
        tableView.reloadData()
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
}
