
import SwiftUI

struct PlayerControllerContainer: UIViewControllerRepresentable {

    let controller: YouTubePlayerViewController

    func makeUIViewController(context: Context) -> YouTubePlayerViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: YouTubePlayerViewController, context: Context) {}
}
