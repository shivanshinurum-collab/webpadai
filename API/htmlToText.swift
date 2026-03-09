
    import SwiftUI
struct html {
    
    
    static func htmlToAttributedString(_ html: String) -> AttributedString {
        let data = Data(html.utf8)
        if let attributed = try? AttributedString(
            NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
        ) {
            return attributed
        }
        return AttributedString(html)
    }
    
}
