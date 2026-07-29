//
//  FHXSandboxCell.swift
//  SwiftDemol
//
//  Created by imac on 2026/7/21.
//

import UIKit
import SnapKit

final class FHXSandboxCell: UITableViewCell {

    static let reuseIdentifier = "FHXSandboxCell"

    private let iconView = UIImageView()

    private let titleLabel = UILabel()

    private let detailLabel = UILabel()

    private let arrowImageView = UIImageView()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {

        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - UI

private extension FHXSandboxCell {

    func buildUI() {

        selectionStyle = .none

        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(arrowImageView)

        titleLabel.font =
        .systemFont(
            ofSize: 16,
            weight: .medium
        )

        titleLabel.textColor =
        .label

        detailLabel.font =
        .systemFont(ofSize: 13)

        detailLabel.textColor =
        .secondaryLabel

        arrowImageView.image =
        UIImage(
            systemName: "chevron.right"
        )

        arrowImageView.tintColor =
        .systemGray3

        iconView.snp.makeConstraints {

            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }

        arrowImageView.snp.makeConstraints {

            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(8)
        }

        titleLabel.snp.makeConstraints {

            $0.left.equalTo(iconView.snp.right).offset(12)
            $0.right.lessThanOrEqualTo(arrowImageView.snp.left).offset(-10)
            $0.top.equalToSuperview().offset(10)
        }

        detailLabel.snp.makeConstraints {

            $0.left.equalTo(titleLabel)
            $0.right.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}

// MARK: - Public

extension FHXSandboxCell {

    func config(
        model: FHXSandboxModel
    ) {

        titleLabel.text = model.name
        
        iconView.image = icon(for: model.fileType)

        if model.isDirectory {

            detailLabel.text =
            "\(model.childrenCount) items"

        } else {

            detailLabel.text =
            "\(title(for: model.fileType)) · \(formatSize(model.fileSize))"
        }
    }
}

// MARK: - Icon

private extension FHXSandboxCell {

    func icon(for type: FHXSandboxFileType) -> UIImage {
        let bundle = Bundle.main.url(forResource: "file", withExtension: "bundle")
        let sdkBundle = Bundle(url: bundle!)
        
        switch type {
            case .folder:
                return UIImage(named: "folder", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .image:
                return UIImage(named: "image", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .json:
                return UIImage(named: "json", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .text:
                return UIImage(named: "text", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .plist:
                return UIImage(named: "plist", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .sqlite:
                return UIImage(named: "sqlite", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .pdf:
                return UIImage(named: "pdf", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .zip:
                return UIImage(named: "zip", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .video:
                return UIImage(named: "video", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .audio:
                return UIImage(named: "audio", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .word:
                return UIImage(named: "Word", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .excel:
                return UIImage(named: "excel", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .powerpoint:
                return UIImage(named: "PPT", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .gif:
                return UIImage(named: "GIF", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .svg:
                return UIImage(named: "svg", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .tif:
                return UIImage(named: "TIF", in: sdkBundle, compatibleWith: nil) ?? UIImage()
            case .unknown:
                return UIImage(named: "unknown", in: sdkBundle, compatibleWith: nil) ?? UIImage()
        }
    }

    func title(
        for type: FHXSandboxFileType
    ) -> String {

        switch type {

        case .folder:

            return "Folder"

        case .image:

            return "Image"

        case .json:

            return "JSON"

        case .text:

            return "Text"

        case .plist:

            return "Plist"

        case .sqlite:

            return "SQLite"

        case .pdf:

            return "PDF"

        case .zip:

            return "ZIP"

        case .video:

            return "Video"

        case .audio:

            return "Audio"
            
        case .word:
            return "Word"
            
        case .excel:
            return "excel"
            
        case .powerpoint:
            return "PPT"
            
        case .gif:
           return "GIF"
        case .svg:
            return "SVG"
        case .tif:
            return "TIF"
        case .unknown:

            return "Unknown"
        }
    }
}

// MARK: - Size

private extension FHXSandboxCell {

    func formatSize(
        _ size: UInt64
    ) -> String {

        ByteCountFormatter.string(
            fromByteCount: Int64(size),
            countStyle: .file
        )
    }
}
