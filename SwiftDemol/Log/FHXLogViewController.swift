

import UIKit
import SnapKit

class FHXLogViewController: UIViewController {
    
    private var keyWindowApp: UIWindow?
    
    private var screenWidth: CGFloat?
     
    private var screenHeight: CGFloat?
    
    private var totalTopHeight: CGFloat?
    
    private var safeAreaTop: CGFloat?
    
    lazy private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.bounds.size.width * 2, height: (screenHeight ?? 0) - (totalTopHeight ?? 0))
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .red
        return scrollView
    }()
    
    lazy private var navigatonView : FHXNavigationView = {
        let navigationView = FHXNavigationView(frame: view.frame, keyWindowApp: keyWindowApp, screenWidth: screenWidth, screenHeight: screenHeight, totalTopHeight: totalTopHeight)
        navigationView.delegate = self
        navigationView.backgroundColor = .green
        return navigationView
    }()

    lazy private var currentTableView: UITableView = {
        var tableView = UITableView()
        tableView.tag = 101
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000.0
        tableView.keyboardDismissMode = .onDrag
        tableView.register(FHXLogCell.self, forCellReuseIdentifier: FHXLogCell.identifier)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        return tableView
    }()
    
    lazy private var historyTableView: UITableView = {
        var tableView = UITableView()
        tableView.tag = 102
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000.0
        tableView.keyboardDismissMode = .onDrag
        tableView.register(FHXLogCell.self, forCellReuseIdentifier: FHXLogCell.identifier)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        return tableView
    }()
    
    /// 筛选枚举当前数据
    private enum FHXLogFilterCurrentState {
        case allCurrentFilter
        case debugCurrentFilter
        case networkCurrentFilter
        case errorCurrentFilter
        case crashCurrentFilter
    }

    /// 当前显示日志
    private var filterCurrentLogs: [FHXLogModel] = []

    /// 当前筛选状态
    private var filterCurrentState: FHXLogFilterCurrentState = .allCurrentFilter

    /// 当前关键词
    private var searchCurrentTerm = String()
    
    /// 筛选枚举历史数据
    private enum FHXLogFilterHistoryState {
        case allHistoryFilter
        case debugHistoryFilter
        case networkHistoryFilter
        case errorHistoryFilter
        case crashHistoryFilter
    }

    /// 历史显示日志
    private var filterHistoryLogs: [FHXLogModel] = []

    /// 历史筛选状态
    private var filterHistoryState: FHXLogFilterHistoryState = .allHistoryFilter

    /// 历史关键词
    private var searchHistoryTerm = String()
    
    init(keyWindowApp: UIWindow, screenWidth: CGFloat, screenHeight: CGFloat, totalTopHeight: CGFloat, safeAreaTop: CGFloat) {
        self.keyWindowApp = keyWindowApp
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.totalTopHeight = totalTopHeight
        self.safeAreaTop = safeAreaTop
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        applyFilterCurrentData()
        applyFilterHistoryData()
        addNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let screenWidth = screenWidth, let screenHeight = screenHeight, let safeAreaTop = safeAreaTop {
            scrollView.frame = CGRectMake(0, safeAreaTop, screenWidth, screenHeight - safeAreaTop)
            navigatonView.frame = CGRectMake(0, 0, screenWidth * 2, 44)
            currentTableView.frame = CGRectMake(0, CGRectGetMaxY(navigatonView.frame), screenWidth, screenHeight - safeAreaTop - 44)
            historyTableView.frame = CGRectMake(screenWidth, CGRectGetMaxY(navigatonView.frame), screenWidth, screenHeight - safeAreaTop - 44)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(navigatonView)
        scrollView.addSubview(currentTableView)
        scrollView.addSubview(historyTableView)
    }
    
    private func applyFilterCurrentData() {
        switch filterCurrentState {
            case .allCurrentFilter:
                filterCurrentLogs = FHXLog.shared.currentLogs()
            case .debugCurrentFilter:
                filterCurrentLogs = FHXLog.shared.currentLogs().filter {
                        $0.level == .debug
                    }
            case .networkCurrentFilter:
                filterCurrentLogs = FHXLog.shared.currentLogs().filter {
                        $0.level == .network
                    }
            case .errorCurrentFilter:
                filterCurrentLogs = FHXLog.shared.currentLogs().filter {
                        $0.level == .error
                    }
            case .crashCurrentFilter:
                filterCurrentLogs = FHXLog.shared.currentLogs().filter {
                        $0.level == .crash
                    }
        }

        currentTableView.reloadData()
    }
    
    private func applyFilterHistoryData() {
        switch filterHistoryState {
        case .allHistoryFilter:
            filterHistoryLogs = FHXLog.shared.historyLogs()
        case .debugHistoryFilter:
            filterHistoryLogs = FHXLog.shared.historyLogs().filter({ model in
                model.level == .debug
            })
        case .networkHistoryFilter:
            filterHistoryLogs = FHXLog.shared.historyLogs().filter({ model in
                model.level == .network
            })
        case .errorHistoryFilter:
            filterHistoryLogs = FHXLog.shared.historyLogs().filter({ model in
                model.level == .error
            })
        case .crashHistoryFilter:
            filterHistoryLogs = FHXLog.shared.historyLogs().filter({ model in
                model.level == .crash
            })
        }
        
        historyTableView.reloadData()
    }
    
    private func addNotification() {

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(logDidAppendCurrentData(_:)),
            name: .logDidAppendCurrentData,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(logDidClearCurrentData),
            name: .logDidClearCurrentData,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(logDidClearHistoryData),
            name: .logDidClearHistoryData,
            object: nil
        )
    }
    
    private func scrollToBottom() {

        guard filterCurrentLogs.count > 0 else {
            return
        }

        let indexPath = IndexPath(
            row: filterCurrentLogs.count - 1,
            section: 0
        )

        currentTableView.scrollToRow(
            at: indexPath,
            at: .bottom,
            animated: true
        )
    }
    
    private func searchCurrent(_ keyword: String) {

        guard !keyword.isEmpty else {
            applyFilterCurrentData()
            return
        }

        let lowerKeyword = keyword.lowercased()

        filterCurrentLogs = FHXLog.shared.currentLogs().filter {

            $0.message.lowercased().contains(lowerKeyword)
            ||
            $0.file.lowercased().contains(lowerKeyword)
            ||
            $0.function.lowercased().contains(lowerKeyword)
        }

        currentTableView.reloadData()
    }
    
    private func searchHistory(_ keyword: String) {

        guard !keyword.isEmpty else {
            applyFilterHistoryData()
            return
        }

        let lowerKeyword = keyword.lowercased()

        filterHistoryLogs = FHXLog.shared.historyLogs().filter {

            $0.message.lowercased().contains(lowerKeyword)
            ||
            $0.file.lowercased().contains(lowerKeyword)
            ||
            $0.function.lowercased().contains(lowerKeyword)
        }

        historyTableView.reloadData()
    }
    
    /// 关键搜索词高亮
    func highlightText(
        text: String,
        keyword: String
    ) -> NSAttributedString {

        let attr = NSMutableAttributedString( string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        attr.addAttributes(
            [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14),
                .paragraphStyle: paragraphStyle
            ],
            range: NSRange(
                location: 0,
                length: text.count
            )
        )

        guard !keyword.isEmpty else {
            return attr
        }

        let nsText = text as NSString

        var searchRange = NSRange(
            location: 0,
            length: nsText.length
        )

        while true {

            let range = nsText.range(
                of: keyword,
                options: .caseInsensitive,
                range: searchRange
            )

            if range.location == NSNotFound {
                break
            }

            attr.addAttributes(
                [
                    .foregroundColor: UIColor.red,
                    .font: UIFont.boldSystemFont(ofSize: 14)
                ],
                range: range
            )

            let nextLocation =
                range.location + range.length

            searchRange = NSRange(
                location: nextLocation,
                length: nsText.length - nextLocation
            )
        }

        return attr
    }

}

/// Notification
extension FHXLogViewController {
    @objc
    private func logDidAppendCurrentData(_ notification: Notification) {

        guard let model = notification.object as? FHXLogModel else {
            return
        }

        filterCurrentLogs.append(model)
        
        applyFilterCurrentData()

        let indexPath = IndexPath(
            row: filterCurrentLogs.count - 1,
            section: 0
        )

        currentTableView.performBatchUpdates({

            currentTableView.insertRows(
                at: [indexPath],
                with: .none
            )

        }, completion: { _ in

            self.scrollToBottom()

        })
    }
    
    @objc
    private func logDidClearCurrentData() {
        filterCurrentLogs.removeAll()
        currentTableView.reloadData()
    }
    
    @objc
    private func logDidClearHistoryData() {
        filterHistoryLogs.removeAll()
        historyTableView.reloadData()
    }
}

extension FHXLogViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 101:
            return filterCurrentLogs.count
        case 102:
            return filterHistoryLogs.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FHXLogCell = FHXLogCell.cell(with: tableView)
        switch tableView.tag {
        case 101:
            cell.levelLabel.text = "\(filterCurrentLogs[indexPath.row].level)"
            
            if filterCurrentLogs[indexPath.row].level.rawValue == 0 {// debug
                cell.levelLabel.backgroundColor = UIColor(red: 0.0/255.0, green: 211.0/255.0, blue: 221.0/255.0, alpha: 1.0)
            } else if filterCurrentLogs[indexPath.row].level.rawValue == 1 {// network
                cell.levelLabel.backgroundColor = UIColor(red: 0.0/255.0, green: 170.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            } else if filterCurrentLogs[indexPath.row].level.rawValue == 2 {// error
                cell.levelLabel.backgroundColor = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            } else if filterCurrentLogs[indexPath.row].level.rawValue == 3 {// crash
                cell.levelLabel.backgroundColor = UIColor(red: 255.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
            }
            
            let messageString = "\(filterCurrentLogs[indexPath.row].file)." + "\(filterCurrentLogs[indexPath.row].function):" + "[\(filterCurrentLogs[indexPath.row].line)] "
            if messageString.range(of: searchCurrentTerm, options: .caseInsensitive) != nil { // 判断 关键词忽略大小写
                cell.messageLabel.attributedText = highlightText(text: messageString, keyword: searchCurrentTerm)
            } else {
                cell.messageLabel.text = "\(filterCurrentLogs[indexPath.row].file)." + "\(filterCurrentLogs[indexPath.row].function):" + "[\(filterCurrentLogs[indexPath.row].line)] "
            }
            
            if searchCurrentTerm != String() && filterCurrentLogs[indexPath.row].message.range(of: searchCurrentTerm, options: .caseInsensitive) != nil {
                cell.contentLabel.attributedText = highlightText(text: filterCurrentLogs[indexPath.row].message, keyword: searchCurrentTerm)
            } else {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 8 // 行间距

                let attributes: [NSAttributedString.Key: Any] = [
                    .paragraphStyle: paragraphStyle,
                    .font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: UIColor.black
                ]

                cell.contentLabel.attributedText = NSAttributedString(
                    string: "\(filterCurrentLogs[indexPath.row].message)",
                    attributes: attributes
                )
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            cell.timeLabel.text = formatter.string(from: filterCurrentLogs[indexPath.row].time)
        
            return cell
        case 102:
            cell.levelLabel.text = "\(filterHistoryLogs[indexPath.row].level)"
    
            if filterHistoryLogs[indexPath.row].level.rawValue == 0 {// debug
                cell.levelLabel.backgroundColor = UIColor(red: 0.0/255.0, green: 211.0/255.0, blue: 221.0/255.0, alpha: 1.0)
            } else if filterHistoryLogs[indexPath.row].level.rawValue == 1 {// network
                cell.levelLabel.backgroundColor = UIColor(red: 0.0/255.0, green: 170.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            } else if filterHistoryLogs[indexPath.row].level.rawValue == 2 {// error
                cell.levelLabel.backgroundColor = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            } else if filterHistoryLogs[indexPath.row].level.rawValue == 3 {// crash
                cell.levelLabel.backgroundColor = UIColor(red: 255.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
            }
    
            let messageString = "\(filterHistoryLogs[indexPath.row].file)." + "\(filterHistoryLogs[indexPath.row].function):" + "[\(filterHistoryLogs[indexPath.row].line)] "
            if messageString.range(of: searchHistoryTerm, options: .caseInsensitive) != nil { // 判断 关键词忽略大小写
                cell.messageLabel.attributedText = highlightText(text: messageString, keyword: searchHistoryTerm)
            } else {
                cell.messageLabel.text = "\(filterHistoryLogs[indexPath.row].file)." + "\(filterHistoryLogs[indexPath.row].function):" + "[\(filterHistoryLogs[indexPath.row].line)] "
            }
    
            if searchHistoryTerm != String() && filterHistoryLogs[indexPath.row].message.range(of: searchHistoryTerm, options: .caseInsensitive) != nil {
                cell.contentLabel.attributedText = highlightText(text: filterHistoryLogs[indexPath.row].message, keyword: searchHistoryTerm)
            } else {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 8 // 行间距
    
                let attributes: [NSAttributedString.Key: Any] = [
                    .paragraphStyle: paragraphStyle,
                    .font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: UIColor.black
                ]
    
                cell.contentLabel.attributedText = NSAttributedString(
                    string: "\(filterHistoryLogs[indexPath.row].message)",
                    attributes: attributes
                )
            }
    
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            cell.timeLabel.text = formatter.string(from: filterHistoryLogs[indexPath.row].time)
    
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {

        let model = filterCurrentLogs[indexPath.row]

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
        if button.tag == 0 { // pop
            navigationController?.popViewController(animated: true)
        } else if button.tag == 1 {// 当前日志

            guard let keyWindowAppPartial = self.keyWindowApp,
                  let screenWidthPartial = self.screenWidth,
                  let screenHeightPartial = self.screenHeight,
                  let totalTopHeightPartial = self.totalTopHeight
            else {
                return
            }
            
            ToolCurrentPopupView.showCurrentView(
                vc: self,
                winApp: keyWindowAppPartial,
                screenWidth: screenWidthPartial,
                screenHeight: screenHeightPartial,
                totalTopHeight: totalTopHeightPartial,
                menuList: ["筛选", "搜索", "导出", "清空日志"],
                subMenuList: ["All","Debug", "Network", "Error", "Crash"]
            ) {[weak self] value in
                guard let self = self else { return }
                if value == "All" {
                    self.filterCurrentState = .allCurrentFilter
                    applyFilterCurrentData()
                } else if value == "Debug" {
                    self.filterCurrentState = .debugCurrentFilter
                    applyFilterCurrentData()
                } else if value == "Network" {
                    self.filterCurrentState = .networkCurrentFilter
                    applyFilterCurrentData()
                } else if value == "Error" {
                    self.filterCurrentState = .errorCurrentFilter
                    applyFilterCurrentData()
                } else if value == "Crash" {
                    self.filterCurrentState = .crashCurrentFilter
                    applyFilterCurrentData()
                } else if value == "搜索" {
                    self.navigatonView.isShowSearchCurrentView = true
                } else if value == "导出" {
                    FHXExportView.showCurrentView(
                        array: ["TXT","JSON","取消"],
                        VCView: self.view,
                    ) { [weak self] index in
                        guard let self = self else { return }
                        if index == 0 {
                            do {
                                let url =
                                try FHXLog.shared.exportCurrentLogsTXTFile()
                                let vc =  UIActivityViewController(activityItems: [url], applicationActivities: nil)
                                self.present(vc, animated: true)
                            } catch {
                                print(error)
                            }
                        } else if index == 1 {
                            do {
                                let url =
                                try FHXLog.shared.exportCurrentLogsJSONFile()
                                let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                                self.present(vc, animated: true)
                            } catch {
                                print(error)
                            }
                        }
                    }
                } else if value == "清空日志" {
                    let alert = UIAlertController(title: "提示", message: "确定清空所有日志吗？", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "取消", style: .cancel))
                    alert.addAction(
                        UIAlertAction(title: "确定", style: .destructive) { _ in
                            FHXLog.shared.clearCurrentLogs()
                        }
                    )
                    self.present(alert, animated: true)
                }
            }

        } else if button.tag == 2 { //当前日志搜索栏取消按键
            searchCurrentTerm = String()
            searchCurrent(searchCurrentTerm)
        } else if button.tag == 8 { // 历史日志
            UIView.animate(withDuration: 0.25) {
                self.scrollView.contentOffset = CGPoint(
                    x: self.screenWidth ?? 0,
                    y: 0
                )
            }
            filterHistoryState = .allHistoryFilter
            applyFilterHistoryData()
        } else if button.tag == 3 { // 筛选
            ToolHistoryPopupView.showCurrentView(
                vc: self,
                totalTopHeight: totalTopHeight ?? 0,
                menuList: ["All", "Debug", "Network", "Error", "Crash"]
            ) { [weak self] value in
                guard let self = self else { return }
                if value == "All" {
                    self.filterHistoryState = .allHistoryFilter
                    applyFilterHistoryData()
                } else if value == "Debug" {
                    self.filterHistoryState = .debugHistoryFilter
                    applyFilterHistoryData()
                } else if value == "Network" {
                    self.filterHistoryState = .networkHistoryFilter
                    applyFilterHistoryData()
                } else if value == "Error" {
                    self.filterHistoryState = .errorHistoryFilter
                    applyFilterHistoryData()
                } else if value == "Crash" {
                    self.filterHistoryState = .crashHistoryFilter
                    applyFilterHistoryData()
                }
            }
        } else if button.tag == 4 { // 搜索
            self.navigatonView.isShowSearchHistoryView = true
        } else if button.tag == 5 { // 导出
            FHXExportView.showCurrentView(
                array: ["TXT","JSON","取消"],
                VCView: self.view,
            ) { [weak self] index in
                guard let self = self else { return }
                if index == 0 {
                    do {
                        let url =
                        try FHXLog.shared.exportHistoryLogsTXTFile()
                        let vc =  UIActivityViewController(activityItems: [url], applicationActivities: nil)
                        self.present(vc, animated: true)
                    } catch {
                        print(error)
                    }
                } else if index == 1 {
                    do {
                        let url =
                        try FHXLog.shared.exportHistoryLogsJSONFile()
                        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                        self.present(vc, animated: true)
                    } catch {
                        print(error)
                    }
                }
            }
        } else if button.tag == 6{ // 清空日志
            let alert = UIAlertController(title: "提示", message: "确定清空所有日志吗？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            alert.addAction(
                UIAlertAction(title: "确定", style: .destructive) { _ in
                    FHXLog.shared.clearHistoryLogs()
                }
            )
            self.present(alert, animated: true)
        } else if button.tag == 7{ // 返回
            UIView.animate(withDuration: 0.25) {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
    }
    
    func fhxNavigationView(view:FHXNavigationView, searchContent text:String, returnLogType logType:LogType) {
        if logType == .current {
            searchCurrentTerm = text
            searchCurrent(text)
        } else if logType == .history {
            searchHistoryTerm = text
            searchHistory(text)
        }
    }
    
}
