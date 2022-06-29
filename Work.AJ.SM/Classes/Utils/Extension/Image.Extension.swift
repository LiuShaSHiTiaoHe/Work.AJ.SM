//
//  Image.Extension.swift
//  Work.AJ.SM
//
//  Created by guguijun on 2022/6/29.
//

import UIKit

extension UIImage {
    public var facesInImage: Int {
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        if let faceCIImage = CIImage.init(image: self), let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy), let imageOptions = NSDictionary(object: NSNumber(value: 5) as NSNumber, forKey: CIDetectorImageOrientation as NSString) as? [String: Any] {
            let features = faceDetector.features(in: faceCIImage, options: imageOptions)
            let faceFeature = features.compactMap { feature in
                return feature as? CIFaceFeature
            }
            return faceFeature.count
        }
        return 0
    }
    
}
