import SwiftUI
import PDFKit

struct PDFView: View {
    let pdfURL: String
    let title: String
    
    @State private var pdfDocument: PDFDocument?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            if isLoading {
                VStack {
                    ProgressView()
                    Text("Loading PDF...")
                        .foregroundColor(.gray)
                        .padding(.top)
                }
            } else if let error = errorMessage {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    Text(error)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            } else if let document = pdfDocument {
                //PDFKitView(document: document)
                PDFKitRepresentableView(document: document)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadPDF()
        }
    }
    
    func loadPDF() {
        guard let url = URL(string: pdfURL) else {
            errorMessage = "Invalid PDF URL"
            isLoading = false
            return
        }
        
        // Download PDF
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    errorMessage = "Failed to load PDF: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }
                
                if let document = PDFDocument(data: data) {
                    self.pdfDocument = document
                    print("✅ PDF loaded successfully with \(document.pageCount) pages")
                } else {
                    errorMessage = "Failed to create PDF document"
                }
            }
        }.resume()
    }
}
// ✅ PDFKit wrapper - renamed to avoid conflict
struct PDFKitRepresentableView: UIViewRepresentable {
    let document: PDFDocument
    
    func makeUIView(context: Context) -> PDFKit.PDFView {  // ✅ Explicitly use PDFKit.PDFView
        let pdfView = PDFKit.PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = .systemBackground
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFKit.PDFView, context: Context) {  // ✅ Explicitly use PDFKit.PDFView
        pdfView.document = document
    }
}
/*// PDFKit wrapper for SwiftUI
struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = document
    }
}*/

