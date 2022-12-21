
import Foundation

final class TabBarBuilder {
    static func build() -> TabBarViewController {
        let view = TabBarViewController()
        let presenter = TabBarPresenter(view: view)
        view.presenter = presenter
        
        let _ = WeatherBuilder.build()
        let _ = MapBuilder.build()
        return view
    }
}
