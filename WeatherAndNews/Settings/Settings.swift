
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

class UserTemperature {
    static let shared = UserTemperature()
    
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

class UserLanguage {
    static let shared = UserLanguage()
    
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

class UserTheme {
    static let shared = UserTheme()
    
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

