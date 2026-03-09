import SwiftUI

enum PlayerSettingsRoute {
    case root
    case quality
    case speed
}

struct PlayerSettingsState {
    var quality: String = "720p"
    var speed: Double = 1.0
}

struct PlayerSettingsSheet: View {

    @Binding var isPresented: Bool
    @Binding var state: PlayerSettingsState
    let controller: YouTubePlayerViewController?

    @State private var route: PlayerSettingsRoute = .root

    var body: some View {
        VStack(spacing: 0) {

            switch route {
            case .root:
                rootView
            case .quality:
                qualityView
            case .speed:
                speedView
            }

            Spacer()
        }
        .padding(.horizontal)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 8)
        }
    }

    // MARK: - Root

    private var rootView: some View {
        VStack(spacing: 20) {

            row(
                title: "Video Quality",
                value: state.quality
            ) {
                route = .quality
            }

            row(
                title: "Playback Speed",
                value: speedLabel(state.speed)
            ) {
                route = .speed
            }
        }
    }

    // MARK: - Quality list

    private var qualityView: some View {
        VStack(spacing: 16) {
            header("Video Quality")

            ForEach(["360p","480p","720p","1080p"], id: \.self) { q in
                Button {
                    state.quality = q
                    controller?.setQuality(mapQuality(q))
                    route = .root
                } label: {
                    optionRow(q, selected: q == state.quality)
                }
            }
        }
    }

    // MARK: - Speed list

    private var speedView: some View {
        VStack(spacing: 16) {
            header("Playback Speed")

            ForEach([0.5,1.0,1.5,2.0], id: \.self) { s in
                Button {
                    state.speed = s
                    controller?.setSpeed(s)
                    route = .root
                } label: {
                    optionRow(speedLabel(s), selected: s == state.speed)
                }
            }
        }
    }

    // MARK: - UI helpers

    private func row(title: String, value: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16))

                Spacer()

                Text(value)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 14)
        }
    }

    private func optionRow(_ title: String, selected: Bool) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 16))

            Spacer()

            if selected {
                Image(systemName: "checkmark")
                    .font(.system(size: 15, weight: .bold))
            }
        }
        .padding(.vertical, 12)
    }

    private func header(_ title: String) -> some View {
        VStack(spacing: 0) {

            HStack {
                Button {
                    route = .root
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                }
                .frame(width: 44, height: 44)

                Spacer()

                Text(title)
                    .font(.system(size: 17, weight: .semibold))

                Spacer()

                // balance spacing
                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 4)

            Divider()
                .padding(.bottom, 8)
        }
    }

    private func speedLabel(_ s: Double) -> String {
        s == floor(s) ? "\(Int(s))x" : "\(s)x"
    }

    private func mapQuality(_ q: String) -> String {
        switch q {
        case "360p": return "medium"
        case "480p": return "large"
        case "720p": return "hd720"
        case "1080p": return "hd1080"
        default: return "auto"
        }
    }
}
