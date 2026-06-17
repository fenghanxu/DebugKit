//
//  FHXNavigationView.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/5.
//

import UIKit

protocol FHXNavigationViewDelegate:NSObjectProtocol {
    func fhxNavigationView(view:FHXNavigationView, buttonClick button:UIButton)
    func fhxNavigationView(view:FHXNavigationView, searchContent text:String)
}

class FHXNavigationView: UIView {
    
    weak var delegate:FHXNavigationViewDelegate?
    
    var keyWindowApp: UIWindow?
    
    var screenWidth: CGFloat?
    
    var screenHeight: CGFloat?
    
    var totalTopHeight: CGFloat?
    
    lazy private var toolCurrentView: FHXToolCurrentView = {
        let view = FHXToolCurrentView()
        view.delegate = self
        return view
    }()
    
    lazy private var toolHistoryView: FHXToolHistoryView = {
        let view = FHXToolHistoryView()
        view.delegate = self
        return view
    }()
    
    lazy private var searchCurrentView: FHXSearchCurrentView = {
        let view = FHXSearchCurrentView()
        view.alpha = 0.0
        view.delegate = self
        return view
    }()
    
    var isShowSearchBgView:Bool = false {
        didSet {
            self.searchCurrentView.isShowSearchBgView = isShowSearchBgView
//            if isShowSearchBgView {
//                UIView.animate(withDuration: 0.25, animations: { [weak self] in
//                    guard let self = self else { return }
//                    self.searchCurrentView.alpha = 1.0
//                })
//            }
        }
    }
    
    init(frame: CGRect, keyWindowApp: UIWindow?, screenWidth: CGFloat?, screenHeight: CGFloat?, totalTopHeight: CGFloat?) {
        
        self.keyWindowApp = keyWindowApp
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.totalTopHeight = totalTopHeight
        
        super.init(frame: frame)
        
        buildUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        
        backgroundColor = .white
        
        addSubview(toolCurrentView)
        
        addSubview(toolHistoryView)

        toolCurrentView.addSubview(searchCurrentView)
  
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let totalTopHeight = totalTopHeight else { return }
        
        toolCurrentView.frame = CGRectMake(0, totalTopHeight - 44, bounds.size.width, 44)
        
        toolHistoryView.frame = CGRectMake(5 + 44 + 10, totalTopHeight - 44, bounds.size.width - 5 - 44 - 10, 44)
        
        searchCurrentView.frame = CGRectMake(5 + 44 + 10, 0, bounds.size.width - 5 - 44 - 10, 44)

    }

}

// MARK: - button click
extension FHXNavigationView: FHXToolCurrentViewDelegate {
    
    func fhxToolCurrentView(view:FHXToolCurrentView, buttonClick button:UIButton) {
        if button.currentTitle == "历史日志" {
            toolHistoryView.isShowToolHistoryView = true
        } else {
            delegate?.fhxNavigationView(view: self, buttonClick: button)
        }
        
    }

}

extension FHXNavigationView: FHXSearchCurrentViewDelegate {
    
    func fhxSearchCurrentView(view: FHXSearchCurrentView, searchContent text: String) {
        delegate?.fhxNavigationView(view: self, searchContent: text)
    }
    
    func fhxSearchCurrentView(view: FHXSearchCurrentView, buttonClick button: UIButton) {
//        isShowSearchBgView = false
//        
//        UIView.animate(withDuration: 0.25, animations: { [weak self] in
//            guard let self = self else { return }
//            self.searchCurrentView.alpha = 0.0
//        })
        
        delegate?.fhxNavigationView(view: self, buttonClick: button)
    }
    
}

extension FHXNavigationView: FHXToolHistoryViewDelegate {
    
    func fhxToolHistoryView(view: FHXToolHistoryView, buttonClick button: UIButton) {
        toolHistoryView.isShowToolHistoryView = false
        if button.tag != 7 { // 如果不是  历史日志框 取消按键
            delegate?.fhxNavigationView(view: self, buttonClick: button)
        }
    }
    
}
