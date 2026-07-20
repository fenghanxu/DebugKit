//
//  FHXDetailView.swift
//  SwiftDemol
//
//  Created by imac on 2026/7/14.
//

import UIKit

class FHXDetailView: UIView {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(with model: FHXLogModel) {
        self.model = model
        
        let targetRect = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        super.init(frame: targetRect)
        
        buildUI()
        setModel(model)
    }
    
    private lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        let bundle = Bundle.main.url(forResource: "file", withExtension: "bundle")
        let sdkBundle = Bundle(url: bundle!)
        let image = UIImage(named: "cancel", in: sdkBundle, compatibleWith: nil)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: bounds.size.width, height: 70)
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
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
    
    lazy var methodNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "URLSession"
        label.numberOfLines = 1
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "2026-07-20 22:03:23"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.text = "fenghanxu"
        return label
    }()
    
    private var valueBlock:((_ index:NSInteger)->())?
    private var model:FHXLogModel?
    
    static func showCurrentView(model: FHXLogModel, VCView: UIView, valueBlock:((NSInteger)->())?) {
        let selfView = FHXDetailView(with: model)
        selfView.valueBlock = valueBlock
        VCView.addSubview(selfView)
        selfView.showView()
    }
    
    private func buildUI(){
        backgroundColor = .clear

        addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(safeAreaTop + 44)
        }
        
        navigationView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-5)
            make.width.height.equalTo(30)
        }
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        container.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 70)
        scrollView.addSubview(container)
        
        container.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(60)
            make.height.equalTo(22)
        }
        
        container.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(levelLabel)
            make.left.equalTo(levelLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        container.addSubview(methodNameLabel)
        methodNameLabel.snp.makeConstraints { make in
            make.top.equalTo(levelLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(18)
        }
        
        container.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(methodNameLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setModel(_ model: FHXLogModel) {
        levelLabel.text = "\(model.level)"
        timeLabel.text = model.timeString
        levelLabel.backgroundColor = model.level.color
        methodNameLabel.text = model.methodString
        contentLabel.attributedText = model.messageAttributed
        
        let height = 60 + model.contentFullHeight
        scrollView.contentSize = CGSize(width: bounds.size.width, height: height)
        container.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: height)
    }
    
    private func showView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundColor = .black.withAlphaComponent(0.5)
        })
    }
    
    private func dismissView(){
        self.removeFromSuperview()
        backgroundColor = .clear
    }
    
    @objc func cancelButtonClick() {
        self.dismissView()
    }

}




