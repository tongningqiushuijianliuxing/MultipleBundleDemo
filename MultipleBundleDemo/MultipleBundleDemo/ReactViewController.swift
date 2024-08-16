import Foundation
import UIKit
import React

class ReactController: UIViewController {
    
    enum ReactBundleType: Int {
        case InApp
        case NetWork
    }
    
    private var rctView: UIView?
    private var rctBridge: RCTBridge? {
        return ScriptLoadUtil.getBridge()
    }
    private var url: String = ""
    private var path: String = ""
    private var type: ReactBundleType = .InApp
    private var name: String = ""
    
    static func createInstance(url: String, path: String, type: ReactBundleType, moduleName: String) -> ReactController {
        let vc = ReactController()
        vc.url = url
        vc.path = path
        vc.type = type
        vc.name = moduleName
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !ScriptLoadUtil.isDebuggable() {
            loadScript()
        }
        if type == .InApp || ScriptLoadUtil.isScriptLoaded(moduleName: name) {
            initView()
        }
    }
    
    private func loadScript() {
        let bridge = ScriptLoadUtil.getBridge()
        if type == .InApp {
            let mainBundlePath = Bundle.main.bundlePath
            NotificationCenter.default.post(name: NSNotification.Name("BundleLoad"),
                                            object: nil,
                                            userInfo: ["path": "file://\(mainBundlePath)/"])
            if let bridge = bridge {
                ScriptLoadUtil.loadScript(with: bridge, path: path, moduleName: name, inMainBundle: true)
            }
        } else if type == .NetWork {
            let downloadedBundlePath = ScriptLoadUtil.getDownloadedScriptDir(moduleName: name)
            if ScriptLoadUtil.isScriptLoaded(moduleName: name) {
                NotificationCenter.default.post(name: NSNotification.Name("BundleLoad"),
                                                object: nil,
                                                userInfo: ["path": "file://\(downloadedBundlePath)/"])
                return
            }
            view.backgroundColor = .white
            let loadingView = UIActivityIndicatorView(style: .medium)
            loadingView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: 200)
            loadingView.color = .blue
            view.addSubview(loadingView)
            loadingView.startAnimating()
            
            let downloadHandler = BundleDownloadHandler()
            downloadHandler.downloadBundle(urlStr: url, moduleName: name) { success, bundlePath in
                print("unzip success \(bundlePath ?? "nil")")
                
                OperationQueue.main.addOperation {
                    loadingView.stopAnimating()
                    loadingView.removeFromSuperview()
                    if let bridge = bridge {
                        ScriptLoadUtil.loadScript(with: bridge, path: self.path, moduleName: self.name, inMainBundle: false)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("BundleLoad"),
                                                    object: nil,
                                                    userInfo: ["path": "file://\(downloadedBundlePath)/"])
                    self.initView()
                }
            }
        }
    }
    
    private func initView() {
        guard let bridge = ScriptLoadUtil.getBridge() else { return }
        let rootView = RCTRootView(bridge: bridge, moduleName: name, initialProperties: nil)
        rootView.frame = view.bounds
        rootView.backgroundColor = .white
        self.view.addSubview(rootView)
        self.view.backgroundColor = .white
    }
}
