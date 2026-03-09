import SwiftUI

struct FullscreenPlayerView: View {

    @State private var protector: CustomScreenProtectorKit?
    
    let controller: YouTubePlayerViewController?
    @Binding var isPresented: Bool

    @Binding var progress: Double
    @Binding var duration: Double

    var body: some View {
        ZStack(alignment: .bottom) {

            Color.black.ignoresSafeArea()

            if let controller = controller {
                PlayerControllerContainer(controller: controller)
                    .ignoresSafeArea()
            }

            PlayerControlsBar(
                controller: controller,
                progress: $progress,
                duration: $duration,
                onFullscreen: {
                    exit()
                },
                onSettings: nil
            )
        }
        .onAppear {
            setLandscape()
            
/*            if let window = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first?
                    .windows.first {

                    let kit = CustomScreenProtectorKit(window: window)
                    kit.enable()
                    protector = kit
                }
*/
        }
        .onDisappear {
            setPortrait()
        }
    }

    private func exit() {
        isPresented = false
    }

    private func setLandscape() {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        notifyOrientationChange()
    }

    private func setPortrait() {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        notifyOrientationChange()
    }

    private func notifyOrientationChange() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
}
