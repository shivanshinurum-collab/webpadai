import SwiftUI
import UIKit

struct YouTubePlayerWrapper: UIViewControllerRepresentable {

    let videoID: String
    @Binding var controller: YouTubePlayerViewController?

    func makeUIViewController(context: Context) -> YouTubePlayerViewController {
        let vc = YouTubePlayerViewController()
        vc.load(videoID: videoID)
            

        DispatchQueue.main.async {
            controller = vc
        }

        return vc
    }

    func updateUIViewController(_ uiViewController: YouTubePlayerViewController, context: Context) {}
}
