
import SwiftUI

struct YoutubePlayerView: View {
    
    @Binding var path : NavigationPath
    
    @State private var isFullscreen = false
    @State private var playerController: YouTubePlayerViewController?
    @State private var showSettings = false
    @State private var settingsState = PlayerSettingsState()
    
    @State private var progress: Double = 0
    @State private var duration: Double = 1
    
    private let videoHeight: CGFloat = 260
    private let controlBarHeight: CGFloat = 44
    
    @State private var showControls = true
    @State private var showForward = false
    @State private var showBackward = false
    
    @State private var hideTask: DispatchWorkItem?
    @State private var isLandscape = false
    
    @State var showBack = false;
    let videoId: String
    
    var body: some View {
        
        GeometryReader { geo in
            
            let landscape = geo.size.width > geo.size.height
            
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    
                    
                    // MARK: Player
                    YouTubePlayerWrapper(
                        videoID: videoId,
                        controller: $playerController
                    )
                    //.frame(maxHeight: landscape ? .infinity : videoHeight)
                    .frame(maxHeight: .infinity)
                    .clipped()
                    .onChange(of: playerController) {
                        
                        resetAutoHide()
                        
                        guard let controller = playerController else { return }
                        
                        controller.onProgressUpdate = { current, total in
                            DispatchQueue.main.async {
                                progress = current
                                duration = max(total, 1)
                            }
                        }
                    }
                    
                    // MARK: Double Tap Areas
                    HStack(spacing: 0) {
                        
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture(count: 2) {
                                backward()
                            }
                        
                        // CENTER AREA (Play / Pause)
                        Color.clear
                            .contentShape(Rectangle())
                        //                                .onTapGesture {
                        //                                    togglePlayPause()
                        //                                }
                        
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture(count: 2) {
                                forward()
                            }
                    }
                    
                    // MARK: Ripple Animations
                    if showBackward {
                        ripple(icon: "gobackward.10")
                    }
                    
                    if showForward {
                        ripple(icon: "goforward.10")
                    }
                    
                    // MARK: Controls
                    if showControls {
                        
                        VStack {
                            
                            
                            
                            
                            Spacer()
                            
                            PlayerControlsBar(
                                controller: playerController,
                                progress: $progress,
                                duration: $duration,
                                onFullscreen: { enterFullscreen() },
                                onSettings: { showSettings = true }
                            )
                        }
                        .transition(.opacity)
                    }
                }
                //.frame(maxHeight: landscape ? .infinity : videoHeight + controlBarHeight)
                .frame(maxHeight: .infinity)
                .background(Color.black)
            }
            .ignoresSafeArea(.all, edges: .top)
            .background(Color.black)
            
            .sheet(isPresented: $showSettings) {
                PlayerSettingsSheet(
                    isPresented: $showSettings,
                    state: $settingsState,
                    controller: playerController
                )
            }
            
            // MARK: Tap show/hide controls
            .onTapGesture {
                toggleControls()
            }
            
            .onAppear {
                isLandscape = landscape
                showBack = landscape
                resetAutoHide()
            }
            
            .onChange(of: landscape) { value in
                isLandscape = value
                showBack = value
                resetAutoHide()
            }
        }
    }
    
    
    // MARK: Fullscreen
    private func enterFullscreen() {
        isFullscreen = true
    }
    
    // MARK: Ripple Animation
    func ripple(icon: String) -> some View {
        Image(systemName: icon)
            .font(.system(size: 50))
            .foregroundColor(.white)
            .padding(40)
            .background(
                Circle()
                    .fill(Color.black.opacity(0.5))
            )
            .transition(.scale)
    }
    
    // MARK: Forward 10s
    func forward() {
        playerController?.seek(to: progress + 10)
        
        showForward = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showForward = false
        }
        
        resetAutoHide()
    }
    
    // MARK: Backward 10s
    func backward() {
        playerController?.seek(to: max(progress - 10, 0))
        
        showBackward = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showBackward = false
        }
        
        resetAutoHide()
    }
    
    // MARK: Toggle Controls
    func toggleControls() {
        
        withAnimation {
            showControls.toggle()
        }
        
        if showControls {
            resetAutoHide()
        } else {
            hideTask?.cancel()
        }
    }
    
    // MARK: Reset Auto Hide Timer
    func resetAutoHide() {
        
        hideTask?.cancel()
        
        guard isLandscape else { return }
        
        let task = DispatchWorkItem {
            withAnimation {
                showControls = false
            }
        }
        
        hideTask = task
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
    }
    
//    var backButton : some View {
//        GeometryReader { geo in
//            let landscape = geo.size.width > geo.size.height
//
//            if isLandscape {
//                HStack {
//                    Button {
//                        path.removeLast()
//                    } label: {
//                        Image(systemName: "arrow.left")
//                            .font(.system(size: 20, weight: .bold))
//                            .foregroundColor(.white)
//                            .padding()
//                            .padding(.horizontal)
//                    }
//                    Spacer()
//                }.padding(.horizontal)
//            }
//
//        }
//    }
}














//import SwiftUI
//
//struct YoutubePlayerView: View {
//
//    @State private var isFullscreen = false
//    @State private var playerController: YouTubePlayerViewController?
//    @State private var showSettings = false
//    @State private var settingsState = PlayerSettingsState()
//
//    @State private var progress: Double = 0
//    @State private var duration: Double = 1
//
//    private let videoHeight: CGFloat = 260
//    private let controlBarHeight: CGFloat = 44
//
//    @State private var showControls = true
//    @State private var showForward = false
//    @State private var showBackward = false
//
//    @State private var hideTask: DispatchWorkItem?
//
//    // Landscape state
//    @State private var isLandscape = false
//
//    let videoId: String
//
//    var body: some View {
//
//        GeometryReader { geo in
//
//            let landscape = geo.size.width > geo.size.height
//
//            VStack(spacing: 0) {
//
//                ZStack(alignment: .bottom) {
//
//                    YouTubePlayerWrapper(
//                        videoID: videoId,
//                        controller: $playerController
//                    )
//                    .frame(maxHeight: landscape ? .infinity : videoHeight)
//                    .clipped()
//                    .onChange(of: playerController) {
//                        toggleControls()
//
//                        guard let controller = playerController else { return }
//
//                        controller.onProgressUpdate = { current, total in
//                            DispatchQueue.main.async {
//                                progress = current
//                                duration = max(total, 1)
//                            }
//                        }
//                    }
//
//                    if showControls {
//                        VStack {
//                            Spacer()
//                            PlayerControlsBar(
//                                controller: playerController,
//                                progress: $progress,
//                                duration: $duration,
//                                onFullscreen: { enterFullscreen() },
//                                onSettings: { showSettings = true }
//                            )
//                        }
//                        .transition(.opacity)
//                    }
//
//                }
//                .frame(maxHeight: landscape ? .infinity : videoHeight + controlBarHeight)
//                .background(Color.black)
//
//            }
//            .ignoresSafeArea(.all, edges: .top)
//            .background(Color.black)
//            .sheet(isPresented: $showSettings) {
//                PlayerSettingsSheet(
//                    isPresented: $showSettings,
//                    state: $settingsState,
//                    controller: playerController
//                )
//            }
//            .onTapGesture {
//                toggleControls()
//            }
//            .onAppear {
//                isLandscape = landscape
//                isLandscapee()
//            }
//            .onChange(of: landscape) { value in
//                isLandscape = value
//                isLandscapee()
//            }
//        }
//    }
//
//    // MARK: Fullscreen helper
//    private func enterFullscreen() {
//        isFullscreen = true
//    }
//
//    // MARK: Ripple animation
//    func ripple(icon: String) -> some View {
//        Image(systemName: icon)
//            .font(.system(size: 50))
//            .foregroundColor(.white)
//            .padding(40)
//            .background(
//                Circle()
//                    .fill(Color.black.opacity(0.5))
//            )
//            .transition(.scale)
//    }
//
//    // MARK: Forward
//    func forward() {
//        playerController?.seek(to: progress + 10)
//
//        showForward = true
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            showForward = false
//        }
//
//        isLandscapee()
//    }
//
//    // MARK: Backward
//    func backward() {
//        playerController?.seek(to: max(progress - 10,0))
//
//        showBackward = true
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            showBackward = false
//        }
//
//        isLandscapee()
//    }
//
//    // MARK: Toggle controls
//    func toggleControls() {
//        withAnimation {
//            showControls.toggle()
//        }
//
//        if showControls {
//            isLandscapee()
//        }
//    }
//
//    // MARK: Auto hide controls
//    func startAutoHide() {
//
//        hideTask?.cancel()
//
//        let task = DispatchWorkItem {
//            withAnimation {
//                showControls = false
//            }
//        }
//
//        hideTask = task
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
//    }
//
//    // MARK: Landscape check
//    func isLandscapee() {
//        if isLandscape {
//            startAutoHide()
//        }
//    }
//}

/*
import SwiftUI

struct YoutubePlayerView: View {
    
    // State must be INSIDE the struct
    @State private var isFullscreen = false
    @State private var playerController: YouTubePlayerViewController?
    @State private var showSettings = false
    @State private var settingsState = PlayerSettingsState()
    
    @State private var progress: Double = 0
    @State private var duration: Double = 1

    private let videoHeight: CGFloat =  260
    private let controlBarHeight: CGFloat = 44
    
    @State private var showControls = true
    @State private var showForward = false
    @State private var showBackward = false
    
    @State private var hideTask: DispatchWorkItem?
    
    
    let videoId: String

    var body: some View {
        
        GeometryReader { geo in
            
            let isLandscape = geo.size.width > geo.size.height
            
            
            VStack(spacing: 0) {
                
                // MARK: - Video Section
                ZStack(alignment: .bottom) {
                    
                    YouTubePlayerWrapper(
                        videoID: videoId,
                        controller: $playerController
                    )
                    .frame(maxHeight: isLandscape ?  .infinity : videoHeight )
                    .clipped()
                    .onChange(of: playerController) {
                        toggleControls()
                        guard let controller = playerController else { return }
                        
                        controller.onProgressUpdate = { current, total in
                            DispatchQueue.main.async {
                                progress = current
                                duration = max(total, 1)
                            }
                        }
                    }
                    
                    if showControls {
                        VStack {
                            Spacer()
                            PlayerControlsBar(
                                controller: playerController,
                                progress: $progress,
                                duration: $duration,
                                onFullscreen: { enterFullscreen() },
                                onSettings: { showSettings = true }
                            )
                        }
                        .transition(.opacity)
                    }
                    
                    
                    //                    PlayerControlsBar(
                    //                        controller: playerController,
                    //                        progress: $progress,
                    //                        duration: $duration,
                    //                        onFullscreen: { enterFullscreen() },
                    //                        onSettings: { showSettings = true }
                    //                    )
                    
                }
                .frame(maxHeight: isLandscape ?  .infinity : videoHeight + controlBarHeight )
                //.frame(maxHeight: .infinity)
                .background(Color.black)
                
            }
            .ignoresSafeArea(.all, edges: .top)
            .background(Color.black)
            .sheet(isPresented: $showSettings) {
                PlayerSettingsSheet(
                    isPresented: $showSettings,
                    state: $settingsState,
                    controller: playerController
                )
            }
            .onTapGesture {
                toggleControls()
            }
            .onAppear {
                isLandscapee()
            }
        }
    }

   // MARK: - Fullscreen helper

    private func enterFullscreen() {
        isFullscreen = true
    }

    func ripple(icon: String) -> some View {

        Image(systemName: icon)
            .font(.system(size: 50))
            .foregroundColor(.white)
            .padding(40)
            .background(
                Circle()
                    .fill(Color.black.opacity(0.5))
            )
            .transition(.scale)
    }
    
    
    func forward() {
        playerController?.seek(to: progress + 10)

        showForward = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showForward = false
        }

        //startAutoHide()
        isLandscapee()
    }

    func backward() {
        playerController?.seek(to: max(progress - 10,0))

        showBackward = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showBackward = false
        }

        //startAutoHide()
        isLandscapee()
    }

    func toggleControls() {
        withAnimation {
            showControls.toggle()
        }

        if showControls {
            isLandscapee()
        }
    }

    func startAutoHide() {

        hideTask?.cancel()

        let task = DispatchWorkItem {
            withAnimation {
                showControls = false
            }
        }

        hideTask = task

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
    }
    
    func isLandscapee() {
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            startAutoHide()
        }
    }
    
    
    
}

*/

