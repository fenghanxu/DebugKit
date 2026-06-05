//
//  FHXNavigationView.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/5.
//

import UIKit

class FHXNavigationView: UIView {
    
    lazy private var backgroundView:UIView = {
        var view = UIView()
        view.backgroundColor = .white
        return view
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
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(44)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }

}




