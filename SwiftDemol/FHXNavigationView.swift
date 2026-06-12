//
//  FHXNavigationView.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/5.
//

import UIKit

protocol FHXNavigationViewDelegate:NSObjectProtocol {
    func fhxNavigationView(view:FHXNavigationView, buttonClick button:UIButton)
}

class FHXNavigationView: UIView {
    
    weak var delegate:FHXNavigationViewDelegate?
    
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
    
    lazy private var searchBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.alpha = 0.0
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
        backgroundView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(44)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        backgroundView.addSubview(cancelButton)
        backgroundView.addSubview(logButton)
        backgroundView.addSubview(searchBgView)
        
        searchBgView.snp.makeConstraints { make in
            make.left.equalTo(cancelButton.snp.right).offset(10)
            make.centerY.equalTo(cancelButton)
            make.height.equalTo(44)
            make.right.equalToSuperview()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cancelButton.frame = CGRectMake(5, 0, 44, 44)
        let logButtonRight = CGRectGetMaxX(cancelButton.frame) + 10
        logButton.frame = CGRectMake(logButtonRight, 0, 44, 44)
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
