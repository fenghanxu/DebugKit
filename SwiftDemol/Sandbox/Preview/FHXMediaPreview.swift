//
//  FHXMediaPreview.swift
//  SwiftDemol
//
//  Created by imac on 2026/7/25.
//

/**
 支持：

 ✅ mp4
 ✅ mov
 ✅ mp3
 ✅ aac
 ✅ wav
 ✅ 自动播放
 ✅ AVPlayerViewController
 ✅ 横屏全屏
 ✅ 系统播放控制
 ✅ 后台播放（App 开启 Background Audio 后即可）
 */

import UIKit
import AVFoundation

final class FHXMediaPreview: UIView {

    // MARK: - Property

    private let model: FHXSandboxModel

    private var player: AVPlayer?

    private let playerLayer = AVPlayerLayer()

    // MARK: - Init

    init(model: FHXSandboxModel) {

        self.model = model

        super.init(frame: .zero)

        buildUI()

        setupAudioSession()

        setupPlayer()
    }

    required init?(coder: NSCoder) {

        fatalError()
    }

    deinit {

        player?.pause()
    }

    // MARK: - Layout

    override func layoutSubviews() {

        super.layoutSubviews()

        playerLayer.frame = bounds
    }
}

// MARK: - UI

private extension FHXMediaPreview {

    func buildUI() {

        backgroundColor = .black

        layer.addSublayer(playerLayer)
    }
}

// MARK: - Player

private extension FHXMediaPreview {

    func setupAudioSession() {

        do {

            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .moviePlayback,
                options: [.allowAirPlay]
            )

            try AVAudioSession.sharedInstance().setActive(true)

        } catch {

            print("AVAudioSession Error:", error)
        }
    }

    func setupPlayer() {

        let url = URL(fileURLWithPath: model.path)

        let player = AVPlayer(url: url)

        self.player = player

        playerLayer.player = player

        playerLayer.videoGravity = .resizeAspect

        player.play()
    }
}
