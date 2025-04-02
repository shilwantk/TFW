//
//  VideoView.swift
//  zala
//
//  Created by Kyle Carriedo on 10/12/24.
//

import SwiftUI
import AVKit

struct VideoView:View {
            
    @Environment(\.dismiss) var dismiss
    let videoURL: URL
    @State private var player: AVPlayer

       init(videoURL: URL) {
           self.videoURL = videoURL
           self._player = State(initialValue: AVPlayer(url: videoURL))
       }
    
    var body: some View {
        VideoPlayer(player: player)
            .frame(height: 400)
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image.close
                    }
                }
            })
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
}


import SwiftUI
import AVKit

struct FullScreenVideoPlayer: UIViewControllerRepresentable {
    let videoURL: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: videoURL)
        let controller = AVPlayerViewController()
        controller.player = player
        controller.modalPresentationStyle = .fullScreen
        controller.player?.play()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}


struct FullScreenVideoView: View {
    @Environment(\.dismiss) var dismiss
    
    let videoURL: URL
    
    var body: some View {
        VStack {
            FullScreenVideoPlayer(videoURL: videoURL)
                .edgesIgnoringSafeArea(.all)
        }
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    dismiss()
                } label: {
                    Image.close
                }
            }
        })
    }
}
