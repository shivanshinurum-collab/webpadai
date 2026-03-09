import SwiftUI

struct PlayerControlsBar: View {

    let controller: YouTubePlayerViewController?

    @Binding var progress: Double
    @Binding var duration: Double

    var onFullscreen: (() -> Void)?
    var onSettings: (() -> Void)?

    @State private var isPlaying = true
    @State private var isMuted = true

    @State var isLandscape : Bool = false
    
    var body: some View {
        HStack(spacing: 12) {

            // Play / Pause
            Button {
                if isPlaying {
                    controller?.pause()
                } else {
                    controller?.play()
                }
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 16, weight: .bold))
            }

            // Mute / Unmute
            Button {
                if isMuted {
                    controller?.unmute()
                } else {
                    controller?.mute()
                }
                isMuted.toggle()
            } label: {
                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.system(size: 16, weight: .bold))
            }

            // Progress bar (simple seek)
            Slider(
                value: Binding(
                    get: { progress },
                    set: { progress = $0 }
                ),
                in: 0...duration,
                onEditingChanged: { editing in
                    if !editing {
                        controller?.seek(to: progress)
                    }
                }
            )
            .accentColor(.white)

            // Settings menu
            Button {
                onSettings?()
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 16, weight: .bold))
            }
            
            Button {
                
                //onFullscreen?()
                
                if isLandscape {
                    forcePortrait()
                    //setPortrait()
                    
                }else{
                    forceLandscape()
                    //setLandscape()
                }
                isLandscape.toggle()
            } label: {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 16, weight: .bold))
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 44)
        .background(Color.black.opacity(0.9))
        .foregroundColor(.white)
    }
    
    
    private func forceLandscape() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let preferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .landscapeRight)
        
        scene.requestGeometryUpdate(preferences) { error in
            print("Orientation error: \(error.localizedDescription)")
        }
    }

    private func forcePortrait() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let preferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .portrait)
        
        scene.requestGeometryUpdate(preferences) { error in
            print("Orientation error: \(error.localizedDescription)")
        }
    }
    
}
