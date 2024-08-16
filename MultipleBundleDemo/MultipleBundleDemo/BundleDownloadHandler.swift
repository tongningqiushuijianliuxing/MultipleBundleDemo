import Foundation
import Moya
import SSZipArchive

class BundleDownloadHandler {
    
    private let provider = MoyaProvider<BundleService>()
    
    func downloadBundle(urlStr: String, moduleName: String, downloadCompleteHandler: @escaping (Bool, String?) -> Void) {
        if ScriptLoadUtil.isScriptLoaded(moduleName: moduleName) {
            downloadCompleteHandler(true, nil)
            return
        }
        let bundleService = BundleService.downloadBundle(url: urlStr)
        provider.request(bundleService) { result in
            switch result {
            case .success(let response):
                let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let destinationURL = documentDirectoryURL.appendingPathComponent("BundleDownloaded/sub.zip")
                
                print("下载完成: \(destinationURL)")
                
                let subScriptDir = "Bundles/\(moduleName)"
                let bundlePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/\(subScriptDir)") ?? ""
                
                print("解压地址: \(bundlePath)")
                
                do {
                    // 解压文件到 bundle 目录
                    if SSZipArchive.unzipFile(atPath: destinationURL.path, toDestination: bundlePath) {
                        print("解压成功")
                        // 删除下载的 zip 文件
                        try FileManager.default.removeItem(at: destinationURL)
                        downloadCompleteHandler(true, bundlePath)
                    } else {
                        print("解压失败")
                        downloadCompleteHandler(false, nil)
                    }
                } catch {
                    print("操作失败: \(error.localizedDescription)")
                    downloadCompleteHandler(false, nil)
                }
                
            case .failure(let error):
                print("下载失败: \(error.localizedDescription)")
                downloadCompleteHandler(false, nil)
            }
        }
    }
}
