import UIKit

class FHXToolSubMenuCell: UITableViewCell {

    static let identifier = "FHXToolSubMenuCellID"
    
    lazy var titleLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lable.textColor = .black
        return lable
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        return view
    }()
    
    static func cell(with tableview: UITableView) -> FHXToolSubMenuCell {
        var cell = tableview.dequeueReusableCell(withIdentifier: identifier) as? FHXToolSubMenuCell
        if cell == nil {
            cell = FHXToolSubMenuCell(style: .default, reuseIdentifier: identifier)
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

    private func buildUI(){
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            line.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            line.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            line.heightAnchor.constraint(equalToConstant: 1),
            line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
