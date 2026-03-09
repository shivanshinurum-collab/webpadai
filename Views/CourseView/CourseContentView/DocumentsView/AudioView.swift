import AVFoundation
import AVKit
import SwiftUI
import Combine


struct AudioPlayerView: View {
    @Binding var path : NavigationPath
    @StateObject private var audioVM = AudioPlayerViewModel()
    let audioURL: String
    let title : String
    
    var body: some View {
        HStack{
            Button{
                path.removeLast()
            }label:{
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
                    .font(.system(size: uiString.backSize))
            }
            Spacer()
            Text(title)
                .font(.system(size: uiString.titleSize).bold())
            .foregroundColor(.black)
            Spacer()
        }.padding(.horizontal)
        
        
        Spacer()
        Image("audio")
            .resizable()
            .scaledToFit()
        VStack(spacing: 20) {
            
            loadingAndErrorView
            timelineView
            playbackControlsView
            //volumeControlView
            //playbackRateView
            //additionalControlsView
        }.padding(.bottom)
        
        .padding()
        .onDisappear {
            audioVM.cleanup()
        }
    }
    
    // MARK: - Subviews
    
    private var loadingAndErrorView: some View {
        VStack {
            if audioVM.isLoading {
                ProgressView("Loading audio...")
            }
            
            if let errorMessage = audioVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
        }
    }
    
    private var timelineView: some View {
        VStack(spacing: 8) {
            Slider(
                value: Binding(
                    get: { audioVM.currentTime },
                    set: { audioVM.seek(to: $0) }
                ),
                in: 0...max(audioVM.duration, 0.1)
            )
            .disabled(audioVM.duration == 0)
            
            HStack {
                Text(formatTime(audioVM.currentTime))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(formatTime(audioVM.duration))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
    }
    
    private var playbackControlsView: some View {
        HStack(spacing: 30) {
            Button(action: { audioVM.skip(by: -15) }) {
                Image(systemName: "gobackward.15")
                    .font(.title3)
            }
            .disabled(!audioVM.isReadyToPlay)
            
            Button(action: {}) {
                Image(systemName: "backward.fill")
                    .font(.title3)
            }
            .disabled(true)
            
            Button(action: {
                audioVM.isPlaying
                    ? audioVM.pause()
                    : audioVM.play(urlString: audioURL)
            }) {
                Image(systemName: audioVM.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 35))
            }
            .disabled(audioVM.isLoading)
            
            Button(action: {}) {
                Image(systemName: "forward.fill")
                    .font(.title2)
            }
            .disabled(true)
            
            Button(action: { audioVM.skip(by: 15) }) {
                Image(systemName: "goforward.15")
                    .font(.title3)
            }
            .disabled(!audioVM.isReadyToPlay)
        }
        .foregroundColor(.primary)
        .navigationBarBackButtonHidden(true)
    }
    
    private func formatTime(_ time: Double) -> String {
        guard !time.isNaN && !time.isInfinite else { return "0:00" }
        
        let totalSeconds = Int(time)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}

// MARK: - Playback Rate Button Component

struct PlaybackRateButton: View {
    let rate: Float
    let currentRate: Float
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(formatRate(rate))
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
    }
    
    private var isSelected: Bool {
        abs(currentRate - rate) < 0.01
    }
    
    private func formatRate(_ rate: Float) -> String {
        if rate == 1.0 {
            return "1x"
        } else if rate == floor(rate) {
            return "\(Int(rate))x"
        } else {
            return String(format: "%.2gx", rate)
        }
    }
}



class AudioPlayerViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var volume: Float = 1.0
    @Published var playbackRate: Float = 1.0
    @Published var isRepeating = false
    @Published var isReadyToPlay = false

    private var player: AVPlayer?
    private var currentURL: String?
    private var statusObserver: NSKeyValueObservation?
    private var timeObserver: Any?
    private var isSeeking = false

    func play(urlString: String) {
        if urlString == currentURL, let player = player {
            player.play()
            isPlaying = true
            return
        }

        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }

        cleanup()
        isLoading = true
        errorMessage = nil
        currentURL = urlString
        isReadyToPlay = false

        let playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
        self.player?.volume = volume
        self.player?.rate = 0

        statusObserver = playerItem.observe(\.status, options: [.new]) { [weak self] item, _ in
            DispatchQueue.main.async {
                self?.handlePlayerStatus(item.status)
            }
        }

        playerItem.observe(\.duration, options: [.new]) { [weak self] item, _ in
            DispatchQueue.main.async {
                let duration = item.duration.seconds
                if !duration.isNaN && !duration.isInfinite {
                    self?.duration = duration
                }
            }
        }

        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self, !self.isSeeking else { return }
            let currentTime = time.seconds
            if !currentTime.isNaN && !currentTime.isInfinite {
                self.currentTime = currentTime
            }
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }

    private func handlePlayerStatus(_ status: AVPlayerItem.Status) {
        isLoading = false
        
        switch status {
        case .readyToPlay:
            player?.play()
            isPlaying = true
            isReadyToPlay = true
            errorMessage = nil
        case .failed:
            errorMessage = "Failed to load audio"
            isPlaying = false
            isReadyToPlay = false
        case .unknown:
            break
        @unknown default:
            break
        }
    }

    @objc private func playerDidFinishPlaying() {
        DispatchQueue.main.async {
            if self.isRepeating {
                self.seek(to: 0)
                self.player?.play()
            } else {
                self.isPlaying = false
                self.currentTime = self.duration
            }
        }
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func stop() {
        player?.pause()
        player?.seek(to: .zero)
        currentTime = 0
        isPlaying = false
    }

    func seek(to time: Double) {
        guard let player = player else { return }
        
        isSeeking = true
        let targetTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        player.seek(to: targetTime) { [weak self] _ in
            self?.isSeeking = false
        }
    }

    func skip(by seconds: Double) {
        let newTime = max(0, min(currentTime + seconds, duration))
        seek(to: newTime)
    }

    func setVolume(_ volume: Float) {
        self.volume = volume
        player?.volume = volume
    }

    func setPlaybackRate(_ rate: Float) {
        self.playbackRate = rate
        if isPlaying {
            player?.rate = rate
        }
    }

    func toggleRepeat() {
        isRepeating.toggle()
    }

    func cleanup() {
        player?.pause()
        statusObserver?.invalidate()
        statusObserver = nil
        
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        
        NotificationCenter.default.removeObserver(self)
        
        player = nil
        currentURL = nil
        isPlaying = false
        isReadyToPlay = false
        currentTime = 0
        duration = 0
    }

    deinit {
        cleanup()
    }
}


