import SwiftUI
import StoreKit
import Combine

@MainActor
class IAPManager: ObservableObject {
    
    // MARK: - Published Properties
    @Published var product: Product?
    @Published var isPurchased: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Properties
    let productID: String
    private var transactionListener: Task<Void, Never>?
    
    // MARK: - Init (Dynamic Product ID)
    init(productID: String) {
        self.productID = productID
        
        transactionListener = listenForTransactions()
        
        Task {
            await loadProduct()
            await checkPurchaseStatus()
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    // MARK: - Load Product
    func loadProduct() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let products = try await Product.products(for: [productID])
            
            if let loadedProduct = products.first {
                product = loadedProduct
            } else {
                errorMessage = "Product not found."
            }
        } catch {
            errorMessage = "Failed to load product: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Buy Product
    func buy() async {
        guard let product else {
            errorMessage = "Product not available"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                unlockPurchase()
                await transaction.finish()
                
            case .userCancelled:
                break
                
            case .pending:
                errorMessage = "Payment pending approval."
                
            @unknown default:
                errorMessage = "Unknown purchase result."
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Check Purchase Status
    func checkPurchaseStatus() async {
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result),
               transaction.productID == productID {
                unlockPurchase()
                return
            }
        }
    }
    
    // MARK: - Restore Purchases
    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        
        var found = false
        
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result),
               transaction.productID == productID {
                unlockPurchase()
                found = true
                break
            }
        }
        
        if !found {
            errorMessage = "No previous purchase found."
        }
        
        isLoading = false
    }
    
    // MARK: - Transaction Listener
    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            guard let self else { return }
            
            for await result in Transaction.updates {
                await MainActor.run {
                    if let transaction = try? self.checkVerified(result),
                       transaction.productID == self.productID {
                        self.unlockPurchase()
                        Task {
                            await transaction.finish()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Unlock
    private func unlockPurchase() {
        isPurchased = true
        errorMessage = nil
    }
    
    // MARK: - Verification
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw NSError(domain: "IAPError",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Transaction verification failed"])
        }
    }
}



/*import SwiftUI
import StoreKit
import Combine

@MainActor
class IAPManager: ObservableObject {

    
    // MARK: - Published Properties
    @Published var product: Product?
    @Published var isPurchased: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Product ID
    let productID = "com.app.marine.wisdom.study.course001"
    
    // MARK: - Transaction Listener Task
    private var transactionListener: Task<Void, Error>?
    
    // MARK: - Init
    init() {
        // Start transaction listener first
        transactionListener = listenForTransactions()
        
        Task {
            await loadProduct()
            await checkPurchaseStatus()
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Load Product
    func loadProduct() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let products = try await Product.products(for: [productID])
            
            if let loadedProduct = products.first {
                product = loadedProduct
            } else {
                errorMessage = "Product not found. Please check your configuration."
            }
        } catch {
            print(" Product load failed:", error)
            errorMessage = "Failed to load product: \(error.localizedDescription)"
        }
        
        isLoading = false
    }

    // MARK: - Buy Product
    func buy() async {
        guard let product else {
            errorMessage = "Product not available"
            return
        }
        
        isLoading = true
        errorMessage = nil

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                unlockPurchase()
                await transaction.finish()
                
            case .userCancelled:
                print(" User cancelled purchase")
                errorMessage = nil // Don't show error for cancellation
                
            case .pending:
                print(" Payment pending")
                errorMessage = "Payment is pending approval"
                
            @unknown default:
                errorMessage = "Unknown purchase result"
            }
        } catch {
            print(" Purchase error:", error)
            errorMessage = "Purchase failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }

    // MARK: - Check Purchase Status (replaces auto-restore in init)
    func checkPurchaseStatus() async {
        // Check current entitlements without triggering restore UI
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result),
               transaction.productID == productID {
                unlockPurchase()
                return // Exit once found
            }
        }
    }
    
    // MARK: - Restore Purchases (manual only)
    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        
        var foundPurchase = false
        
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result),
               transaction.productID == productID {
                unlockPurchase()
                foundPurchase = true
                break
            }
        }
        
        if !foundPurchase {
            errorMessage = "No previous purchase found"
        }
        
        isLoading = false
    }

    // MARK: - Transaction Listener
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self = self else { return }
                
                await MainActor.run {
                    if let transaction = try? self.checkVerified(result),
                       transaction.productID == self.productID {
                        self.unlockPurchase()
                        Task {
                            await transaction.finish()
                        }
                    }
                }
            }
        }
    }

    // MARK: - Unlock Purchase
    private func unlockPurchase() {
        
                     
        isPurchased = true
        UserDefaults.standard.set(true, forKey: "isPurchased")
        errorMessage = nil
    }

    // MARK: - Verify Transaction
    private func checkVerified<T>(
        _ result: VerificationResult<T>
    ) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw NSError(
                domain: "IAPError",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Transaction verification failed"]
            )
        }
    }
}
*/

