

import UIKit
import SnapKit

protocol startViewCotrollerProtocol: AnyObject {
    func routeToNextVC()
}

class StartViewCotroller: UIViewController, startViewCotrollerProtocol {
    
    let buttonWeather = UIButton()
    let buttonNews = UIButton()
    
    public var presenter: startPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubviews([buttonWeather,buttonNews])
        
        setupLayout()
        setupStyle()
        
        view.backgroundColor = Color.main
        buttonWeather.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    //MARK: FUNC
    
    func routeToNextVC() {
        let vc = TabBarViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonPressed() {
        presenter.fetchButtonPressed()
    }

    //MARK: LAYOUT
    
    func setupLayout() {
        buttonWeatherLayout()
        buttonNewsLayuot()
    }

    func buttonWeatherLayout(){
        buttonWeather.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([
            buttonWeather.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width/2 - view.frame.width/5),
            buttonWeather.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width/2 + view.frame.width/5),
            buttonWeather.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/3 )
        ])
    }
    
    func buttonNewsLayuot() {
        buttonNews.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([
            buttonNews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width/2 - view.frame.width/5),
            buttonNews.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width/2 + view.frame.width/5),
            buttonNews.topAnchor.constraint(equalTo: buttonWeather.bottomAnchor, constant: view.frame.height/10 )
        ])
    }
    
    //MARK: STYLE
    
    func setupStyle() {
        buttonWeatherStyle()
        buttonNewsStyle()
    }
    
    func buttonStyle(text:String, button:UIButton) {
        button.backgroundColor = Color.secondary
        button.setTitle(text, for: .normal)
        button.layer.cornerRadius = 8
        button.setTitleColor(Color.setTitleColor, for: .normal)
    }
    
    func buttonWeatherStyle(){
        buttonStyle(text: "Log in", button: buttonWeather)
    }
    
    func buttonNewsStyle(){
        buttonStyle(text: "Log out", button: buttonNews)
    }
    


    

}

