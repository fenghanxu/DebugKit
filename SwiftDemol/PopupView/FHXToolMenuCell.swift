import UIKit

class FHXToolMenuCell: UITableViewCell {

    static let identifier = "FHXToolMenuCellID"
    
    lazy var titleLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lable.textColor = .black
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rightArrow: UIImageView = {
        let imageView = UIImageView()
        let bundle = Bundle.main.url(forResource: "file", withExtension: "bundle")
        let sdkBundle = Bundle(url: bundle!)
        let image = UIImage(
            named: "menuCell_right_arrow",
            in: sdkBundle,
            compatibleWith: nil
        )
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    static func cell(with tableview: UITableView) -> FHXToolMenuCell {
        var cell = tableview.dequeueReusableCell(withIdentifier: identifier) as? FHXToolMenuCell
        if cell == nil {
            cell = FHXToolMenuCell(style: .default, reuseIdentifier: identifier)
        }
        return cell!
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.addSubview(line)
        NSLayoutConstraint.activate([
            line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 1),
            line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(rightArrow)
        NSLayoutConstraint.activate([
            rightArrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            rightArrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightArrow.widthAnchor.constraint(equalToConstant: 20),
            rightArrow.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

}
