//
//  FHXLogViewController.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/4.
//

import UIKit
import SnapKit

class FHXLogViewController: UIViewController {
    
    var keyWindowApp: UIWindow?
    
    var screenWidth: CGFloat?
    
    var screenHeight: CGFloat?
    
    var totalTopHeight: CGFloat?

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
        navigationView.delegate = self
        return navigationView
    }()
    
    /// 所有日志
    private var allData: [FHXLogModel] = []

    /// 当前显示日志
    private var data: [FHXLogModel] = []

    /// 当前筛选
    private var currentFilter: FHXLogFilter = .all
    
    /// 筛选枚举
    private enum FHXLogFilter {
        case all
        case debug
        case network
        case error
        case crash
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupUI()
        loadData()
        addNotification()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        allData = FHXLog.shared.allLogs()
        applyFilter()
    }
    
    private func applyFilter() {
        switch currentFilter {
            case .all:
                data = allData
            case .debug:
                data = allData.filter {
                    $0.level == .debug
                }
            case .network:
                data = allData.filter {
                    $0.level == .network
                }
            case .error:
                data = allData.filter {
                    $0.level == .error
                }
            case .crash:
                data = allData.filter {
                    $0.level == .crash
                }
        }

        tableView.reloadData()
    }
    
    private func addNotification() {

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(logDidAppend(_:)),
            name: .fhxLogDidAppend,
            object: nil
        )
    }
    
    @objc
    private func logDidAppend(_ notification: Notification) {

        guard let model = notification.object as? FHXLogModel else {
            return
        }

        data.append(model)
        
        applyFilter()

        let indexPath = IndexPath(
            row: data.count - 1,
            section: 0
        )

        tableView.performBatchUpdates({

            tableView.insertRows(
                at: [indexPath],
                with: .none
            )

        }, completion: { _ in

            self.scrollToBottom()

        })
    }
    
    private func scrollToBottom() {

        guard data.count > 0 else {
            return
        }

        let indexPath = IndexPath(
            row: data.count - 1,
            section: 0
        )

        tableView.scrollToRow(
            at: indexPath,
            at: .bottom,
            animated: true
        )
    }

}

extension FHXLogViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FHXLogCell = FHXLogCell.cell(with: tableView)

        cell.levelLabel.text = "\(data[indexPath.row].level)"
        
        cell.messageLabel.text = "\(data[indexPath.row].file)." + "\(data[indexPath.row].function):" + "[\(data[indexPath.row].line)] "

        if data[indexPath.row].level.rawValue == 0 {// debug
            cell.levelLabel.backgroundColor = UIColor(red: 0.0/255.0, green: 211.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        } else if data[indexPath.row].level.rawValue == 1 {// network
            cell.levelLabel.backgroundColor = UIColor(red: 0.0/255.0, green: 170.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        } else if data[indexPath.row].level.rawValue == 2 {// error
            cell.levelLabel.backgroundColor = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        } else if data[indexPath.row].level.rawValue == 3 {// crash
            cell.levelLabel.backgroundColor = UIColor(red: 255.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.timeLabel.text = formatter.string(from: data[indexPath.row].time)
    
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {

        let model = data[indexPath.row]

        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { _ in

            let copyAction = UIAction(
                title: "复制日志",
                image: UIImage(systemName: "doc.on.doc")
            ) { _ in

                let text =
                "\(model.file)." +
                "\(model.function):" +
                "[\(model.line)]\n" +
                "\(model.message)"

                UIPasteboard.general.string = text

                print("复制成功")
            }

            return UIMenu(
                title: "",
                children: [copyAction]
            )
        }
    }

}

extension FHXLogViewController:FHXNavigationViewDelegate{

    func fhxNavigationView(view:FHXNavigationView, buttonClick button:UIButton) {
        if button.tag == 0 {
            navigationController?.popViewController(animated: true)
        } else if button.tag == 1 {

            guard let keyWindowAppPartial = self.keyWindowApp,
                  let screenWidthPartial = self.screenWidth,
                  let screenHeightPartial = self.screenHeight,
                  let totalTopHeightPartial = self.totalTopHeight
            else {
                return
            }
            
            FHXToolView.showCurrentView(
                vc: self,
                winApp: keyWindowAppPartial,
                screenWidth: screenWidthPartial,
                screenHeight: screenHeightPartial,
                totalTopHeight: totalTopHeightPartial,
                menuList: ["筛选", "搜索"],
                subMenuList: ["All","Debug", "Network", "Error", "Crash"]
            ) {[weak self] value in
                guard let self = self else { return }
                if value == "All" {
                    self.currentFilter = .all
                } else if value == "Debug" {
                    self.currentFilter = .debug
                } else if value == "Network" {
                    self.currentFilter = .network
                } else if value == "Error" {
                    self.currentFilter = .error
                } else if value == "Crash" {
                    self.currentFilter = .crash
                }
                applyFilter()
            }

        }
    }
}
