
import UIKit

class ForecastTableViewCell: UITableViewCell {
    static let identifier = "ForecastTableViewCell"
    
    let imageViewForecast: UIImageView = {
       let imageView = UIImageView()
       imageView.image = UIImage(systemName: "sun.max")
        imageView.tintColor = Color.secondary
           return imageView
   }()
    
    var labelTime: UILabel = {
       let label = UILabel()
       label.text = "18:00"
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
       label.font = UIFont(name: "MarkerFelt-Wide", size: 50)
       label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
       return label
   }()
    
    var labelDescriptions: UILabel = {
       let label = UILabel()
       label.numberOfLines = 2
       label.text = "Облачно"
       label.textAlignment = .center
       label.textColor = Color.secondary
       label.font = UIFont(name: "MarkerFelt-Wide", size: 30)
       label.adjustsFontSizeToFitWidth = true
       label.minimumScaleFactor = 0.2
       return label
   }()
    
    private var collectionViewModels: [ForecastForHourCollectionViewModel]?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews([imageViewForecast, labelTime,labelWeather,labelTemp,labelDescriptions])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            
        imageViewForecast.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(7)
            make.left.equalToSuperview().inset(7)
            make.width.equalTo(contentView.frame.width/4.6)
        }
        
        labelTemp.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            
        }
        
        labelTime.snp.makeConstraints { make in
            make.left.equalTo(imageViewForecast.snp.right).offset(30)
            make.top.equalToSuperview()
        }
        
        labelDescriptions.snp.makeConstraints { make in
            make.left.equalTo(imageViewForecast.snp.right).offset(5)
            make.bottom.equalToSuperview().inset(5)
            make.top.equalTo(labelTemp).inset(30)
            make.right.equalTo(labelTemp.snp.left).inset(-5)
            
        }
    }
    
    func updateCell(temperature: String, image: UIImage, description: String, time: String) {
        labelTemp.text = temperature + "°C"
        imageViewForecast.image = image
        labelDescriptions.text = description
        labelTime.text = time
    }
}


