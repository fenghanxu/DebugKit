//
//  FHXLogCell.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/4.
//

import UIKit

class FHXLogCell: UITableViewCell {

    static let identifier = "FHXLogCellID"
    
    lazy private var line:UIView = {
        var line = UIView()
        line.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
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
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    
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
        backgroundColor = .white;
        
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(60)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(levelLabel)
            make.left.equalTo(levelLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(levelLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
    }

}
