

import UIKit

final class LoadingBuilder {
    static func build() -> LoadingViewController {
        let view = LoadingViewController()
        let presenter = LoadingPresenter(view: view)
        
        view.presenter = presenter
        
        return view
    }
    
}

