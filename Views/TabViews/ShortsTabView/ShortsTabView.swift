import SwiftUI
import AVKit
import Combine

struct ShortsTabView : View {
    var body: some View {
        ShortsView()
    }
}

// MARK: - Main View
struct ShortsView: View {
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let safeArea = geometry.safeAreaInsets
            
            ShortsHome(size: size, safeArea: safeArea)
                .ignoresSafeArea(.container, edges: .all)
        }
    }
}

// MARK: - Home View
struct ShortsHome: View {
    var size: CGSize
    var safeArea: EdgeInsets
    
    @StateObject private var manager = ReelPlayerManager()
    @State private var reels: [Shorts] = []
        
    @State var currentIndex: Int? = 0
    
    
    var body: some View {
        scrollContent
            .background(.black)
            .environment(\.colorScheme, .dark)
            //.onAppear(perform: playFirst)
            .onAppear{
                fetchShorts()
            }
            .onDisappear{
                manager.stopAll()
            }
            .onChange(of: currentIndex, perform: handleIndexChange)
        
            
    }
    
    func fetchShorts() {
        
        let components = URLComponents(
            string: apiURL.getTestimonial
        )

        guard let url = components?.url else {
            print("❌ Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("❌ API Error:", error.localizedDescription)
                return
            }

            guard let data else {
                print("❌ No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(ShortsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.reels = decodedResponse.testimonialList
                    self.currentIndex = 0
                    self.playFirst()
                   
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
    
    
    private var scrollContent: some View {
        ScrollView(.vertical) {
            LazyVStack {
                reelsList
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $currentIndex)
    }
    private var reelsList: some View {
        ForEach(Array(reels.enumerated()), id: \.element.id) { index, reel in
            ReelView(
                reel: reel,
                size: size,
                safeArea: safeArea,
                manager: manager,
                isCurrent: currentIndex == index
            )
            .frame(maxWidth: .infinity)
            .containerRelativeFrame(.vertical)
            .id(index)
        }
    }
    private func playFirst() {
        guard let first = reels.first,
              let url = URL(string: first.videoPath) else { return }
        manager.play(url: url)
    }

    private func handleIndexChange(_ newValue: Int?) {
        guard
            let index = newValue,
            reels.indices.contains(index),
            let url = URL(string: reels[index].videoPath)
        else { return }

        manager.play(url: url)
    }

    
}

// MARK: - Player Manager
class ReelPlayerManager: ObservableObject {
    let player = AVPlayer()
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Loop video when it ends
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.player.seek(to: .zero)
            self?.player.play()
        }
        
        // Observe playback time
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            self?.currentTime = time.seconds
        }
    }
    
    deinit {
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }

    // ⛔ STOP ALL VIDEOS & AUDIO
        func stopAll() {
            player.pause()
            player.replaceCurrentItem(with: nil)
            currentTime = 0
            duration = 0
        }
    
    func play(url: URL) {
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        
        // Get duration when item is ready
        item.publisher(for: \.status)
            .filter { $0 == .readyToPlay }
            .sink { [weak self] _ in
                if let duration = self?.player.currentItem?.duration.seconds,
                   !duration.isNaN && !duration.isInfinite {
                    self?.duration = duration
                }
            }
            .store(in: &cancellables)
        
        player.play()
    }

    func pause() {
        player.pause()
    }
    
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player.seek(to: cmTime)
    }
}

// MARK: - Custom Video Player
struct CustomReelVideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.videoGravity = .resizeAspectFill
        controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}

// MARK: - Single Reel View
struct ReelView: View {
    let reel: Shorts
    var size: CGSize
    var safeArea: EdgeInsets
    @ObservedObject var manager: ReelPlayerManager
    let isCurrent: Bool
    
    @State private var isPlaying = true
    @State private var showPlayButton = false
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                // Video Player
                Color.black
                    .ignoresSafeArea()
                
                CustomReelVideoPlayer(player: manager.player)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Tap gesture overlay
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if isPlaying {
                                manager.pause()
                                showPlayButton = true
                            } else {
                                manager.player.play()
                                showPlayButton = false
                            }
                            isPlaying.toggle()
                        }
                    }
                
                // Video Timeline
                VStack {
                    Spacer()
                    
                    VideoTimeline(
                        currentTime: manager.currentTime,
                        duration: manager.duration,
                        onSeek: { time in
                            manager.seek(to: time)
                        }
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, safeArea.bottom + 20)
                }
                
                // Center Play/Pause Button
                if showPlayButton {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 10)
                        .transition(.scale.combined(with: .opacity))
                        .onAppear {
                            if !isPlaying {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation {
                                        showPlayButton = false
                                    }
                                }
                            }
                        }
                }
            }
            .onAppear {
                if isCurrent {
                    isPlaying = true
                }
            }
            .onDisappear {
                isPlaying = false
            }
        }
    }
}

// MARK: - Video Timeline Component
struct VideoTimeline: View {
    let currentTime: Double
    let duration: Double
    let onSeek: (Double) -> Void
    
    @State private var isDragging = false
    @State private var dragValue: Double = 0
    
    var body: some View {
        VStack(spacing: 4) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 3)
                    
                    // Progress track
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: progressWidth(in: geometry.size.width), height: 3)
                }
                .cornerRadius(1.5)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDragging = true
                            let progress = min(max(0, value.location.x / geometry.size.width), 1)
                            dragValue = progress * duration
                        }
                        .onEnded { value in
                            isDragging = false
                            let progress = min(max(0, value.location.x / geometry.size.width), 1)
                            let seekTime = progress * duration
                            onSeek(seekTime)
                        }
                )
            }
            .frame(height: 3)
            
            // Time labels
            HStack {
                Text(timeString(from: isDragging ? dragValue : currentTime))
                    .font(.caption2)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(timeString(from: duration))
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.vertical, 4)
    }
    
    private func progressWidth(in totalWidth: CGFloat) -> CGFloat {
        guard duration > 0 else { return 0 }
        let progress = isDragging ? (dragValue / duration) : (currentTime / duration)
        return totalWidth * CGFloat(progress)
    }
    
    private func timeString(from seconds: Double) -> String {
        guard !seconds.isNaN && !seconds.isInfinite else { return "0:00" }
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let secs = totalSeconds % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}
