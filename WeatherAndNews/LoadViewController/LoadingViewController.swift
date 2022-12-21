
import SnapKit
import UIKit

protocol LoadingViewControllerProtocol: AnyObject {
    
}

class LoadingViewController: UIViewController, LoadingViewControllerProtocol {
    var presenter: LoadingPresenterProtocol!
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MarkerFelt-Thin", size: 50)
        label.text = "Weather"
        label.textAlignment = .center
        label.textColor = Color.secondary
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews([
            logoLabel
        ])
        view.backgroundColor = Color.main
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimation()
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0.8) {
            self.logoLabel.alpha = 0
        } completion: { _ in
            let vc = TabBarBuilder.build()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
        }
    }
    

    
    //MARK: LAYOUT
    
    func setupLayout() {
        
        logoLabel.snp.makeConstraints { make in
            make.center.equalTo(view.center)
     

        }
    }
    


}
