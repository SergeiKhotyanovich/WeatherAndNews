//
//  WeatherViewController.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 27.03.22.
//

import UIKit
import SnapKit

class TabBarViewController: UITabBarController {
    
    let weatherViewColtrollew = WeatherBuilder.build()
    let newsViewController = NewsViewController()
    let mapViewController = MapViewController()
    let degreesLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers([weatherViewColtrollew,newsViewController,mapViewController], animated: true)
        view.addSubviews([degreesLabel])
        
        setupStyle()
        view.backgroundColor = Color.main
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: LAYOUT
    

    
    //MARK: STYLE
    
    func setupStyle(){
        
        styleTabBar()
    }
    
    func styleTabBar(){
        weatherViewColtrollew.title = "Weather"
        newsViewController.title = "News"
        mapViewController.title = "Map"
        
        guard let items = self.tabBar.items else {return}
        let images = ["cloud.sun.fill", "newspaper", "map"]
        
        for i in 0...2{
            items[i].image = UIImage(systemName: images[i])
        }
        
        self.tabBar.backgroundColor = UIColor(named: "element")
        self.tabBar.tintColor = UIColor(named: "secondary")
        self.tabBar.unselectedItemTintColor = UIColor(named: "setTitleColor")
    }
}
