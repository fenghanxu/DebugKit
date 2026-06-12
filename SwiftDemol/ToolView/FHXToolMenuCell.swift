//
//  FHXToolMenuCell.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/11.
//

import UIKit

class FHXToolMenuCell: UITableViewCell {

    static let identifier = "FHXToolMenuCellID"
    
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
    
    private func buildUI(){
        selectionStyle = .none
        backgroundColor = .clear;
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        contentView.addSubview(rightArrow)
        rightArrow.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }

}
