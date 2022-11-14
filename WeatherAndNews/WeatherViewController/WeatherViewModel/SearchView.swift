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
    let popularCitiesModel = [
        "Moscow", "Delhi", "Pattaya", "Beijing",
        "Toronto", "Jerusalem", "London", "Honolulu",
        "Sydney"
    ]
    
    private let popularCitiesCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([
            searchTextField,updateSearchButton, popularCitiesCollectionView
        ])
        
        setupStyle()
        
        popularCitiesCollectionView.delegate = self
        popularCitiesCollectionView.dataSource = self
        popularCitiesCollectionView.backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
        setupCollectionViewLayout()
    }
    
    //MARK: LAYOUT
    
    func setupLayout() {
        
        searchTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(60)
            make.right.equalToSuperview().inset(90)
        }
        updateSearchButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(50)
            make.left.equalTo(searchTextField.snp.right).offset(10)
            make.right.equalToSuperview().inset(45)
        }
        popularCitiesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom)
            make.right.left.equalTo(self).inset(20)
            make.bottom.equalTo(self)
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
}

//MARK: extension SearchView

extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularCitiesModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = popularCitiesCollectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        
        cell.label.text = popularCitiesModel[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchTextField.text = popularCitiesModel[indexPath.row]
    }
    

    
}

