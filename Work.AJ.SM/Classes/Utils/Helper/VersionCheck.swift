//
//  VersionCheck.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/5/26.
//

import Alamofire
import Foundation
import UIKit

typealias VersionCheckCompletion = (Bool, AppStoreVersionModel.Results?, String) -> Void

class VersionCheck {
    static let shared = VersionCheck()

    func launchAppStore() {
        let url = URL(string: kAppStoreUrl)!
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    func checkNewVersion(newVersionBlock: @escaping VersionCheckCompletion) {
        let infoDic = Bundle.main.infoDictionary
        let currentInstalledVersion = infoDic?["CFBundleShortVersionString"] as! String
        let request = URLRequest(url: URL(string: kAppInfoLookUpUrl)!)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if error != nil {
                DispatchQueue.main.sync { newVersionBlock(false, nil, "检查版本失败") }
            } else {
                guard let data = data else {
                    DispatchQueue.main.sync { newVersionBlock(false, nil, "检查版本失败") }
                    return
                }
                do {
                    let model = try JSONDecoder().decode(AppStoreVersionModel.self, from: data)
                    guard DataParser.isUpdateCompatibleWithDeviceOS(for: model) else {
                        DispatchQueue.main.sync { newVersionBlock(false, nil, "当前系统版本过低，无法运行最新版的APP") }
                        return
                    }
                    guard !model.results.isEmpty, let results = model.results.first else {
                        DispatchQueue.main.sync { newVersionBlock(false, nil, "检查版本失败") }
                        return
                    }
                    guard let currentAppStoreVersion = model.results.first?.version else {
                        DispatchQueue.main.sync { newVersionBlock(false, nil, "检查版本失败") }
                        return
                    }

                    let isAppStoreVsersionNewer = DataParser.isAppStoreVersionNewer(installedVersion: currentInstalledVersion,
                                                                                    appStoreVersion: currentAppStoreVersion)
                    if isAppStoreVsersionNewer {
                        DispatchQueue.main.sync { newVersionBlock(true, results, "") }
                    } else {
                        DispatchQueue.main.sync { newVersionBlock(false, results, "当前已是最新版本") }
                    }
                } catch {
                    DispatchQueue.main.sync { newVersionBlock(false, nil, "检查版本失败") }
                }
            }
        }
        task.resume()
    }
}

struct AppStoreVersionModel: Decodable {
    /// Codable Coding Keys for the Top-Level iTunes Lookup API JSON response.
    private enum CodingKeys: String, CodingKey {
        /// The results JSON key.
        case results
    }

    /// The array of results objects from the iTunes Lookup API.
    let results: [Results]

    /// The Results object from the the iTunes Lookup API.
    struct Results: Decodable {
        ///  Codable Coding Keys for the Results array in the iTunes Lookup API JSON response.
        private enum CodingKeys: String, CodingKey {
            /// The appID JSON key.
            case appID = "trackId"
            /// The current version release date JSON key.
            case currentVersionReleaseDate
            /// The minimum device iOS version compatibility JSON key.
            case minimumOSVersion = "minimumOsVersion"
            /// The release notes JSON key.
            case releaseNotes
            /// The current App Store version JSON key.
            case version
        }

        /// The app's App ID.
        let appID: Int

        /// The release date for the latest version of the app.
        let currentVersionReleaseDate: String

        /// The minimum version of iOS that the current version of the app requires.
        let minimumOSVersion: String

        /// The releases notes from the latest version of the app.
        let releaseNotes: String?

        /// The latest version of the app.
        let version: String
    }
}

enum DataParser {
    /// Checks to see if the App Store version of the app is newer than the installed version.
    ///
    /// - Parameters:
    ///   - installedVersion: The installed version of the app.
    ///   - appStoreVersion: The App Store version of the app.
    /// - Returns: `true` if the App Store version is newer. Otherwise, `false`.
    static func isAppStoreVersionNewer(installedVersion: String?, appStoreVersion: String?) -> Bool {
        guard let installedVersion = installedVersion,
              let appStoreVersion = appStoreVersion,
              installedVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending
        else {
            return false
        }

        return true
    }

    /// Validates that the latest version in the App Store is compatible with the device's current version of iOS.
    ///
    /// - Parameter model: The iTunes Lookup Model.
    /// - Returns: `true` if the latest version is compatible with the device's current version of iOS. Otherwise, `false`.
    static func isUpdateCompatibleWithDeviceOS(for model: AppStoreVersionModel) -> Bool {
        guard let requiredOSVersion = model.results.first?.minimumOSVersion else {
            return false
        }

        let systemVersion = UIDevice.current.systemVersion

        guard systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedDescending ||
            systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedSame
        else {
            return false
        }

        return true
    }

    /// Splits a version-formatted `String into an `[Int]`.
    ///
    /// Converts `"a.b.c.d"` into `[a, b, c, d]`.
    ///
    /// - Parameter version: The version formatted `String`.
    ///
    /// - Returns: An array of integers representing a version of the app.
    private static func split(version: String) -> [Int] {
        return version.lazy.split { $0 == "." }.map { String($0) }.map { Int($0) ?? 0 }
    }
}
