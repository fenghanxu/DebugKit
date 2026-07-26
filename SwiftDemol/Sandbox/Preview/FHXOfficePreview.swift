//
//  FHXOfficePreview.swift
//  SwiftDemol
//
//  Created by imac on 2026/7/25.
//

import UIKit
import QuickLook

final class FHXOfficePreview: UIView {

    // MARK: - Property

    private let model: FHXSandboxModel

    private let previewController = QLPreviewController()

    // MARK: - Init

    init(model: FHXSandboxModel) {

        self.model = model

        super.init(frame: .zero)

        buildUI()
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func didMoveToWindow() {

        super.didMoveToWindow()

        guard
            window != nil,
            previewController.parent == nil,
            let parent = parentViewController
        else {

            return
        }

        previewController.dataSource = self

        parent.addChild(previewController)

        addSubview(previewController.view)

        previewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            previewController.view.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            previewController.view.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),

            previewController.view.topAnchor.constraint(
                equalTo: topAnchor
            ),

            previewController.view.bottomAnchor.constraint(
                equalTo: bottomAnchor
            )

        ])

        previewController.didMove(
            toParent: parent
        )
    }

    deinit {

        previewController.willMove(
            toParent: nil
        )

        previewController.view.removeFromSuperview()

        previewController.removeFromParent()
    }
}

// MARK: - UI

private extension FHXOfficePreview {

    func buildUI() {

        backgroundColor = .systemBackground
    }
}

// MARK: - QLPreviewControllerDataSource

extension FHXOfficePreview: QLPreviewControllerDataSource {

    func numberOfPreviewItems(
        in controller: QLPreviewController
    ) -> Int {

        1
    }

    func previewController(
        _ controller: QLPreviewController,
        previewItemAt index: Int
    ) -> QLPreviewItem {

        URL(
            fileURLWithPath: model.path
        ) as NSURL
    }
}

// MARK: - UIView

private extension UIView {

    var parentViewController: UIViewController? {

        var responder: UIResponder? = self

        while let next = responder?.next {

            if let controller = next as? UIViewController {

                return controller
            }

            responder = next
        }

        return nil
    }
}
