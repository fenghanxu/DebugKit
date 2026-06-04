//
//  ViewController.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2022/6/7.
//  Alamofire

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //配置
        System.shared.isEnabled = true
        System.shared.maxCount = 1000
        
        System.shared.log("登录成功", level: .info)
        
        let errors = System.shared
            .filter(.error)//过滤
            .export()//导出
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+0.5) {
            DispatchQueue.main.async {
                FHXLog.info("登录成功")
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+0.5) {
            DispatchQueue.main.async {
                FHXLog.error("支付失败")
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+0.5) {
            DispatchQueue.main.async {
                FHXLog.debug("用户点击按钮")
            }
        }

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 3
        self.view.addGestureRecognizer(doubleTap)
    }
 
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        navigationController?.pushViewController(FHXLogViewController(), animated: true)
    }
    
    
    

    
}
