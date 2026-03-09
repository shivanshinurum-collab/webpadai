import SwiftUI
import WebKit

struct AllDocView: View {

    @Binding var path: NavigationPath
    
    let url: String
    let title: String

    @State private var isLoading = true
    @State private var isDownloading = false
    @State private var showToast = false
    
    @State var isDownload = ""
    
    var body: some View {

        VStack(spacing: 0) {

            // 🔹 Top Bar
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
                    .foregroundColor(.black)
                    .font(.system(size: uiString.titleSize).bold())
                    .lineLimit(1)

                Spacer()

                // ⬇️ Download Button
                if isDownload == "1" {
                    Button {
                        downloadAndSave()
                    } label: {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .disabled(isDownloading)
                }
            }
            .padding()

            // 🔹 Document Viewer
            ZStack {
                WebView(url: URL(string: url)!, isLoading: $isLoading)

                if isLoading || isDownloading {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text(isDownloading ? "Downloading..." : "Loading...")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
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
    }

    // MARK: - Download + Save + Open Offline
    private func downloadAndSave() {
        isDownloading = true
        
        DocumentDownloadManager.shared.downloadAndSave(name: title ,remoteURL: url) { localURL in
            DispatchQueue.main.async {
                isDownloading = false
                
                if localURL != nil {
                    //path.append(DocumentRoute.offline(localURL))
                    showToast = true
                } else {
                    print(" Download failed")
                }
            }
        }
    }
    
    
    func fetchData() {
        let components = URLComponents(
            string: apiURL.generalSetting
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
                let response = try JSONDecoder().decode(AppConfigResponse.self, from: data)
               
                
                DispatchQueue.main.async {
                    self.isDownload = response.data.isDownloadPdf
                }
            } catch {
                print("❌ Decode Error:", error)
            }
        }.resume()
    }
    
    
}

