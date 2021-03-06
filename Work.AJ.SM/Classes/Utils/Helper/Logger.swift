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
    log.levelDescriptions[.verbose] = "ð¯"
    log.levelDescriptions[.debug] = "ð¹"
    log.levelDescriptions[.info] = "ð"
    log.levelDescriptions[.notice] = "â³ï¸"
    log.levelDescriptions[.warning] = "â ï¸"
    log.levelDescriptions[.error] = "â¼ï¸"
    log.levelDescriptions[.severe] = "ð£"
    log.levelDescriptions[.alert] = "ð"
    log.levelDescriptions[.emergency] = "ð¨"
    // ãæ³¨æãè¿éä½¿ç¨äºä¸æ¹é»è®¤ç destinationï¼æ éåæ¬¡æ·»å  log å½¢å¼ç destination
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ssss"
    dateFormatter.locale = Locale.current
    log.dateFormatter = dateFormatter
    // å¼å§å¯ç¨
    log.logAppDetails()
    let logPath: URL = URL.init(string: FileManager.jk.CachesDirectory() + "Log.txt")!
    log.setup(level: .info, showLogIdentifier: false, showFunctionName: true, showThreadName: false, showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: logPath, fileLevel: .error)
    return log
}()

public extension XCGLogger {

    /// èªå®ä¹æå°=================
    func shortLine(_ file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let lineString = "======================================"
        print("\((file as NSString).pathComponents.last!):\(line) \(function): \(lineString)")
        #endif
    }

    /// èªå®ä¹æå°+++++++++++++++++++
    func plusLine(_ file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let lineString = "+++++++++++++++++++++++++++++++++++++"
        print("\((file as NSString).pathComponents.last!):\(line) \(function): \(lineString)")
        #endif
    }
}
