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
        
        // 2. 开关控制（SPLogs 优点）
        FHXLog.shared.isEnabled = false
        
        //3. 日志等级过滤（新增能力）
        FHXLog.shared.logLevel = .warning
        
        //4. 限制数量（SPLogs升级版）
        FHXLog.shared.maxCount = 500
        
        //5. 获取全部日志 tableview数据获取
        //let logs = FHXDebugKit.shared.allLogs()
        
        // 6. 清空日志
        // FHXDebugKit.shared.clear()
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+0.5) {
            DispatchQueue.main.async {
                // 1. 基础日志
                FHXLog.shared.info("登录成功")
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+0.5) {
            DispatchQueue.main.async {
                FHXLog.shared.error("支付失败")
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+0.5) {
            DispatchQueue.main.async {
                FHXLog.shared.debug("用户点击按钮")
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
