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
    
    lazy private var toolCurrentView:FHXToolCurrentView = {
        var view = FHXToolCurrentView()
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
            if isShowSearchBgView {
                UIView.animate(withDuration: 0.25, animations: { [weak self] in
                    guard let self = self else { return }
                    self.searchCurrentView.alpha = 1.0
                })
            }
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

        toolCurrentView.addSubview(searchCurrentView)
  
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let totalTopHeightPartial = totalTopHeight else { return }
        
        toolCurrentView.frame = CGRectMake(0, totalTopHeightPartial - 44, bounds.size.width, 44)
        
        searchCurrentView.frame = CGRectMake(5 + 44 + 10, 0, bounds.size.width - 5 - 44 - 10, 44)

    }

}

// MARK: - button click
extension FHXNavigationView: FHXToolCurrentViewDelegate {
    
    func fhxToolCurrentView(view:FHXToolCurrentView, buttonClick button:UIButton) {
        delegate?.fhxNavigationView(view: self, buttonClick: button)
    }

}

extension FHXNavigationView: FHXSearchCurrentViewDelegate {
    
    func fhxSearchCurrentView(view: FHXSearchCurrentView, searchContent text: String) {
        delegate?.fhxNavigationView(view: self, searchContent: text)
    }
    
    func fhxSearchCurrentView(view: FHXSearchCurrentView, buttonClick button: UIButton) {
        isShowSearchBgView = false
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let self = self else { return }
            self.searchCurrentView.alpha = 0.0
        })
        
        delegate?.fhxNavigationView(view: self, buttonClick: button)
    }
    
}
