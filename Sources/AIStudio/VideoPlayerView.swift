import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoURL: URL

    var body: some View {
        VideoPlayer(player: AVPlayer(url: videoURL))
            .frame(maxWidth: .infinity)
    }
}
