/*
import UIKit

final class SwipeBackNavigationController: UINavigationController,
                                          UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // ❌ Disable swipe on Home (root)
        return viewControllers.count > 1
    }
}*/
