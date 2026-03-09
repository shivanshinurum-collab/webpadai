import SwiftUI

struct CourseAbout5: View {

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // MARK: - Title Section
                    VStack(alignment: .leading, spacing: 6) {
                        
                        HStack(alignment: .top) {
                            Text("THEORY GPAT AT YOUR FINGERTIPS (COLOURED HARD COPY BOOK), 3RD EDITION")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            VStack {
                                Image(systemName: "hand.thumbsup")
                                Text("16.20 K")
                                    .font(.caption)
                            }
                            .foregroundColor(.gray)
                        }
                        
                        Text("GPAT • Hard Copy Book • GPAT BOOK • books")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // MARK: - Category Buttons
                    HStack(spacing: 12) {
                        categoryButton(title: "BOOKS & NOTES", icon: "book.fill", color: .green)
                        categoryButton(title: "PDFS", icon: "doc.fill", color: .red)
                        categoryButton(title: "VIDEOS", icon: "video.fill", color: .purple)
                    }
                    
                    // MARK: - Book Image
                    Image("banner") // Add your asset image here
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .cornerRadius(8)
                    
                    Divider()
                    
                    // MARK: - About Section
                    Text("About This Course")
                        .font(.headline)
                    
                    Text("Master your GPAT preparation with \"Theory GPAT at Your Fingertips\" (Coloured Copy Book), 3rd Edition!")
                        .font(.subheadline)
                    
                    Text("📚✨ This book offers clear, concise, and visually engaging content, making complex pharmaceutical concepts easy to grasp. Ideal for quick revision and exam success, it's your essential companion for ...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Read More")
                        .foregroundColor(.blue)
                        .font(.subheadline)
                    
                    Divider()
                    
                    // MARK: - Features
                    
                    featureRow(
                        icon: "clock.fill",
                        title: "Lifetime Access",
                        subtitle: "Buy once and access till whenever you want. No holding your learnings back"
                    )
                    
                    featureRow(
                        icon: "play.circle.fill",
                        title: "3 Learning Material",
                        subtitle: "1 Files, 2 Video lectures"
                    )
                    
                    // MARK: - Highlight Box
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What else you will get?")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        HStack {
                            Image(systemName: "shippingbox.fill")
                                .foregroundColor(.green)
                            
                            VStack(alignment: .leading) {
                                Text("Physical Books")
                                    .fontWeight(.medium)
                                
                                Text("Tentative Delivery within 12 days")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(8)
                    
                    Divider()
                    
                    // MARK: - Help Section
                    
                    HStack {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text("Facing any difficulties, Test?")
                                .font(.subheadline)
                            
                            Text("Talk to us >")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 16) {
                           
                           // MARK: - Title
                           Text("Pricing Details")
                               .font(.headline)
                           
                           // MARK: - Price Box
                           HStack {
                               Text("You Pay")
                                   .foregroundColor(.gray)
                               
                               Spacer()
                               
                               HStack(spacing: 8) {
                                   Text("₹ 1,199")
                                       .foregroundColor(.gray)
                                       .strikethrough()
                                   
                                   Text("₹ 899")
                                       .fontWeight(.bold)
                               }
                           }
                           .padding()
                           .background(Color(.systemGray6))
                           .cornerRadius(8)
                           
                           
                           // MARK: - Coupon Link
                           Text("Have a coupon code? Apply here")
                               .foregroundColor(.blue)
                               .font(.subheadline)
                           
                           
                           // MARK: - Address Box
                           HStack {
                               Image(systemName: "location.fill")
                                   .foregroundColor(.gray)
                               
                               Text("Select Address")
                                   .foregroundColor(.gray)
                               
                               Spacer()
                           }
                           .padding()
                           .background(Color(.systemGray6))
                           .cornerRadius(8)
                           
                           
                           // MARK: - Terms Text
                           Text("* Amount payable is inclusive of taxes. Terms & Conditions apply.")
                               .font(.caption)
                               .foregroundColor(.gray)
                           
                       }
                       .padding()
                
                
            }
        }
    
    func categoryButton(title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(6)
    }

    func featureRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 28, height: 28)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }

}


