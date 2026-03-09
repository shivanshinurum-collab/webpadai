import SwiftUI
import WebKit
import Foundation
import QuickLook

// MARK: - Navigation Routes

enum DocumentRoute: Hashable {
    case offline(URL)
}

// MARK: - Supported Document Types

enum DocumentType: String, CaseIterable {
    case pdf = "pdf"
    case doc = "doc"
    case docx = "docx"
    case xls = "xls"
    case xlsx = "xlsx"
    case ppt = "ppt"
    case pptx = "pptx"
    case txt = "txt"
    case rtf = "rtf"
    case csv = "csv"
    case jpg = "jpg"
    case jpeg = "jpeg"
    case png = "png"
    case gif = "gif"
    case zip = "zip"
    case mp4 = "mp4"
    case mov = "mov"
    
    var icon: String {
        switch self {
        case .pdf:
            return "doc.fill"
            //return "pdf"
        case .doc, .docx:
            return "doc.richtext.fill"
        case .xls, .xlsx, .csv:
            return "tablecells.fill"
        case .ppt, .pptx:
            return "play.rectangle.fill"
        case .txt, .rtf:
            return "doc.text.fill"
        case .jpg, .jpeg, .png, .gif:
            return "photo.fill"
        case .zip:
            return "doc.zipper"
        case .mp4, .mov:
            return "play.circle.fill"
        }
    }
}


struct DownloadsView: View {
    
    @Binding var path : NavigationPath
    
    var body: some View {
        DownloadedDocsView(path: $path)
            .navigationDestination(for: DocumentRoute.self) { route in
                switch route {
                case .offline(let url):
                    OfflineDocumentView(path : $path,localURL: url)
                }
            }
        
    }
}


// MARK: - Downloaded Documents List

struct DownloadedDocsView: View {
    
    @Binding var path: NavigationPath
    @State private var files: [URL] = []
    @State private var searchText = ""
    
    var filteredFiles: [URL] {
        if searchText.isEmpty {
            return files
        }
        return files.filter { $0.lastPathComponent.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search files...", text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .padding()
            
            if filteredFiles.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text(searchText.isEmpty ? "No Downloaded Files" : "No Results Found")
                        .font(.title3.bold())
                        .foregroundColor(.gray)
                    
                    Text(searchText.isEmpty ? "Download documents to view them offline" : "Try a different search term")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(filteredFiles, id: \.self) { file in
                        Button {
                            path.append(DocumentRoute.offline(file))
                        } label: {
                            FileRowView(fileURL: file)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteFile(file)
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Downloaded Files")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: uiString.backSize))
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if !files.isEmpty {
                    Menu {
                        Button(role: .destructive) {
                            deleteAllFiles()
                        } label: {
                            Label("Delete All", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .onAppear {
            refreshFiles()
        }
    }
    
    private func refreshFiles() {
        files = FileDownloader.shared.getAllDownloadedFiles()
    }
    
    private func deleteFile(_ file: URL) {
        try? FileManager.default.removeItem(at: file)
        refreshFiles()
    }
    
    private func deleteAllFiles() {
        files.forEach { try? FileManager.default.removeItem(at: $0) }
        refreshFiles()
    }
}

struct FileRowView: View {
    let fileURL: URL
    
    var fileType: DocumentType? {
        DocumentType(rawValue: fileURL.pathExtension.lowercased())
    }
    
    var fileSize: String {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
              let size = attributes[.size] as? Int64 else {
            return "Unknown"
        }
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: fileType?.icon ?? "doc.fill")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(fileURL.lastPathComponent)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack {
                    Text(fileType?.rawValue.uppercased() ?? "FILE")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.blue)
                        .cornerRadius(5)
                    
                    Text(fileSize)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Offline Document Viewer

struct OfflineDocumentView: View {
    
    @Binding var path : NavigationPath
    
    let localURL: URL
    @State private var isLoading = true
    @State private var showQuickLook = false
    
    var fileType: DocumentType? {
        DocumentType(rawValue: localURL.pathExtension.lowercased())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack{
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: uiString.backSize))
                        .foregroundColor(.black)
                        .padding(.horizontal)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(localURL.lastPathComponent)
                        .font(.headline)
                        .lineLimit(2)
                    
                    HStack {
                        Label(fileType?.rawValue.uppercased() ?? "FILE", systemImage: fileType?.icon ?? "doc")
                            .font(.caption)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        if let size = getFileSize() {
                            Text(size)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                //.shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                
            }
            ZStack {
                if let fileType, shouldUseQuickLook(for: fileType) {
                    QuickLookView(url: localURL, isPresented: $showQuickLook)
                        .onAppear {
                            showQuickLook = true
                            isLoading = false
                        }
                } else {
                    DocumentWebView(url: localURL, isLoading: $isLoading)
                }
                
                if isLoading {
                    VStack(spacing: 15) {
                        ProgressView()
                            .scaleEffect(1.5)
                        
                        Text("Loading document...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(30)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func shouldUseQuickLook(for type: DocumentType) -> Bool {
        switch type {
        case .pdf, .doc, .docx, .xls, .xlsx, .ppt, .pptx, .jpg, .jpeg, .png, .gif, .zip, .mp4, .mov:
            return true
        case .txt, .rtf, .csv:
            return false
        }
    }
    
    private func getFileSize() -> String? {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: localURL.path),
              let size = attributes[.size] as? Int64 else {
            return nil
        }
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
}

// MARK: - File Downloader

final class FileDownloader {
    static let shared = FileDownloader()
    private init() {}
    
    func localFileURL(for remoteURL: String) -> URL {
        let fileName = URL(string: remoteURL)?.lastPathComponent ?? "document"
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(fileName)
    }
    
    func fileExists(remoteURL: String) -> Bool {
        FileManager.default.fileExists(atPath: localFileURL(for: remoteURL).path)
    }
    
    func downloadFile(remoteURL: String, completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: remoteURL) else {
            completion(nil)
            return
        }
        
        URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            guard let tempURL, error == nil else {
                completion(nil)
                return
            }
            
            let localURL = self.localFileURL(for: remoteURL)
            try? FileManager.default.removeItem(at: localURL)
            
            do {
                try FileManager.default.moveItem(at: tempURL, to: localURL)
                completion(localURL)
            } catch {
                print("Error moving file: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func getAllDownloadedFiles() -> [URL] {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let files = (try? FileManager.default.contentsOfDirectory(
            at: documents,
            includingPropertiesForKeys: [.fileSizeKey, .creationDateKey],
            options: [.skipsHiddenFiles]
        )) ?? []
        
        // Filter supported document types
        let supportedExtensions = DocumentType.allCases.map { $0.rawValue }
        return files.filter { supportedExtensions.contains($0.pathExtension.lowercased()) }
            .sorted { file1, file2 in
                let date1 = (try? file1.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                let date2 = (try? file2.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                return date1 > date2
            }
    }
}

// MARK: - WebView for Documents

struct DocumentWebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        
        if url.isFileURL {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        } else {
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Intentionally empty to prevent reload
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, WKNavigationDelegate {
        let parent: DocumentWebView
        
        init(_ parent: DocumentWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}

// MARK: - QuickLook View

struct QuickLookView: UIViewControllerRepresentable {
    let url: URL
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> QuickLookViewController {
        let controller = QuickLookViewController()
        controller.url = url
        return controller
    }
    
    func updateUIViewController(_ uiViewController: QuickLookViewController, context: Context) {
        uiViewController.url = url
        uiViewController.reloadData()
    }
}

class QuickLookViewController: QLPreviewController, QLPreviewControllerDataSource {
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return url != nil ? 1 : 0
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return url! as QLPreviewItem
    }
}

