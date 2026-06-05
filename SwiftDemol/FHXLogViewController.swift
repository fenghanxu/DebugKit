//
//  FHXLogViewController.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/4.
//

import UIKit
import SnapKit

class FHXLogViewController: UIViewController {

    lazy private var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.register(FHXLogCell.self, forCellReuseIdentifier: FHXLogCell.identifier)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        return tableView
    }()
    
    lazy private var navigatonView : FHXNavigationView = {
        let navigationView = FHXNavigationView()
        return navigationView
    }()
    
    private var heightConstraint: Constraint?
    
    private var data: [FHXLogModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupUI()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        navigatonView.snp.updateConstraints({ make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(view.safeAreaInsets.top + 44)
        })
    }

    
    private func setupUI() {
        view.addSubview(navigatonView)
        navigatonView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigatonView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func loadData() {
        data = FHXLog.shared.allLogs()
        tableView.reloadData()
    }

}

extension FHXLogViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FHXLogCell = FHXLogCell.cell(with: tableView)

        cell.levelLabel.text = "\(data[indexPath.row].level)"
        
        cell.messageLabel.text = "\(data[indexPath.row].file)." + "\(data[indexPath.row].function):" + "[\(data[indexPath.row].line)] "

        if data[indexPath.row].level.rawValue == 0 {// debug
            cell.levelLabel.backgroundColor = UIColor(hex: 0x00DDDD)
        } else if data[indexPath.row].level.rawValue == 1 {// info
            cell.levelLabel.backgroundColor = UIColor(hex: 0x00AA00)
        } else if data[indexPath.row].level.rawValue == 2 {// warning
            cell.levelLabel.backgroundColor = UIColor(hex: 0xFFCC22)
        } else if data[indexPath.row].level.rawValue == 3 {// error
            cell.levelLabel.backgroundColor = UIColor(hex: 0xFF3333)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8 // 行间距

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.black
        ]

        cell.contentLabel.attributedText = NSAttributedString(
            string: "\(data[indexPath.row].message)",
            attributes: attributes
        )
    
        return cell
    }

}

extension UIColor {
    
    /// UIColor(hex: 0xFFFFFF)
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red   = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue  = CGFloat(hex & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// UIColor.hex(0xFFFFFF)
    static func hex(_ hex: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        UIColor(hex: hex, alpha: alpha)
    }
}
