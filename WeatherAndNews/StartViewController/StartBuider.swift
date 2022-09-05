
import Foundation

final class StartBuilder{
    static func build() -> StartViewCotroller{
        let view = StartViewCotroller()
        let presenter = startPresenter(view: view)
        
        view.presenter = presenter
        return view
    }
    
    
    
}
