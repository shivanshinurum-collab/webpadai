import SwiftUI

struct YouTubeVideoView : View {
    let videoId : String
    let title : String
    
    @Binding var path : NavigationPath
    
    var body: some View {
        
        GeometryReader { geo in
            
            let isLandscape = geo.size.width > geo.size.height
            
            VStack{
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
                
                VStack{
                    YoutubePlayerView(videoId: videoId)
                    Spacer()
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
}
