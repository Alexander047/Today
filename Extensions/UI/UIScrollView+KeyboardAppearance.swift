import UIKit

extension UIScrollView {

    @objc func didChangeKeyboardFrame(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }

        let keyboardTopY = UIScreen.main.bounds.height - endFrame.origin.y + 44
        contentInset.bottom = keyboardTopY.isNormal ? keyboardTopY : .zero
    }
}
