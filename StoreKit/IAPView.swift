import SwiftUI
import StoreKit

struct IAPView: View {
    
    let productId: String
    @Binding var path: NavigationPath
    
    @StateObject private var iap: IAPManager
    
    // Custom initializer
    init(productId: String, path: Binding<NavigationPath>) {
        self.productId = productId
        self._path = path
        
        let finalProductID = "\(uiString.productId)\(productId)"
        _iap = StateObject(wrappedValue: IAPManager(productID: finalProductID))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            if let error = iap.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            if iap.isLoading {
                ProgressView("Processing...")
                    .padding()
            }
            
            if let product = iap.product {
                
                Text(product.displayName)
                    .font(.title2)
                    .bold()
                
                Text(product.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text(product.displayPrice)
                    .font(.headline)
                    .padding(.top, 8)
                
                Spacer().frame(height: 20)
                
                if iap.isPurchased {
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                        
                        Text("Course Unlocked")
                            .foregroundColor(.green)
                            .font(.title3)
                            .bold()
                    }
                } else {
                    Button {
                        Task { await iap.buy() }
                    } label: {
                        Text("Buy Course")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(iap.isLoading)
                }
                
            } else if !iap.isLoading {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    
                    Text("Product Unavailable")
                        .font(.headline)
                    
                    Button("Retry") {
                        Task { await iap.loadProduct() }
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .navigationTitle("Purchase Course")
    }
}



/*import SwiftUI
import StoreKit

struct IAPView: View {
    @Binding var path: NavigationPath
    @StateObject private var iap = IAPManager()

    var body: some View {
        VStack(spacing: 20) {
            
            // Error Message
            if let error = iap.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            // Loading State
            if iap.isLoading {
                ProgressView("Processing...")
                    .padding()
            }
            
            // Product Info
            if let product = iap.product {
                
                Text(product.displayName)
                    .font(.title2)
                    .bold()

                Text(product.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text(product.displayPrice)
                    .font(.headline)
                    .padding(.top, 8)

                Spacer().frame(height: 20)
                
                // Purchase Status
                if iap.isPurchased {
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                        
                        Text("Course Unlocked")
                            .foregroundColor(.green)
                            .font(.title3)
                            .bold()
                    }
                } else {
                    Button {
                        Task { await iap.buy() }
                    } label: {
                        Text("Buy Course")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(iap.isLoading)
                }

                // Restore Button
/*                Button {
                    Task { await iap.restorePurchases() }
                } label: {
                    Text("Restore Purchase")
                        .foregroundColor(.blue)
                }
                .padding(.top)
                .disabled(iap.isLoading || iap.isPurchased)
*/
            } else if !iap.isLoading {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    
                    Text("Product Unavailable")
                        .font(.headline)
                    
                    Button("Retry") {
                        Task { await iap.loadProduct() }
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .navigationTitle("Purchase Course")
    }
}
*/
