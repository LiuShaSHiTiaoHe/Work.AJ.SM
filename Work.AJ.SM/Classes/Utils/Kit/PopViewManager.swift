//
//  PopViewManager.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/16.
//

import UIKit
import SwiftEntryKit

class PopViewManager: NSObject {
    static let shared = PopViewManager()
    private let entranceAnimation: EKAttributes.Animation = .init(
            translate: .init(
                    duration: 0.5,
                    spring: .init(damping: 1, initialVelocity: 0)
            )
    )
    private let exitAnimation: EKAttributes.Animation = .init(
            translate: .init(duration: 0.35)
    )
    private let shadow: EKAttributes.Shadow = .active(
            with: .init(
                    color: .black,
                    opacity: 0.3,
                    radius: 6
            )
    )
    private let popBehavior: EKAttributes.PopBehavior = .animated(
            animation: .init(
                    translate: .init(duration: 0.35)
            )
    )

    func dissmiss(with completion: @escaping () -> Void) {
        SwiftEntryKit.dismiss(.all, with: completion)
    }

    func display(_ displayView: Any, _ position: EKAttributes.Position, _ size: EKAttributes.PositionConstraints.Size, _ insideKeyWindow: Bool = false) {
        if let userInterfaceStyle = UIViewController.currentViewController()?.traitCollection.userInterfaceStyle {
            var displayMode: EKAttributes.DisplayMode = .light
            switch userInterfaceStyle {
            case .light, .unspecified:
                displayMode = .light
            case .dark:
                displayMode = .dark
            @unknown default:
                displayMode = .light
            }
            var attributes: EKAttributes
            switch position {
            case .top:
                return //TODO
            case .center:
                attributes = .centerFloat
                attributes.displayMode = displayMode
                attributes.windowLevel = .normal
                attributes.displayDuration = .infinity
                attributes.roundCorners = .all(radius: 20)
                attributes.entryBackground = .color(color: EKBackgroundColor)
                attributes.screenBackground = .color(color: EKScreenBackground)
                attributes.screenInteraction = .dismiss
                attributes.entryInteraction = .absorbTouches
                attributes.scroll = .edgeCrossingDisabled(swipeable: true)
                attributes.entranceAnimation = entranceAnimation
                attributes.exitAnimation = exitAnimation
                attributes.popBehavior = popBehavior
                attributes.shadow = shadow
                attributes.positionConstraints.size = size
                attributes.positionConstraints.verticalOffset = 0
                attributes.positionConstraints.safeArea = .overridden

            case .bottom:
                attributes = .bottomFloat
                attributes.displayMode = displayMode
                attributes.windowLevel = .normal
                attributes.displayDuration = .infinity
                attributes.roundCorners = .top(radius: 20)
                attributes.entryBackground = .color(color: EKBackgroundColor)
                attributes.screenBackground = .color(color: EKScreenBackground)
                attributes.screenInteraction = .dismiss
                attributes.entryInteraction = .absorbTouches
                attributes.scroll = .edgeCrossingDisabled(swipeable: true)
                attributes.entranceAnimation = entranceAnimation
                attributes.exitAnimation = exitAnimation
                attributes.popBehavior = popBehavior
                attributes.shadow = shadow
                attributes.positionConstraints.size = size
                attributes.positionConstraints.verticalOffset = 0
                attributes.positionConstraints.safeArea = .overridden
            }

            if let view = displayView as? UIView {
                if #available(iOS 13.0, *) {
                    view.overrideUserInterfaceStyle = userInterfaceStyle
                }
                SwiftEntryKit.display(entry: view, using: attributes, presentInsideKeyWindow: insideKeyWindow)
            } else if let viewController = displayView as? UIViewController {
                if #available(iOS 13.0, *) {
                    viewController.overrideUserInterfaceStyle = userInterfaceStyle
                }
                SwiftEntryKit.display(entry: viewController, using: attributes, presentInsideKeyWindow: insideKeyWindow)
            } else {
                return
            }

        }
    }
}
