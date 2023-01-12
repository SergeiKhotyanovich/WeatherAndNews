
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

class UserTemperaturePreservation {
    static let shared = UserTemperaturePreservation()
    
    enum userTemperatureSelection: String {
        case fahrenheit = "imperial"
        case celsius = "metric"
    }
    
    var userTemperature: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "UserTemperature")
        }
        get {
            guard let value = UserDefaults.standard.object(forKey: "UserTemperature") as? String else { return "" }
            
            return value
        }
    }
}

class UserLanguagePreservation {
    static let shared = UserLanguagePreservation()
    
    enum userLanguageSelection: String {
        case ru = "ru"
        case en = "en"
    }
    
    var userLanguage: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "UserLanguage")
        }
        get {
            guard let value = UserDefaults.standard.object(forKey: "UserLanguage") as? String else { return "" }
            
            return value
        }
    }
}

class UserThemePreservation {
    static let shared = UserThemePreservation()
    
    enum userThemeSelection: String {
        case light = "light"
        case dark = "dark"
    }
    
    var userTheme: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "UserTheme")
        }
        get {
            guard let value = UserDefaults.standard.object(forKey: "UserTheme") as? String else { return "" }
            
            return value
        }
    }
}

