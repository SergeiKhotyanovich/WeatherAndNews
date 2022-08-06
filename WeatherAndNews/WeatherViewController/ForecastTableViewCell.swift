//
//  ForecastTableViewCell.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 4.08.22.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    static let identifier = "ForecastTableViewCell"
    
    let imageViewForecast: UIImageView = {
       let imageView = UIImageView()
       imageView.image = UIImage(systemName: "sun.max")
           return imageView
   }()
    
    var labelTime: UILabel = {
       let label = UILabel()
       label.text = "23C"
       label.textAlignment = .center
       label.textColor = Color.secondary
       label.font = UIFont(name: "MarkerFelt-Wide", size: 30)
       label.adjustsFontSizeToFitWidth = true
       label.minimumScaleFactor = 0.2
       return label
   }()
    
    var labelWeather: UILabel = {
       let label = UILabel()
       label.text = "23C"
       label.textAlignment = .center
       label.textColor = Color.secondary
       label.font = UIFont(name: "MarkerFelt-Wide", size: 30)
       label.adjustsFontSizeToFitWidth = true
       label.minimumScaleFactor = 0.2
       return label
   }()
    
    var labelTemp: UILabel = {
       let label = UILabel()
       label.text = "23C"
       label.textAlignment = .center
       label.textColor = Color.secondary
       label.font = UIFont(name: "MarkerFelt-Wide", size: 30)
       label.adjustsFontSizeToFitWidth = true
       label.minimumScaleFactor = 0.2
       return label
   }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Color.main
        contentView.addSubviews([imageViewForecast, labelTime,labelWeather,labelTemp])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        imageViewForecast.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.right.equalTo(contentView.snp.centerX)
            make.width.height.equalTo(contentView.frame.width/10)
        }
    }
    
}
