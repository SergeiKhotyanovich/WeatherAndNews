
import Foundation

import Foundation

protocol TabBarPresenterProtocol: AnyObject {
    init(view: TabBarViewControllerProtocol)
}

final class TabBarPresenter: TabBarPresenterProtocol {
    
    var view: TabBarViewControllerProtocol?
    
    init(view: TabBarViewControllerProtocol) {
        self.view = view
    }
}
