
import UIKit

public final class CustomScreenProtectorKit {

    
    private weak var window: UIWindow?
    private weak var originalRootView: UIView?
    private var secureTextField: UITextField?
    private var secureContainer: UIView?
    private var overlayView: UIView?

    public init(window: UIWindow?) {
        self.window = window
    }

    // MARK: - Enable Protection
    public func enable() {

        guard
            secureTextField == nil,
            let window = window,
            let rootView = window.rootViewController?.view
        else { return }

        originalRootView = rootView

        let textField = UITextField(frame: rootView.bounds)
        textField.isSecureTextEntry = true
        textField.isUserInteractionEnabled = false
        textField.backgroundColor = .clear

        guard let secureView = textField.subviews.first else { return }

        secureView.frame = rootView.bounds
        secureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Move root view safely
        rootView.removeFromSuperview()
        secureView.addSubview(rootView)
        window.addSubview(secureView)

        secureTextField = textField
        secureContainer = secureView

        setupOverlay()
    }

    // MARK: - Disable Protection
    public func disable() {

        DispatchQueue.main.async {

            guard
                let window = self.window,
                let rootView = self.originalRootView,
                let secureContainer = self.secureContainer
            else { return }

            // Restore root view
            rootView.removeFromSuperview()
            window.addSubview(rootView)

            // Remove secure container
            secureContainer.removeFromSuperview()

            // Clean everything
            self.overlayView = nil
            self.secureContainer = nil
            self.secureTextField = nil
            self.originalRootView = nil
        }
    }

    // MARK: - Overlay
    private func setupOverlay() {

        guard let secureContainer = secureContainer else { return }

        let overlay = UIView(frame: secureContainer.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        overlay.isHidden = true
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let label = UILabel()
        label.text = "⚠️ Screen Capture Disabled\nThis content is protected"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        overlay.addSubview(label)
        secureContainer.addSubview(overlay)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -24)
        ])

        self.overlayView = overlay
    }

    // MARK: - Show / Hide Overlay
    public func showCustomScreen() {
        overlayView?.isHidden = false
    }

    public func hideCustomScreen() {
        overlayView?.isHidden = true
    }
}
