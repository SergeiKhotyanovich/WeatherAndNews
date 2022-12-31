//
//  SearchView.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 25.10.22.
//

import Foundation
import UIKit


class SearchView: UIView {
    
    var updateSearchButton = UIButton(type: .system)
    var searchTextField = UITextField()
    var cityArray = ["Moskow", "Minsk", "Batumi", "Dubai", "Paris", "Istanbul", "New York", "Seoul", "Bangkok", "Milan", "Vein", "Prague", "Tokyo", "Delhi", "Shanghai", "Dhaka", "Sao Paulo", "Mexico City", "Cairo", "Beijing", "Mumbai", "Osaka", "Chongqing", "Karachi", "Istanbul", "Kinshasa", "Lagos", "", "Buenos Aires", "Kolkata", "Manila", "Tianjin", "Guangzhou", "Rio De Janeiro", "Lahore", "Bangalore", "Shenzhen", "Chennai", "Bogota", "Jakarta", "Lima", "Bangkok", "Hyderabad", "Seoul", "Nagoya", "Chengdu", "Hong Kong", "Toronto", "Singapore", "Barcelona"]
    var sortedCityArray:[String] = []
    
    let sortedCityTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.allowsSelection = true
        view.showsVerticalScrollIndicator = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        return view
    }()
    
    let popularCitiesCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Color.element
        button.setTitle("Close", for: .normal)
        button.setTitleColor(Color.secondary, for: .normal)
        button.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 20)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupStyle()
        setupCollectionsSetting()
        
        searchTextField.addTarget(self, action: #selector(sortCityArray), for: .allEvents)
        
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
            sortedCityTableView,
            searchTextField,
            updateSearchButton,
            popularCitiesCollectionView,
            closeButton
            
        ])
        popularCitiesCollectionView.backgroundColor = .clear
        sortedCityTableView.backgroundColor = Color.main
    }
    
    func setupCollectionsSetting() {
        popularCitiesCollectionView.delegate = self
        popularCitiesCollectionView.dataSource = self
        sortedCityTableView.delegate = self
        sortedCityTableView.dataSource = self
    }
    
    //MARK: LAYOUT
    
    func setupLayout() {
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(46)
            make.left.equalToSuperview().inset(60)
            make.right.equalToSuperview().inset(90)
            make.height.equalTo(40)
        }
        updateSearchButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalTo(searchTextField.snp.right).offset(10)
            make.right.equalToSuperview().inset(45)
            make.height.equalTo(40)
        }
        popularCitiesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom)
            make.right.left.equalTo(self).inset(20)
            make.height.equalTo(45)
        }
        sortedCityTableView.snp.makeConstraints { make in
            make.top.equalTo(popularCitiesCollectionView.snp.bottom)
            make.right.left.equalToSuperview().inset(8)
            make.bottom.equalTo(closeButton.snp.top)
        }
        closeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(self.frame.height/12)
        }
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(
            width: 100,
            height: 70
        )
        layout.minimumLineSpacing = 3
        popularCitiesCollectionView.collectionViewLayout = layout
    }
    
    //MARK: Setuping Style
    
    func setupStyle() {
        updateSearchTextFieldStyle()
        updateSearchButtonStyle()
    }
    
    func updateSearchTextFieldStyle() {
        searchTextField.placeholder = " Enter city"
        searchTextField.layer.borderWidth = 1.5
        searchTextField.layer.borderColor = Color.secondary?.cgColor
        searchTextField.layer.cornerRadius = 15
        searchTextField.textColor = Color.secondary
        searchTextField.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        searchTextField.leftViewMode = UITextField.ViewMode.always
        searchTextField.leftView = spacerView
        searchTextField.clearButtonMode = .always
    }
    
    func updateSearchButtonStyle() {
        updateSearchButton.contentVerticalAlignment = .fill
        updateSearchButton.contentHorizontalAlignment = .fill
        updateSearchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        updateSearchButton.tintColor = Color.secondary
    }
    
    @objc func sortCityArray() {
        sortedCityArray = cityArray.filter({ (mod) -> Bool in
            return mod.lowercased().contains(searchTextField.text!.lowercased())
        })
        sortedCityTableView.reloadData()
    }
}

//MARK: extension SearchView

extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PreservationOfPopularCities.shared.popularCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = popularCitiesCollectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        
        cell.label.text = PreservationOfPopularCities.shared.popularCities[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchTextField.text = PreservationOfPopularCities.shared.popularCities[indexPath.row]
    }
}

extension SearchView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedCityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        cell.backgroundColor = Color.element
        cell.layer.borderColor = Color.main?.cgColor
        cell.textLabel?.textColor = Color.secondary
        cell.textLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        cell.selectionStyle = .none
        cell.layer.borderWidth = 4
        cell.layer.cornerRadius = 15
        
        cell.textLabel?.text = sortedCityArray[indexPath.row]
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextField.text = sortedCityArray[indexPath.row]
    }
    
    
    
    
}

