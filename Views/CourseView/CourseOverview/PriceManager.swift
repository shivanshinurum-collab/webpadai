import Combine

class PriceManager: ObservableObject {

    static let shared = PriceManager()

    @Published var selectedPrice: Double = 0
    @Published var selectedMultiId: String = ""   // selected plan ka id, empty if no multi-price

}
