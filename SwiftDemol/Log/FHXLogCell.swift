

import UIKit

class FHXLogCell: UITableViewCell {

    static let identifier = "FHXLogCellID"

    /// 点击展开回调
    var expandBlock:(()->Void)?

    lazy private var line:UIView = {
        var line = UIView()
        line.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.text = "error"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .red
        label.textAlignment = .center
        label.layer.cornerRadius = 4.0
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var methodNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var expandButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("展开", for: .normal)
        button.setTitleColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 219.0/255.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.isHidden = true
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 219.0/255.0, alpha: 1.0).cgColor
        button.clipsToBounds = true
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var expandButtonHeightConstraint: NSLayoutConstraint?

    static func cell(with tableview: UITableView) -> FHXLogCell {
        var cell = tableview.dequeueReusableCell(withIdentifier: identifier) as? FHXLogCell
        if cell == nil {
            cell = FHXLogCell(style: .default, reuseIdentifier: identifier)
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
        backgroundColor = .white

        contentView.addSubview(line)
        contentView.addSubview(levelLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(methodNameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(expandButton)

        expandButtonHeightConstraint = expandButton.heightAnchor.constraint(equalToConstant: 30)

        NSLayoutConstraint.activate([

            // line
            line.heightAnchor.constraint(equalToConstant: 1),
            line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // levelLabel
            levelLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            levelLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            levelLabel.widthAnchor.constraint(equalToConstant: 60),
            levelLabel.heightAnchor.constraint(equalToConstant: 22),

            // timeLabel
            timeLabel.centerYAnchor.constraint(equalTo: levelLabel.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: levelLabel.trailingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // methodNameLabel
            methodNameLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 5),
            methodNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            methodNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // contentLabel
            contentLabel.topAnchor.constraint(equalTo: methodNameLabel.bottomAnchor, constant: 5),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // expandButton
            expandButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 5),
            expandButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            expandButton.widthAnchor.constraint(equalToConstant: 50),
            expandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            expandButtonHeightConstraint!
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.commit()
    }

    /// 外部调用判断是否显示按钮
    func showExpandButton(_ show:Bool){
        expandButton.isHidden = !show
        expandButtonHeightConstraint?.constant = show ? 30 : 0
        layoutIfNeeded()
    }

}
