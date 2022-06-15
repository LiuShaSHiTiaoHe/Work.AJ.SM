//
//  StringProtocol.Extension.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/21.
//

import Foundation

extension StringProtocol {
    var bytes: [UInt8] {
        var startIndex = startIndex
        return (0..<count / 2).compactMap { _ in
            let endIndex = index(after: startIndex)
            defer {
                startIndex = index(after: endIndex)
            }
            return UInt8(self[startIndex...endIndex], radix: 16)
        }
    }
}
