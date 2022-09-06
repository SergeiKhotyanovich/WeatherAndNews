
import UIKit

extension UIView{
    func addSubviews(_ array: [UIView]){
        array.forEach{
            addSubview($0)
        }
    }
    
}

