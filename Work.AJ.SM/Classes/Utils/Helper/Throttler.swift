//
//  Throttler.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/5/7.
//

import Foundation
public class Throttler: NSObject {
    // 节流器模式
    // leading 执行第一个事件
    // trailing 执行最后一个事件
    public enum ThrottleMode {
        case leading, trailing
    }

    private let throttler: Throttle
    public init(seconds: Float, mode: ThrottleMode) {
        switch mode {
        case .leading:
            throttler = LeadingThrottler(interval: seconds)
        case .trailing:
            throttler = TrailingThrottler(interval: seconds)
        }
    }

    public func throttle(block: @escaping () -> Void) {
        throttler.throttle {
            block()
        }
    }

    public func invalidate() {
        throttler.invalidate()
    }
}

private protocol Throttle {
    var interval: Float { get }
    func throttle(block: @escaping () -> Void)
    func invalidate()
}

private class LeadingThrottler: Throttle {
    var interval: Float
    init(interval: Float) {
        self.interval = interval
    }

    private var lastRunningDate: Date?
    private var task: (() -> Void)?
    func throttle(block: @escaping () -> Void) {
        task = block
        guard let lastDate = lastRunningDate else {
            resumeTask()
            return
        }

        let timeInterval = Float(Date().timeIntervalSince(lastDate))
        if timeInterval > interval {
            resumeTask()
        }
    }

    func invalidate() {
        task = nil
    }

    private func resumeTask() {
        if let task = task {
            task()
            lastRunningDate = Date()
        }
    }
}

private class TrailingThrottler: Throttle {
    var interval: Float
    init(interval: Float) {
        self.interval = interval
    }

    private let queue = DispatchQueue(label: "com.roni.TrailingThrottler.", attributes: .concurrent)
    private var lastRunningDate: Date?
    private var nextRunningDate: Date?
    private var workItem: DispatchWorkItem?

    func throttle(block: @escaping () -> Void) {
        workItem = DispatchWorkItem(block: block)
        let currentDate = Date()
        guard getNextRunningDate() == nil else {
            return
        }

        if let lastDate = getLastRunningDate() {
            let timeInterval = Float(currentDate.timeIntervalSince(lastDate))
            var date: Date
            if timeInterval > interval {
                date = currentDate.addingTimeInterval(TimeInterval(interval))
            } else {
                date = lastDate.addingTimeInterval(TimeInterval(interval))
            }
            setNextRunningDate(date)
        } else {
            setNextRunningDate(currentDate.addingTimeInterval(TimeInterval(interval)))
        }

        guard let nextDate = getNextRunningDate() else { return }
        let nextInterval = nextDate.timeIntervalSince(currentDate)

        DispatchQueue.main.asyncAfter(deadline: .now() + nextInterval) {
            self.workItem?.perform()
            self.setNextRunningDate(nil)
            self.setLastRunningDate(Date())
        }
    }

    func invalidate() {
        workItem?.cancel()
        workItem = nil
    }

    private func getNextRunningDate() -> Date? {
        var date: Date?
        queue.sync {
            date = nextRunningDate
        }
        return date
    }

    private func setNextRunningDate(_ date: Date?) {
        queue.async(flags: .barrier) {
            self.nextRunningDate = date
        }
    }

    private func getLastRunningDate() -> Date? {
        var date: Date?
        queue.sync {
            date = lastRunningDate
        }
        return date
    }

    private func setLastRunningDate(_ date: Date) {
        queue.async(flags: .barrier) {
            self.lastRunningDate = date
        }
    }
}
