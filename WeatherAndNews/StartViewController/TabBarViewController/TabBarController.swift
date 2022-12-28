
import UIKit
import SnapKit

protocol TabBarViewControllerProtocol: AnyObject {
}

class TabBarViewController: UITabBarController, TabBarViewControllerProtocol {
    var presenter: TabBarPresenterProtocol!
    
    let weatherViewColtrollew = WeatherBuilder.build()
    let mapViewController = MapViewController()
    let notificationCenter = NotificationCenter.default
    private let degreesLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: STYLE
    
    func setupUI(){
        self.setViewControllers([weatherViewColtrollew,
                                 mapViewController
                                ],
                                animated: true)
        view.addSubviews([
            degreesLabel
        ])
        
        styleTabBar()
        view.backgroundColor = Color.main
        
        notificationCenter.addObserver(self,
                                       selector: #selector(mapWeatherButtonPressed) ,
                                       name: NSNotification.Name.mapViewWeatherLocation,
                                       object: nil)
    }
    
    @objc func mapWeatherButtonPressed() {
        
        self.selectedIndex = 0
        if weatherViewColtrollew.currentView.isHidden {
            weatherViewColtrollew.pageControll.selectedSegmentIndex = 0
            weatherViewColtrollew.currentView.isHidden = false
            weatherViewColtrollew.forecastView.isHidden = true
        }
    }
    
    func styleTabBar(){
        weatherViewColtrollew.title = "Weather"
        mapViewController.title = "Map"
        
        guard let items = self.tabBar.items else {return}
        let images = ["cloud.sun.fill", "map"]
        
        for i in 0...1{
            items[i].image = UIImage(systemName: images[i])
        }
        
        self.tabBar.backgroundColor = UIColor(named: "element")
        self.tabBar.tintColor = UIColor(named: "secondary")
        self.tabBar.unselectedItemTintColor = UIColor(named: "setTitleColor")
    }
}
