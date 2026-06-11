//
//  MacroSwift.swift
//  EnvironmentConfiguration
//
//  Created by 冯汉栩 on 16/7/27.
//  Copyright © 2016年 BigL.EnvironmentConfiguration.com. All rights reserved.
//

import UIKit

// MARK: - Window

/// 当前KeyWindow
public var keyWindowApp: UIWindow? {
    return UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }
}

// MARK: - StatusBar

/// 状态栏高度
public var statusBarHeight: CGFloat {
    return UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first?.statusBarManager?.statusBarFrame.height ?? 44
}

// MARK: - SafeArea

/// 安全区域顶部
public var safeAreaTop: CGFloat {
    return keyWindowApp?.safeAreaInsets.top ?? statusBarHeight
}

/// 安全区域底部
public var safeAreaBottom: CGFloat {
    return keyWindowApp?.safeAreaInsets.bottom ?? 0
}

/// 安全区域Insets
public var safeAreaInsetsApp: UIEdgeInsets {
    return keyWindowApp?.safeAreaInsets ?? .zero
}

/// 是否刘海屏
public var hasNotch: Bool {
    return safeAreaBottom > 0
}

// MARK: - Screen
/// 屏幕宽度
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

/// 屏幕高度
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

/// 安全区域内高度
public var safeScreenHeight: CGFloat {
    return screenHeight - safeAreaTop - safeAreaBottom
}

// MARK: - Navigation

/// 导航栏高度
public func navBarHeight(_ vc: UIViewController?) -> CGFloat {
    return vc?.navigationController?.navigationBar.frame.height ?? 44
}

/// 顶部总高度
public func totalTopHeight(_ vc: UIViewController?) -> CGFloat {
    return statusBarHeight + navBarHeight(vc)
}

// MARK: - TabBar

/// TabBar总高度
public func totalBottomHeight(_ vc: UIViewController?) -> CGFloat {
    if let tab = vc?.tabBarController?.tabBar, !tab.isHidden {
        return tab.frame.height
    }
    return 49
}

