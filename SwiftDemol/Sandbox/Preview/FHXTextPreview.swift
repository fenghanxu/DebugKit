import UIKit

final class FHXTextPreview: UIView {

    // MARK: - Property

    private let model: FHXSandboxModel

    private let textView = UITextView()

    // MARK: - Init

    init(
        model: FHXSandboxModel
    ) {

        self.model = model

        super.init(frame: .zero)

        buildUI()

        loadContent()
    }


    required init?(coder: NSCoder) {

        fatalError()
    }
}


// MARK: - UI

private extension FHXTextPreview {

    func buildUI() {

        backgroundColor = .systemBackground

        textView.backgroundColor = .systemBackground

        textView.font =
        UIFont.monospacedSystemFont(
            ofSize: 14,
            weight: .regular
        )

        textView.textColor = .label

        textView.isEditable = false

        textView.alwaysBounceVertical = true

        textView.autocapitalizationType = .none

        textView.autocorrectionType = .no

        textView.smartQuotesType = .no

        textView.smartDashesType = .no

        textView.smartInsertDeleteType = .no


        textView.textContainerInset =
        UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )


        addSubview(textView)


        textView.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([

            textView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            textView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),

            textView.topAnchor.constraint(
                equalTo: topAnchor
            ),

            textView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            )

        ])
    }
}


// MARK: - Load

private extension FHXTextPreview {

    func loadContent() {

        switch model.fileType {

        case .json:

            textView.text =
            prettyJSON()


        case .plist:

            textView.text =
            prettyPlist()


        default:

            textView.text =
            plainText()
        }
    }
}


// MARK: - TXT

private extension FHXTextPreview {

    func plainText() -> String {

        do {

            return try String(
                contentsOfFile: model.path,
                encoding: .utf8
            )

        } catch {

            return "Unable to open file.\n\n\(error)"
        }
    }
}


// MARK: - JSON

private extension FHXTextPreview {

    func prettyJSON() -> String {


        guard
            let data =
            FileManager.default.contents(
                atPath: model.path
            )
        else {

            return "JSON Read Failed"
        }


        do {

            let object =
            try JSONSerialization.jsonObject(
                with: data
            )


            let pretty =
            try JSONSerialization.data(
                withJSONObject: object,
                options: [
                    .prettyPrinted
                ]
            )


            return String(
                data: pretty,
                encoding: .utf8
            ) ?? ""


        } catch {

            return plainText()
        }
    }
}


// MARK: - Plist

private extension FHXTextPreview {

    func prettyPlist() -> String {


        if let dict =
            NSDictionary(
                contentsOfFile: model.path
            ) {

            return dict.description
        }


        if let array =
            NSArray(
                contentsOfFile: model.path
            ) {

            return array.description
        }


        return plainText()
    }
}
