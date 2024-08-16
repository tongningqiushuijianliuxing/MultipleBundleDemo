//
//  BundleService.swift
//  MultipleBundleDemo
//
//  Created by 产品1 on 2024/8/16.
//

import Moya

enum BundleService {
    case downloadBundle(url: String)
}

extension BundleService: TargetType {
    var baseURL: URL {
        switch self {
        case .downloadBundle(let url):
            return URL(string: url)!
        }
    }
    
    var path: String {
        return "" // 因为完整的 URL 已经在 `baseURL` 中定义
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .downloadDestination(downloadDestination)
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var downloadDestination: DownloadDestination {
        return { _, _ in
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let downloadURL = documentDirectoryURL.appendingPathComponent("BundleDownloaded/sub.zip")
            return (downloadURL, [.removePreviousFile, .createIntermediateDirectories])
        }
    }
}
