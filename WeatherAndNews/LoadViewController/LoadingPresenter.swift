
import Foundation

protocol LoadingPresenterProtocol: AnyObject {
    init(view: LoadingViewControllerProtocol)
}

final class LoadingPresenter: LoadingPresenterProtocol {
    private weak var view: LoadingViewControllerProtocol?
    
    init(view: LoadingViewControllerProtocol) {
        self.view = view
    }
}
