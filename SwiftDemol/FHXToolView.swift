//
//  FHXToolView.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/10.
//

import UIKit
import SnapKit

class FHXToolView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(winApp: UIWindow,
         screenWidth: CGFloat,
         screenHeight: CGFloat,
         totalTopHeight: CGFloat) {
        
        let targetRect = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        
        super.init(frame: targetRect)
        
        self.winApp = winApp
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.totalTopHeight = totalTopHeight
        buildUI()
    }
    
    private var valueBlock:((_ index:NSInteger)->())?
    
    private var winApp: UIWindow?
    
    private var screenWidth: CGFloat?
    
    private var screenHeight: CGFloat?
    
    private var totalTopHeight: CGFloat?
    
    // MARK: - Background Button
    
    lazy private var button: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Bottom Content
    
    lazy private var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 22
        view.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        return view
    }()
    
    
    // MARK: - Show
    
    static func showCurrentView(
        vc: UIViewController,
        winApp: UIWindow,
        screenWidth: CGFloat,
        screenHeight: CGFloat,
        totalTopHeight: CGFloat,
        valueBlock:((NSInteger)->())?
    ) {
        let selfView = FHXToolView(
            winApp: winApp,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            totalTopHeight: totalTopHeight
        )
        selfView.valueBlock = valueBlock
        vc.view.addSubview(selfView)
        selfView.showView()
    }
    
    // MARK: - UI
    
    func buildUI() {
        
        backgroundColor = .clear
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        button.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(600)
        }

        
    }
    
    // MARK: - Show
    
    func showView() {
        
        bgView.transform = CGAffineTransform(
            translationX: 0,
            y: UIScreen.main.bounds.height
        )
        
        UIView.animate(withDuration: 0.3) {
            
            self.backgroundColor = .black.withAlphaComponent(0.45)
            
            self.bgView.transform = .identity
        }
    }
    
    // MARK: - Dismiss
    
    func dismissView() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.backgroundColor = .clear
            
            self.bgView.transform = CGAffineTransform(
                translationX: 0,
                y: UIScreen.main.bounds.height
            )
            
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Action
    
    @objc func buttonClick() {
        dismissView()
    }
    
    @objc func closeButtonClick() {
        dismissView()
    }
    
}

