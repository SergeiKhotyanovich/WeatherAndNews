
import UIKit

enum Color {
    static let main = UIColor(named: "main")
    static let secondary = UIColor(named: "secondary")
    static let setTitleColor = UIColor(named: "")
    static let element = UIColor(named: "element")
}

class PreservationOfPopularCities {
    static let shared = PreservationOfPopularCities()
    
    var popularCities: [String] {
        set {
            UserDefaults.standard.set(newValue, forKey: "PreservationOfPopularCities")
        }
        get {
            guard let value = UserDefaults.standard.object(forKey: "PreservationOfPopularCities") as? [String] else { return [] }
            
            return value
        }
        
    }
    
}

