
import UIKit

extension UIImage {
    static func systemNamed(_ name: String) -> UIImage {
        if let image = UIImage(systemName: name) {
            return image
        } else {
            fatalError("Could not initialize \(UIImage.self) named \(name).")
        }
    }
}

