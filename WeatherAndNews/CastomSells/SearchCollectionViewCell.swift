//
//  SearchCollectionViewCell.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 25.10.22.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchCollectionViewCell"
    
    let backView: UIView = {

        let view = UIView()
        view.backgroundColor = Color.element
        view.layer.cornerRadius = 10
        return view
    }()
    
    var label: UILabel = {
       let label = UILabel()
       label.text = "23C"
       label.textAlignment = .center
       label.textColor = Color.secondary
       label.font = UIFont(name: "MarkerFelt-Wide", size: 20)
       label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
       return label
   }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews([backView])
        
        backView.addSubviews([
            label
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        backView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.right.left.equalToSuperview()
        }
    }
}
