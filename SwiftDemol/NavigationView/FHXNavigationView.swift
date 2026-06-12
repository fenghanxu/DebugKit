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
    
    lazy private var backgroundView:UIView = {
        var view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy private var cancelButton:UIButton = {
        let button = UIButton()
        let bundle = Bundle.main.url(forResource: "file", withExtension: "bundle")
        let sdkBundle = Bundle(url: bundle!)
        let image = UIImage(
            named: "nav_back",
            in: sdkBundle,
            compatibleWith: nil
        )
        button.tag = 0
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        return button
    }()
    
    lazy private var logButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.setTitle("日志", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(logButtonClick), for: .touchUpInside)
        return button
    }()
    
    lazy private var searchBgView: FHXSearchView = {
        let view = FHXSearchView()
        view.alpha = 0.0
        view.delegate = self
        return view
    }()
    
    var isShowSearchBgView:Bool = false {
        didSet {
            if isShowSearchBgView {
                UIView.animate(withDuration: 0.25, animations: { [weak self] in
                    guard let self = self else { return }
                    self.searchBgView.alpha = 1.0
                })
            }
        }
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
        
        addSubview(backgroundView)
        backgroundView.addSubview(cancelButton)
        backgroundView.addSubview(logButton)
        backgroundView.addSubview(searchBgView)
  
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let totalTopHeightPartial = totalTopHeight, let screenWidthPartial = screenWidth else { return }
        
        backgroundView.frame = CGRectMake(0, totalTopHeightPartial - 44, screenWidthPartial, 44)
        
        cancelButton.frame = CGRectMake(5, 0, 44, 44)
        
        let logButtonRight = CGRectGetMaxX(cancelButton.frame) + 10
        logButton.frame = CGRectMake(logButtonRight, 0, 44, 44)
        
        let cancelButtonRight = CGRectGetMaxX(cancelButton.frame) + 10
        let cancelButtonWidth = screenWidthPartial - (CGRectGetMaxX(cancelButton.frame) + 10)
        searchBgView.frame = CGRectMake(cancelButtonRight, 0, cancelButtonWidth, 44)
    }


}

// MARK: - button click
extension FHXNavigationView {
    @objc private func cancelButtonClick() {
        delegate?.fhxNavigationView(view: self, buttonClick: cancelButton)
    }
    
    @objc private func logButtonClick() {
        delegate?.fhxNavigationView(view: self, buttonClick: logButton)
    }
}

extension FHXNavigationView: FHXSearchViewDelegate {
    
    func fhxSearchView(view: FHXSearchView, searchContent text: String) {
        delegate?.fhxNavigationView(view: self, searchContent: text)
    }
    
    func fhxSearchView(view: FHXSearchView, buttonClick button: UIButton) {
        isShowSearchBgView = false
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let self = self else { return }
            self.searchBgView.alpha = 0.0
        })
        
        delegate?.fhxNavigationView(view: self, buttonClick: button)
    }
    
}
