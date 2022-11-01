////
////  DetailedForecastView.swift
////  WeatherAndNews
////
////  Created by Сергей Хотянович on 31.10.22.
////
//
//import Foundation
//import UIKit
//
//
//class DetailedForecastView: UIView {
//    
//    static let scared = DetailedForecastView()
//    
//    var detailedWeatherView = UIView()
//    
//    private let blurView: UIVisualEffectView = {
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        return blurEffectView
//    }()
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        addSubviews([
//            blurView, detailedWeatherView
//        ])
//        
//        blurView.frame = bounds
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
//        self.addGestureRecognizer(tap)
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setupLayout()
//        setupStyle()
//    }
//    
//    //MARK: Setuping Layout
//    
//    func setupLayout() {
//        detailedWeatherView.snp.makeConstraints { make in
//            make.height.equalTo(self.frame.width )
//            make.center.equalToSuperview()
//            make.left.right.equalToSuperview().inset(16)
//        }
//        detailedWeatherView.layoutIfNeeded()
//    }
//    
//    func setupStyle() {
//        detailedWeatherViewStyle()
//    }
//    
//    func detailedWeatherViewStyle() {
//        detailedWeatherView.layer.cornerRadius = 10
//        detailedWeatherView.backgroundColor = Color.element
//    }
//    
//    //MARK: Setuping Func
//    
//    @objc private func hideView() {
//        self.detailedWeatherView.transform = CGAffineTransform.identity
//        UIView.animate(withDuration: 0.2, delay: 0) {
//            self.blurView.layer.opacity = 0
//            let transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//            self.detailedWeatherView.transform = transform
//        } completion: { _ in
//                        self.isHidden = true
//        }
//    }
//     func showView(){
//         
//         isHidden = false
//        
//        let transform = CGAffineTransform(scaleX: 0, y: 0)
//        detailedWeatherView.transform = transform
//        blurView.layer.opacity = 0
//
//        UIView.animate(withDuration: 0.2, delay: 0) {
//            self.blurView.layer.opacity = 1
//            self.detailedWeatherView.transform = CGAffineTransform.identity
//        }
//    }
//}
