//
//  FHXToolCurrentView.swift
//  SwiftDemol
//
//  Created by imac on 2026/6/14.
//


import UIKit

protocol FHXToolCurrentViewDelegate: NSObjectProtocol {
    func fhxToolCurrentView(view:FHXToolCurrentView, buttonClick button:UIButton)
}

class FHXToolCurrentView: UIView {
    
    weak var delegate: FHXToolCurrentViewDelegate?
    
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(logButtonClick), for: .touchUpInside)
        return button
    }()
    
    lazy private var historyLogButton: UIButton = {
        let button = UIButton()
        button.setTitle("历史日志", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(historyLogButtonClick), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        backgroundColor = .white

        addSubview(cancelButton)
        addSubview(logButton)
        addSubview(historyLogButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cancelButton.frame = CGRectMake(5, 0, 44, 44)
        
        let logButtonRight = CGRectGetMaxX(cancelButton.frame) + 10
        logButton.frame = CGRectMake(logButtonRight, 0, 44, 44)
        
        
        let historyLogButtonRight = CGRectGetMaxX(logButton.frame) + 10
        historyLogButton.frame = CGRectMake(historyLogButtonRight, 0, 66, 44)

    }

}

// MARK: - button click
extension FHXToolCurrentView {
    @objc
    private func cancelButtonClick() {
        delegate?.fhxToolCurrentView(view: self, buttonClick: cancelButton)
    }
    
    @objc
    private func logButtonClick() {
        delegate?.fhxToolCurrentView(view: self, buttonClick: logButton)
    }
    
    @objc
    private func historyLogButtonClick() {
        delegate?.fhxToolCurrentView(view: self, buttonClick: historyLogButton)
    }
}
