import Foundation
import React

class ScriptLoadUtil {

    private static var multiDebug: Bool = false // 如果需要调试，请将其设置为 true
    private static var loadedScripts: [String] = []
    private static var rctBridge: RCTBridge?

    static func initialize(bridge: RCTBridge) {
        rctBridge = bridge
    }

    static func getBridge() -> RCTBridge? {
        return rctBridge
    }

    static func isDebuggable() -> Bool {
        return multiDebug
    }

    static func isScriptLoaded(moduleName: String) -> Bool {
        return loadedScripts.contains(moduleName)
    }

    static func getDownloadedScriptPath(path: String, moduleName: String) -> String {
        let subScriptDir = "/Bundles/\(moduleName)/"
        let bundlePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
        let scriptPath = bundlePath + subScriptDir + path
        return scriptPath
    }

    static func getDownloadedScriptDir(moduleName: String) -> String {
        let subScriptDir = "Bundles/\(moduleName)"
        let bundlePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "") as NSString
        return bundlePath.appendingPathComponent(subScriptDir)
    }

    static func loadScript(with bridge: RCTBridge, path: String, moduleName: String, inMainBundle: Bool) {
        if !loadedScripts.contains(moduleName) {
            loadedScripts.append(moduleName)
            var jsCodeLocationBuz: String?

            if inMainBundle {
                jsCodeLocationBuz = Bundle.main.path(forResource: path, ofType: "")
            } else {
                let scriptPath = getDownloadedScriptPath(path: path, moduleName: moduleName)
                jsCodeLocationBuz = scriptPath
            }

            if let jsCodeLocationBuz = jsCodeLocationBuz, let sourceBuz = try? Data(contentsOf: URL(fileURLWithPath: jsCodeLocationBuz))  {
                bridge.batched?.executeSourceCode(sourceBuz, withSourceURL: URL(fileURLWithPath: jsCodeLocationBuz), sync: false)
            } else {
                print("Error loading script for module: \(moduleName)")
            }
        }
    }
}
