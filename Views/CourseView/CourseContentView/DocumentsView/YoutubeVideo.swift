/*import SwiftUI

struct YouTubeVideoView: View {
    
    let videoId: String
    let title: String
    
    @Binding var path: NavigationPath
    
    // 🔍 Zoom States
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // 🔙 Header
            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.system(size: uiString.backSize))
                }
                
                Spacer()
                
                Text(title)
                    .font(.system(size: uiString.titleSize).bold())
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Spacer()
            }
            .padding()
            
            // 🎥 Video at TOP (Fixed 16:9)
            ZStack (alignment: .top){
                //Color.black
                
                YoutubePlayerView(videoId: videoId)
                    .frame(height: UIScreen.main.bounds.width * 9 / 16)
                    .scaleEffect(scale)
                    // ✅ Zoom gesture
                    .simultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = lastScale * value
                                scale = min(max(0.5, scale), 4.0)
                            }
                            .onEnded { _ in
                                lastScale = scale
                            }
                    )
                    // ⚡ Double tap reset
                    .onTapGesture(count: 2) {
                        withAnimation {
                            scale = 1
                            lastScale = 1
                        }
                    }
                    .padding()
                    .background(.black)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}*/

/*import SwiftUI

struct YouTubeVideoView: View {
    
    let videoId: String
    let title: String
    
    @Binding var path: NavigationPath
    
    // 🔍 Zoom States
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    var body: some View {
        
        GeometryReader { geo in
            
            let isLandscape = geo.size.width > geo.size.height
            
            VStack(spacing: 0) {
                
                // 🔙 Header (Portrait only)
                if !isLandscape {
                    HStack {
                        Button {
                            path.removeLast()
                        } label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                                .font(.system(size: uiString.backSize))
                        }
                        
                        Spacer()
                        
                        Text(title)
                            .font(.system(size: uiString.titleSize).bold())
                            .foregroundColor(.black)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    .padding()
                }
                
                // 🎥 Video Section
                ZStack {
                    Color.black
                    
                    YoutubePlayerView(videoId: videoId)
                        .frame(
                            width: geo.size.width,
                            height: isLandscape
                                ? geo.size.height
                                : geo.size.width * 9 / 16
                        )
                        .scaleEffect(scale)
                        
                        // ✅ Allow both tap + zoom
                        .simultaneousGesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = lastScale * value
                                    scale = min(max(0.5, scale), 4.0)
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                }
                        )
                        
                        // ⚡ Double tap to reset (optional)
                        .onTapGesture(count: 2) {
                            withAnimation {
                                scale = 1
                                lastScale = 1
                            }
                        }
                }
                
                if !isLandscape {
                    Spacer()
                }
            }
            .ignoresSafeArea(edges: isLandscape ? .all : [])
            .navigationBarBackButtonHidden(true)
        }
    }
}*/

import SwiftUI

struct YouTubeVideoView : View {
    let videoId : String
    let title : String
    
    @Binding var path : NavigationPath
    
    // 🔍 Zoom States
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    private let videoHeight: CGFloat = 280
    
    var body: some View {
        
        GeometryReader { geo in
            
            let isLandscape = geo.size.width > geo.size.height
            
            VStack(){
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
                    }.padding(.horizontal)
                    
                }
                ZStack(alignment: .top){
                    VStack{
                        //YoutubePlayerView(videoId: videoId)
                        YoutubePlayerView(path: $path , videoId: videoId)
                            .frame(maxHeight: isLandscape ? .infinity : videoHeight)
                        //.frame(height: UIScreen.main.bounds.width * 9 / 16)
                            .scaleEffect(scale)
                        // ✅ Zoom gesture
                            .simultaneousGesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        scale = lastScale * value
                                        scale = min(max(0.5, scale), 4.0)
                                    }
                                    .onEnded { _ in
                                        lastScale = scale
                                    }
                            )
                        // ⚡ Double tap reset
                            .onTapGesture(count: 2) {
                                withAnimation {
                                    scale = 1
                                    lastScale = 1
                                }
                            }
                            .padding()
                            .background(.black)
                        Spacer()
                    }
                    if(isLandscape){
                        HStack {
                            Button {
                                forcePortrait()
                                path.removeLast()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white )
                                    .padding()
                                    .padding(.horizontal)
                                    .padding(25)
                            }
                            Spacer()
                        }.padding(.horizontal)
                    }
                }.navigationBarBackButtonHidden(true)
                    .onAppear{
                        print("youtube = \(videoId)")
                    }
                    .ignoresSafeArea()
                
                    /*.onReceive(NotificationCenter.default.publisher(
                        for: UIScreen.capturedDidChangeNotification)) { _ in
                            if UIScreen.main.isCaptured {
                                print("Casting detected")
                            }
                    }*/
            }
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
