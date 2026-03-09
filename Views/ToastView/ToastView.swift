import SwiftUI

// MARK: - Toast View
struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.85))
            )
            .shadow(radius: 4)
    }
}

// MARK: - Toast Modifier
struct ToastModifier: ViewModifier {

    @Binding var isShowing: Bool
    let message: String
    let duration: Double = 0.7

    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        ZStack {
            content

            if isShowing {
                VStack {
                    Spacer()
                    ToastView(message: message)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .animation(.easeInOut, value: isShowing)
        .onChange(of: isShowing) {_, newValue in
            if newValue {
                scheduleDismiss()
            } else {
                workItem?.cancel()
            }
        }
    }

    private func scheduleDismiss() {
        workItem?.cancel()

        let task = DispatchWorkItem {
            isShowing = false
        }

        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
}

// MARK: - View Extension
extension View {
    func toast(
        isShowing: Binding<Bool>,
        message: String,
        duration: Double = 0.7
    ) -> some View {
        self.modifier(
            ToastModifier(
                isShowing: isShowing,
                message: message,
            )
        )
    }
}

