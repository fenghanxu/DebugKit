//
//  FHXPDFPreview.swift
//  SwiftDemol
//
//  Created by imac on 2026/7/25.
//

/**
 ✅ 自动缩放（autoScales = true）
 ✅ 双指缩放
 ✅ 连续滚动浏览
 ✅ 系统 PDFKit 渲染（与「文件」App 一致）
 ✅ 支持几十 MB、几百页 PDF
 ✅ 文本可选中（PDF 本身包含文字时）
 */

import UIKit
import PDFKit

final class FHXPDFPreview: UIView {

    // MARK: - Property

    private let model: FHXSandboxModel

    private let pdfView = PDFView()

    // MARK: - Init

    init(model: FHXSandboxModel) {

        self.model = model

        super.init(frame: .zero)

        buildUI()

        loadPDF()
    }

    required init?(coder: NSCoder) {

        fatalError()
    }
}

// MARK: - UI

private extension FHXPDFPreview {

    func buildUI() {

        backgroundColor = .systemBackground

        pdfView.translatesAutoresizingMaskIntoConstraints = false

        pdfView.autoScales = true

        pdfView.displayMode = .singlePageContinuous

        pdfView.displayDirection = .vertical

        pdfView.displaysPageBreaks = true

        pdfView.usePageViewController(false)

        addSubview(pdfView)

        NSLayoutConstraint.activate([

            pdfView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            pdfView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),

            pdfView.topAnchor.constraint(
                equalTo: topAnchor
            ),

            pdfView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            )

        ])
    }
}

// MARK: - Load

private extension FHXPDFPreview {

    func loadPDF() {

        guard
            let document = PDFDocument(
                url: URL(fileURLWithPath: model.path)
            )
        else {

            let label = UILabel()

            label.text = "无法打开 PDF"

            label.textAlignment = .center

            label.textColor = .secondaryLabel

            addSubview(label)

            label.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([

                label.centerXAnchor.constraint(
                    equalTo: centerXAnchor
                ),

                label.centerYAnchor.constraint(
                    equalTo: centerYAnchor
                )

            ])

            return
        }

        pdfView.document = document
    }
}
