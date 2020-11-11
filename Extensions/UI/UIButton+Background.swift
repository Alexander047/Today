import UIKit

public extension UIButton {

    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        if let color = color {
            self.setBackgroundImage(UIImage(color), for: state)
        }
    }
}
