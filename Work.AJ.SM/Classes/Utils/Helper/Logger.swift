//
//  Logger.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/7.
//

import Foundation
import XCGLogger

let logger: XCGLogger = {
    let log = XCGLogger(identifier: "com.sc.main", includeDefaultDestinations: true)
    log.levelDescriptions[.verbose] = "🗯"
    log.levelDescriptions[.debug] = "🔹"
    log.levelDescriptions[.info] = "😎"
    log.levelDescriptions[.notice] = "✳️"
    log.levelDescriptions[.warning] = "⚠️"
    log.levelDescriptions[.error] = "‼️"
    log.levelDescriptions[.severe] = "💣"
    log.levelDescriptions[.alert] = "🛑"
    log.levelDescriptions[.emergency] = "🚨"
    // 【注意】这里使用了三方默认的 destination，无需再次添加 log 形式的 destination
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ssss"
    dateFormatter.locale = Locale.current
    log.dateFormatter = dateFormatter
    // 开始启用
    log.logAppDetails()
    let logPath: URL = URL.init(string: FileManager.jk.CachesDirectory() + "Log.txt")!
    log.setup(level: .info, showLogIdentifier: false, showFunctionName: true, showThreadName: false, showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: logPath, fileLevel: .error)
    return log
}()

public extension XCGLogger {

    /// 自定义打印=================
    func shortLine(_ file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let lineString = "======================================"
        print("\((file as NSString).pathComponents.last!):\(line) \(function): \(lineString)")
        #endif
    }

    /// 自定义打印+++++++++++++++++++
    func plusLine(_ file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let lineString = "+++++++++++++++++++++++++++++++++++++"
        print("\((file as NSString).pathComponents.last!):\(line) \(function): \(lineString)")
        #endif
    }
}
