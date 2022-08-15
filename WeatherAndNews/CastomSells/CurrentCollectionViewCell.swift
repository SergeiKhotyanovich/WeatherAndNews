//
//  CollectionViewCell.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 5.04.22.
//

import UIKit
import SnapKit

class CurrentCollectionViewCell: UICollectionViewCell {
    static let identifier = "CurrentCollectionViewCell"
    
     let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "sun.max")
        imageView.tintColor = Color.secondary
            return imageView
    }()
    
     var label: UILabel = {
        let label = UILabel()
        label.text = "23C"
        label.textAlignment = .center
        label.textColor = Color.secondary
        label.font = UIFont(name: "MarkerFelt-Wide", size: 30)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.element
        view.layer.cornerRadius = 15
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backView)
        backView.addSubviews([imageView,label])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.height.equalTo(contentView.frame.width/1.5)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
  

    }
}
