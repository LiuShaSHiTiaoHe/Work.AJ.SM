//
//  Sequence.Extension.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/21.
//

import Foundation
extension Sequence where Element == UInt8 {
    var hexData: Data { .init(self) }
    var hexString: String { map { .init(format: "%02x", $0).uppercased() }.joined() }
}
