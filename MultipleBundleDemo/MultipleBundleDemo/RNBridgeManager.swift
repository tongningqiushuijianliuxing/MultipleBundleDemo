//
//  RNBridgeManager.swift
//  MultipleBundleDemo
//
//  Created by 产品1 on 2024/8/13.
//

import Foundation
import React

class RNBridgeManager: NSObject {
    static let shared = RNBridgeManager()
    var bridge: RCTBridge?
    func configInit(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if let bridgeInfo = RCTBridge(bundleURL: getJsCodeLocation(), moduleProvider: nil, launchOptions: launchOptions) {
            bridge = bridgeInfo
            ScriptLoadUtil.initialize(bridge: bridgeInfo)
        }
    }
       
    func getJsCodeLocation() -> URL? {
        if ScriptLoadUtil.isDebuggable() {
            return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "main")
        } else {
            return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        }
    }
            
}
