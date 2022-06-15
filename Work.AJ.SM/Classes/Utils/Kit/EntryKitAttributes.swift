//
//  EntryKitAttributes.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/16.
//

import Foundation

let EKBackgroundColor = EKColor(light: UIColor(hex: "FFFEFF")!, dark: UIColor(hex: "23272D")!)
let EKScreenBackground = EKColor(light: UIColor(white: 0.5, alpha: 0.5), dark: UIColor(white: 0.5, alpha: 0.5))

enum EntryKitAttributes: Int {
    case bottomFloat
    case centerFloat
    case fullScreenFloat

    var attributes: EKAttributes {
        switch self {
        case .bottomFloat:
            var attributes: EKAttributes
            attributes = .bottomFloat
            attributes.displayMode = .inferred
            attributes.windowLevel = .normal
            attributes.displayDuration = .infinity
            attributes.roundCorners = .top(radius: 20)
            attributes.entryBackground = .color(color: EKBackgroundColor)
            attributes.screenBackground = .color(color: EKScreenBackground)
            attributes.screenInteraction = .dismiss
            attributes.entryInteraction = .absorbTouches
            attributes.scroll = .edgeCrossingDisabled(swipeable: true)
            attributes.entranceAnimation = .init(
                    translate: .init(
                            duration: 0.5,
                            spring: .init(damping: 1, initialVelocity: 0)
                    )
            )
            attributes.exitAnimation = .init(
                    translate: .init(duration: 0.35)
            )
            attributes.popBehavior = .animated(
                    animation: .init(
                            translate: .init(duration: 0.35)
                    )
            )
            attributes.shadow = .active(
                    with: .init(
                            color: .black,
                            opacity: 0.3,
                            radius: 6
                    )
            )
            attributes.positionConstraints.size = .init(
                    width: .fill,
                    height: .ratio(value: 0.3)
            )
            attributes.positionConstraints.verticalOffset = 0
            attributes.positionConstraints.safeArea = .overridden
            attributes.statusBar = .inferred
            return attributes

        case .centerFloat:
            var attributes: EKAttributes
            attributes = .centerFloat
            attributes.displayMode = .inferred
            attributes.windowLevel = .normal
            attributes.displayDuration = .infinity
            attributes.roundCorners = .all(radius: 20)
            attributes.entryBackground = .color(color: EKBackgroundColor)
            attributes.screenBackground = .color(color: EKScreenBackground)
            attributes.screenInteraction = .dismiss
            attributes.entryInteraction = .absorbTouches
            attributes.scroll = .edgeCrossingDisabled(swipeable: true)
            attributes.entranceAnimation = .init(
                    translate: .init(
                            duration: 0.5,
                            spring: .init(damping: 1, initialVelocity: 0)
                    )
            )
            attributes.exitAnimation = .init(
                    translate: .init(duration: 0.35)
            )
            attributes.popBehavior = .animated(
                    animation: .init(
                            translate: .init(duration: 0.35)
                    )
            )
            attributes.shadow = .active(
                    with: .init(
                            color: .black,
                            opacity: 0.3,
                            radius: 6
                    )
            )
            attributes.positionConstraints.size = .init(
                    width: .fill,
                    height: .ratio(value: 0.3)
            )
            attributes.positionConstraints.verticalOffset = 0
            attributes.positionConstraints.safeArea = .overridden
            attributes.statusBar = .inferred
            return attributes
        case .fullScreenFloat:
            var attributes: EKAttributes
            attributes = .centerFloat
            attributes.displayMode = .inferred
            attributes.windowLevel = .normal
            attributes.roundCorners = .none
            attributes.displayDuration = .infinity
            attributes.entryBackground = .color(color: EKBackgroundColor)
            attributes.screenBackground = .color(color: EKScreenBackground)
            attributes.screenInteraction = .forward
            attributes.entryInteraction = .absorbTouches
            attributes.scroll = .disabled
            attributes.entranceAnimation = .init(
                    translate: .init(
                            duration: 0.5,
                            spring: .init(damping: 1, initialVelocity: 0)
                    )
            )
            attributes.exitAnimation = .init(
                    translate: .init(duration: 0.35)
            )
            attributes.popBehavior = .animated(
                    animation: .init(
                            translate: .init(duration: 0.35)
                    )
            )
            attributes.shadow = .active(
                    with: .init(
                            color: .black,
                            opacity: 0.3,
                            radius: 6
                    )
            )
            attributes.positionConstraints.size = .init(
                    width: .fill,
                    height: .fill
            )
            attributes.positionConstraints.verticalOffset = 0
            attributes.positionConstraints.safeArea = .overridden
            attributes.statusBar = .inferred
            return attributes
        }

    }

}
