//
//  FHXNavigationView.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/5.
//

import UIKit

protocol FHXNavigationViewDelegate:NSObjectProtocol {
    func fhxNavigationView(view:FHXNavigationView, buttonClick buttonName:String)
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
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        return button
    }()
    
    lazy private var logButton: UIButton = {
        let button = UIButton()
        button.setTitle("日志", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(logButtonClick), for: .touchUpInside)
        return button
    }()
    
//    lazy private var searchBgView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .red
//        return view
//    }()

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
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.width.height.equalTo(44)
        }
        
        backgroundView.addSubview(logButton)
        logButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.centerY.equalToSuperview()
            make.left.equalTo(cancelButton.snp.right).offset(10)
        }
        
//        backgroundView.addSubview(searchBgView)
//        searchBgView.snp.makeConstraints { make in
//            make.left.equalTo(cancelButton.snp.right).offset(10)
//            make.centerY.equalTo(cancelButton)
//            make.height.equalTo(44)
//            make.right.equalToSuperview()
//        }
        
    }


}

// MARK: - button click
extension FHXNavigationView {
    @objc private func cancelButtonClick() {
//        delegate?.fhxNavigationView(view: self, buttonClick: "cancel")
        
        cancelButton.isSelected.toggle()
        
        if cancelButton.isSelected {
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self = self else { return }
//                self.searchBgView.alpha = 0.0
            }
        } else {
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self = self else { return }
//                self.searchBgView.alpha = 1.0
            }
        }
       
    }
    
    @objc private func logButtonClick() {
        delegate?.fhxNavigationView(view: self, buttonClick: "log")
    }
}
