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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        let bundle = Bundle.main.url(forResource: "file", withExtension: "bundle")
        let sdkBundle = Bundle(url: bundle!)
        let image = UIImage(named: "cancel", in: sdkBundle, compatibleWith: nil)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: bounds.size.width, height: 70)
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var methodNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "URLSession"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "2026-07-20 22:03:23"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.text = "fenghanxu"
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func buildUI() {
        backgroundColor = .clear

        addSubview(navigationView)
        NSLayoutConstraint.activate([
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: safeAreaTop + 44)
        ])
        
        navigationView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 15),
            cancelButton.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: -5),
            cancelButton.widthAnchor.constraint(equalToConstant: 30),
            cancelButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        container.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 70)
        scrollView.addSubview(container)
        
        container.addSubview(levelLabel)
        NSLayoutConstraint.activate([
            levelLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            levelLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            levelLabel.widthAnchor.constraint(equalToConstant: 60),
            levelLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        container.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: levelLabel.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: levelLabel.trailingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
        ])
        
        container.addSubview(methodNameLabel)
        NSLayoutConstraint.activate([
            methodNameLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 5),
            methodNameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            methodNameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            methodNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        container.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: methodNameLabel.bottomAnchor, constant: 5),
            contentLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            contentLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
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
    
    private func showView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundColor = .black.withAlphaComponent(0.5)
        })
    }
    
    private func dismissView() {
        self.removeFromSuperview()
        backgroundColor = .clear
    }
    
    @objc func cancelButtonClick() {
        self.dismissView()
    }

}



