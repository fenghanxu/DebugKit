//
//  FHXSVGPreview.swift
//  SwiftDemol
//
//  Created by imac on 2026/7/25.
//

import UIKit
import WebKit

final class FHXSVGPreview: UIView {

    // MARK: - Property

    private let model: FHXSandboxModel

    private let webView = WKWebView()

    // MARK: - Init

    init(
        model: FHXSandboxModel
    ) {

        self.model = model

        super.init(frame: .zero)

        buildUI()

        loadSVG()
    }

    required init?(coder: NSCoder) {

        fatalError()
    }
}

// MARK: - UI

private extension FHXSVGPreview {

    func buildUI() {

        backgroundColor = .systemBackground

        webView.backgroundColor = .clear

        webView.isOpaque = false

        addSubview(webView)

        webView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            webView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            webView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),

            webView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor
            ),

            webView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            )

        ])
    }
}

// MARK: - Load

private extension FHXSVGPreview {

    func loadSVG() {

        let url = URL(
            fileURLWithPath: model.path
        )

        guard
            let data = try? Data(
                contentsOf: url
            )
        else {

            return
        }

        webView.load(
            data,
            mimeType: "image/svg+xml",
            characterEncodingName: "utf-8",
            baseURL: url.deletingLastPathComponent()
        )
    }
}
