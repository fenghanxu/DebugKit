//
//  FHXSandboxPreviewController.swift
//  SwiftDemol
//
//  Created by imac on 2026/7/25.
//

/**
 Sandbox
 │
 ├── 文件浏览
 │      ✅
 │
 ├── 图片浏览
 │      ✅
 │
 ├── JSON
 │      ✅ Pretty Print
 │
 ├── TXT
 │      ✅
 │
 ├── LOG
 │      ✅
 │
 ├── Plist
 │      ✅
 │
 ├── PDF
 │      ✅
 │
 ├── Video
 │      ✅
 │
 └── Audio
        ✅
 */

import UIKit

final class FHXSandboxPreviewController: UIViewController {

    // MARK: - Property

    private let model: FHXSandboxModel

    // MARK: - Init

    init(
        model: FHXSandboxModel
    ) {

        self.model = model

        super.init(
            nibName: nil,
            bundle: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Life

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        title = model.name

        loadPreview()
    }

}

// MARK: - Preview

private extension FHXSandboxPreviewController {

    func loadPreview() {

        switch model.fileType {

        case .image:
            let preview = FHXImagePreview(model: model)
            preview.singleTapHandler = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            showView(preview)
        case .gif:
            showView(FHXGIFPreview(model: model))
        case .json,
             .text,
             .plist:
            showView(FHXTextPreview(model: model))
        case .pdf:
            showView(FHXPDFPreview(model: model))
        case .video,
             .audio:
            showView(FHXMediaPreview(model: model))
        case .word,
             .excel,
             .powerpoint:
            showView(FHXOfficePreview(model: model))
        case .svg:
            showView(FHXSVGPreview(model: model))
        case .tif:
            showView(FHXTIFPreview(model: model))
        default:
            showInfo()
        }
    }

    // 控制器
    func show(
        _ controller: UIViewController
    ) {

        addChild(controller)

        view.addSubview(controller.view)

        controller.view.frame = view.bounds

        controller.view.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]

        controller.didMove(
            toParent: self
        )
    }
    
    // view
    func showView(
        _ view: UIView
    ) {

        self.view.addSubview(view)


        view.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([

            view.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor
            ),

            view.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor
            ),

            view.topAnchor.constraint(
                equalTo: self.view.topAnchor
            ),

            view.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor
            )

        ])
    }

    func showInfo() {

        let label = UILabel()

        label.textAlignment = .center

        label.numberOfLines = 0

        label.text = """

        暂不支持预览

        \(model.name)

        """

        label.frame = view.bounds

        label.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]

        view.addSubview(label)
    }

}
