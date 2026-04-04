
import SwiftUI
import AVKit

struct VideoView: View {
    //let videoURL: String = "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"
    // "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    
    let videoURL: String
    let title: String
    
    @Binding var path : NavigationPath
    
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var currentTime: Double = 0
    @State private var duration: Double = 0
    @State private var showControls = true
    @State private var timeObserver: Any?
    @State private var speaker = true
    
    @State private var isDownloading = false
    @State private var showToast = false
    
    @State private var showSettings = false
    @State private var playbackSpeed: Float = 1.0
    @State private var selectedQuality: String = "Auto"
    
    
    
    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            
            if !isLandscape {
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
                    
                    // ⬇️ Download Button
                    Button {
                        downloadAndSave()
                    } label: {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .disabled(isDownloading)
                    
                    
                }.padding(.horizontal)
                    .frame(height: 40)
            }else{
                HStack{
                    Button{
                        forcePortrait()
                        path.removeLast()
                    }label:{
                        Image(systemName: "arrow.left")
                            .foregroundColor(.pink)
                            .font(.system(size: uiString.backSize))
                    }
                    Spacer()
                }.padding(25)
            }
            
            
            ZStack {
                
                
                /*Color.black
                 .ignoresSafeArea()*/
                
                if isLoading {
                    VStack(spacing: 15) {
                        ProgressView()
                            .tint(uiColor.DarkGrayText)
                            .scaleEffect(1.5)
                        Text("Loading Video...")
                            .foregroundColor(uiColor.DarkGrayText)
                            .font(.headline)
                            .padding(.top)
                    }
                } else if let error = errorMessage {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.orange)
                        
                        Text("Failed to Load Video")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(error)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Retry") {
                            loadVideo()
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                } else if let player = player {
                    VStack {
                        
                        // Video Player
                        ZStack(alignment: .bottom){
                            
                            VStack{
                                if !isLandscape {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(height: 40)
                                }
                                
                                VideoPlayerRepresentable(player: player)
                                    .frame(maxHeight: isLandscape ? .infinity : 230)
                                    .ignoresSafeArea()
                                    .onTapGesture {
                                        withAnimation {
                                            showControls.toggle()
                                        }
                                    }
                                //.frame(height: 230)
                            }
                            //.frame(maxHeight: isLandscape ? .infinity : 230)
                            
                            // Custom Controls Overlay
                            if showControls {
                                HStack(spacing: 12){
                                    // Play/Pause Button
                                    Button {
                                        togglePlayPause()
                                    } label: {
                                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .shadow(radius: 10)
                                    }
                                    
                                    //Speaker
                                    Button{
                                        speaker.toggle()
                                    }label: {
                                        Image(systemName: speaker ? "speaker.wave.2.fill" : "speaker.slash.fill" )
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .shadow(radius: 10)
                                    }
                                    
                                    Text(formatTime(currentTime))
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                    
                                    
                                    Slider(value: $currentTime, in: 0...max(duration, 1)) { editing in
                                        if !editing {
                                            player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600))
                                        }
                                    }
                                    .tint(.gray)
                                    
                                    Text(formatTime(duration))
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                    
                                    //Setting
                                    Button{
                                        showSettings.toggle()
                                    }label:{
                                        Image(systemName: "gearshape.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .shadow(radius: 10)
                                    }
                                    
                                    
                                    //HQ
                                    Button{
                                        if isLandscape {
                                            forcePortrait()
                                        } else {
                                            forceLandscape()
                                        }
                                    }label:{
                                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .shadow(radius: 10)
                                    }
                                }
                                
                            }
                            
                            
                            
                            
                        }
                        .frame(maxHeight: isLandscape ? .infinity : 270)
                        if !isLandscape {
                            Spacer()
                        }
                    }
                }
                
                
                
            }
            .frame(maxWidth: .infinity , maxHeight: .infinity)
            .overlay(
                VStack {
                    if isLandscape {
                        HStack{
                            Button{
                                forcePortrait()
                                path.removeLast()
                            }label:{
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: uiString.backSize))
                                    .bold()
                            }
                            Spacer()
                        }.padding(20)
                    }
                    Spacer()
                    
                    if showToast {
                        ToastView(message: "Downloaded and saved to your device")
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.bottom, 40)
                    }
                }
                    .animation(.easeInOut, value: showToast)
            )
            .sheet(isPresented: $showSettings) {
                settingsView()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadVideo()
            }
            .onDisappear {
                cleanupPlayer()
            }
        }
        
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
    
    // MARK: - Download + Save + Open Offline
    private func downloadAndSave() {
        isDownloading = true
        
        DocumentDownloadManager.shared.downloadAndSave(name : title ,remoteURL: videoURL) { localURL in
            DispatchQueue.main.async {
                isDownloading = false
                
                if let localURL {
                    // ✅ Open offline document
                    //path.append(DocumentRoute.offline(localURL))
                    showToast = true
                } else {
                    print("❌ Download failed")
                }
            }
        }
    }
    
    
    func loadVideo() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: videoURL) else {
            errorMessage = "Invalid video URL"
            isLoading = false
            return
        }
        
        print("🎥 Loading video from: \(videoURL)")
        
        let playerItem = AVPlayerItem(url: url)
        let videoPlayer = AVPlayer(playerItem: playerItem)
        
        // Add time observer
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = videoPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            currentTime = time.seconds
            
            if let duration = videoPlayer.currentItem?.duration.seconds, !duration.isNaN {
                self.duration = duration
            }
        }
        
        // Observe when video ends
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            isPlaying = false
            videoPlayer.seek(to: .zero)
            showControls = true
        }
        
        // Wait for video to be ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if playerItem.status == .failed {
                errorMessage = "Failed to load video. Please check your connection."
                isLoading = false
                print("❌ Video failed to load")
            } else {
                self.player = videoPlayer
                isLoading = false
                videoPlayer.play()
                isPlaying = true
                print("✅ Video loaded successfully")
                
                // Auto-hide controls after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showControls = false
                    }
                }
            }
        }
        
    }
    
    func togglePlayPause() {
        guard let player = player else { return }
        
        if isPlaying {
            player.pause()
        } else {
            player.playImmediately(atRate: playbackSpeed)
        }
        //        if isPlaying {
        //            player.pause()
        //        } else {
        //            player.play()
        //        }
        isPlaying.toggle()
    }
    
    func seekVideo(by seconds: Double) {
        guard let player = player else { return }
        let newTime = max(0, min(currentTime + seconds, duration))
        currentTime = newTime
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
    }
    
    func formatTime(_ time: Double) -> String {
        guard !time.isNaN && !time.isInfinite else { return "0:00" }
        
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func cleanupPlayer() {
        player?.pause()
        
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
        
        player = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    func applyQuality(_ quality: String) {
        selectedQuality = quality
        
        guard let item = player?.currentItem else { return }
        
        switch quality {
        case "360p":
            item.preferredPeakBitRate = 500_000
        case "720p":
            item.preferredPeakBitRate = 2_000_000
        case "1080p":
            item.preferredPeakBitRate = 5_000_000
        default:
            item.preferredPeakBitRate = 0 // Auto
        }
    }
    
    func applyPlaybackSpeed() {
        player?.rate = isPlaying ? playbackSpeed : 0
    }
    
    @State private var selectedTab: Int = 0 // 0 = Speed, 1 = Quality
    
    @ViewBuilder
    func settingsView() -> some View {
        VStack(spacing: 0) {
            
            // MARK: Drag Indicator
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 10)
            
            // MARK: Header
            HStack {
                Text("Settings")
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                Button {
                    showSettings = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(Color.primary.opacity(0.08))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            // MARK: TOP TAB BAR 🔥
            HStack(spacing: 0) {
                
                tabButton(title: "Playback", index: 0 , icon : "speedometer")
                tabButton(title: "Quality", index: 1 , icon:"video")
            }
            .padding(6)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            
            // MARK: CONTENT
            ScrollView {
                VStack(spacing: 20) {
                    
                    if selectedTab == 0 {
                        playbackView
                    } else {
                        qualityView
                    }
                }
                .padding()
            }
        }
        .background(
            ZStack {
                Color(.systemGroupedBackground)
                Color.black.opacity(0.02)
            }
                .ignoresSafeArea()
        )
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    func tabButton(title: String, index: Int , icon :String) -> some View {
        Button {
            withAnimation(.easeInOut) {
                selectedTab = index
            }
        } label: {
            HStack{
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(selectedTab == index ? .white : .primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(selectedTab == index ? Color.blue : Color.clear)
            )
        }
    }
    func formatSpeed(_ speed: Double) -> String {
        let formatted = speed.truncatingRemainder(dividingBy: 1) == 0
        ? String(Int(speed))
        : String(format: "%.2f", speed)
            .replacingOccurrences(of: #"0+$"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"\.$"#, with: "", options: .regularExpression)
        
        return "\(formatted)x"
    }
    var playbackView: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            //            Label("Playback Speed", systemImage: "speedometer")
            //                .font(.subheadline)
            //                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                ForEach([0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0], id: \.self) { speed in
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            playbackSpeed = Float(speed)
                            applyPlaybackSpeed()
                        }
                    } label: {
                        HStack {
                            Text(formatSpeed(speed))
                            
                            Spacer()
                            
                            if playbackSpeed == Float(speed) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(playbackSpeed == Float(speed)
                                      ? Color.blue.opacity(0.12)
                                      : Color.clear)
                        )
                    }
                }
            }
            .padding(6)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    var qualityView: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            //            Label("Video Quality", systemImage: "video")
            //                .font(.subheadline)
            //                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                ForEach(["Auto", "360p", "720p", "1080p"], id: \.self) { quality in
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            applyQuality(quality)
                        }
                    } label: {
                        HStack {
                            Text(quality)
                            
                            Spacer()
                            
                            if selectedQuality == quality {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedQuality == quality
                                      ? Color.blue.opacity(0.12)
                                      : Color.clear)
                        )
                    }
                }
            }
            .padding(6)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    
}

// Custom Video Player Representable
struct VideoPlayerRepresentable: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false  // Hide default controls
        controller.videoGravity = .resizeAspect
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}

/*
 import SwiftUI
import AVKit

struct VideoView: View {
    let videoURL: String
    let title: String
    
    @Binding var path : NavigationPath
    
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var currentTime: Double = 0
    @State private var duration: Double = 0
    @State private var showControls = true
    @State private var timeObserver: Any?
    @State private var speaker = true
    
    @State private var isDownloading = false
    @State private var showToast = false
    
    
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
            
            // ⬇️ Download Button
            Button {
                downloadAndSave()
            } label: {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .disabled(isDownloading)
            
            
        }.padding(.horizontal)
        
        ZStack {
            
            
            /*Color.black
                .ignoresSafeArea()*/
            
            if isLoading {
                VStack(spacing: 15) {
                    ProgressView()
                        .tint(uiColor.DarkGrayText)
                        .scaleEffect(1.5)
                    Text("Loading Video...")
                        .foregroundColor(uiColor.DarkGrayText)
                        .font(.headline)
                        .padding(.top)
                }
            } else if let error = errorMessage {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    Text("Failed to Load Video")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(error)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Retry") {
                        loadVideo()
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else if let player = player {
                VStack {
                    // Video Player
                    ZStack(alignment: .bottom){
                        VideoPlayerRepresentable(player: player)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    showControls.toggle()
                                }
                            }
                            .frame(height: 230)
                        
                        // Custom Controls Overlay
                        if showControls {
                            HStack(spacing: 12){
                                // Play/Pause Button
                                Button {
                                    togglePlayPause()
                                } label: {
                                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .shadow(radius: 10)
                                }
                                
                                //Speaker
                                Button{
                                    speaker.toggle()
                                }label: {
                                    Image(systemName: speaker ? "speaker.wave.2.fill" : "speaker.slash.fill" )
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .shadow(radius: 10)
                                }
                                
                                Text(formatTime(currentTime))
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                
                                
                                Slider(value: $currentTime, in: 0...max(duration, 1)) { editing in
                                    if !editing {
                                        player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600))
                                    }
                                }
                                .tint(.gray)
                                
                                Text(formatTime(duration))
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                
                                //Setting
                                Button{
                                    
                                }label:{
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .shadow(radius: 10)
                                }
                                
                                
                                //HQ
                                Button{
                                    
                                }label:{
                                    Image(systemName: "video.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .shadow(radius: 10)
                                }
                            }
                           
                        }
                    }.padding(.bottom)
                        .frame(height: 230)
                    Spacer()
                }
            }
        }.overlay(
            VStack {
                Spacer()
                
                if showToast {
                    ToastView(message: "Downloaded and saved to your device")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 40)
                }
            }
            .animation(.easeInOut, value: showToast)
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadVideo()
        }
        .onDisappear {
            cleanupPlayer()
        }
    }
    
    // MARK: - Download + Save + Open Offline
    private func downloadAndSave() {
        isDownloading = true
        
        DocumentDownloadManager.shared.downloadAndSave(name : title ,remoteURL: videoURL) { localURL in
            DispatchQueue.main.async {
                isDownloading = false
                
                if let localURL {
                    // ✅ Open offline document
                    //path.append(DocumentRoute.offline(localURL))
                    showToast = true
                } else {
                    print("❌ Download failed")
                }
            }
        }
    }
    
    
    func loadVideo() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: videoURL) else {
            errorMessage = "Invalid video URL"
            isLoading = false
            return
        }
        
        print("🎥 Loading video from: \(videoURL)")
        
        let playerItem = AVPlayerItem(url: url)
        let videoPlayer = AVPlayer(playerItem: playerItem)
        
        // Add time observer
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = videoPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            currentTime = time.seconds
            
            if let duration = videoPlayer.currentItem?.duration.seconds, !duration.isNaN {
                self.duration = duration
            }
        }
        
        // Observe when video ends
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            isPlaying = false
            videoPlayer.seek(to: .zero)
            showControls = true
        }
        
        // Wait for video to be ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if playerItem.status == .failed {
                errorMessage = "Failed to load video. Please check your connection."
                isLoading = false
                print("❌ Video failed to load")
            } else {
                self.player = videoPlayer
                isLoading = false
                videoPlayer.play()
                isPlaying = true
                print("✅ Video loaded successfully")
                
                // Auto-hide controls after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showControls = false
                    }
                }
            }
        }
    }
    
    func togglePlayPause() {
        guard let player = player else { return }
        
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    func seekVideo(by seconds: Double) {
        guard let player = player else { return }
        let newTime = max(0, min(currentTime + seconds, duration))
        currentTime = newTime
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
    }
    
    func formatTime(_ time: Double) -> String {
        guard !time.isNaN && !time.isInfinite else { return "0:00" }
        
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func cleanupPlayer() {
        player?.pause()
        
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
        
        player = nil
        NotificationCenter.default.removeObserver(self)
    }
}*/
