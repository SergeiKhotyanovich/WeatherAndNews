//
//  DetailedWeatherCollectionViewCell.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 2.11.22.
//

import UIKit

class DetailedWeatherCollectionViewCell: UICollectionViewCell {
   static let identifier = "DetailedWeatherCollectionViewCell"
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "thermometer")
        imageView.tintColor = Color.secondary
        imageView.contentMode = .scaleAspectFit
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

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.element
        view.layer.cornerRadius = 15
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .clear
        contentView.addSubview(backView)

        backView.addSubviews([imageView, label])
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
            make.centerX.equalToSuperview()
            make.height.width.equalTo(frame.width / 2)
            make.top.equalToSuperview().inset(8)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

//    func updateCellWith(model: ForecastForHourCollectionViewModel, indexPath: Int) {
//        switch indexPath {
//        case 0:
//            label.text = model[indexPathRow].humidity
//            imageView.image = UIImage(systemName: "humidity")
//        case 1:
//            label.text = model[1][indexPathRow].windiness
//            imageView.image = UIImage(systemName: "wind")
//        case 2:
//            label.text = model[2][indexPathRow].visibility
//            imageView.image = UIImage(systemName: "eye.fill")
//        case 3:
//            label.text = model[3][indexPathRow].feelsLike
//            imageView.image = UIImage(systemName: "figure.stand")
//        case 4:
//            label.text = model[4][indexPathRow].pressure
//            imageView.image = UIImage(systemName: "figure.stand")
//        default:
//            label.text = "111"
//            }
//        }
//            
        }

