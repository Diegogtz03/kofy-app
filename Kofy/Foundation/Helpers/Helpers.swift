//
//  Helpers.swift
//  Helpers
//
//  
//

import Foundation
import SwiftUI
import AVFoundation

public extension UIImage {
    func copyAndResize(uiImage: UIImage,
                       retina: Bool = true) -> UIImage? {
        
        // need to be rotated because of orientation - assumes taken in landscape right
        let height:CGFloat = uiImage.size.width
        let width:CGFloat = uiImage.size.height
        
        let newWidth:CGFloat = Constants.imgDim
        let scale:CGFloat = newWidth / width
        let newHeight:CGFloat = height * scale
        
//        print("old dimensions: \(width) x \(height)")
//        print("new dimensions: \(newWidth) x \(newHeight)")
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(
            /* size: */ newSize,
                        /* opaque: */ false,
                        /* scale: */ retina ? 0 : 1
        )
        defer { UIGraphicsEndImageContext() }
        
        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    // from https://gist.github.com/jkereako/200342b66b5416fd715a
    func scaleAndCropImage(_ image:UIImage, toSize size: CGSize) -> UIImage {
        // Make sure the image isn't already sized.
        guard !image.size.equalTo(size) else {
            return image
        }
        let widthFactor = size.width / image.size.width
        let heightFactor = size.height / image.size.height
        var scaleFactor: CGFloat = 0.0
        scaleFactor = heightFactor
        if widthFactor > heightFactor {
            scaleFactor = widthFactor
        }
        var thumbnailOrigin = CGPoint.zero
        let scaledWidth  = image.size.width * scaleFactor
        let scaledHeight = image.size.height * scaleFactor
        if widthFactor > heightFactor {
            thumbnailOrigin.y = (size.height - scaledHeight) / 2.0
        }
        else if widthFactor < heightFactor {
            thumbnailOrigin.x = (size.width - scaledWidth) / 2.0
        }
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailOrigin
        thumbnailRect.size.width  = scaledWidth
        thumbnailRect.size.height = scaledHeight
        // Why use `UIGraphicsBeginImageContextWithOptions` over `UIGraphicsBeginImageContext`?
        // see: http://stackoverflow.com/questions/4334233/how-to-capture-uiview-to-uiimage-without-loss-of-quality-on-retina-display#4334902
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: thumbnailRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return scaledImage
    }
}

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}

extension UIScreen {

    public var isRetina: Bool {
        guard let scale = screenScale else {
            return false
        }
        return scale >= 2.0
    }

    public var isRetinaHD: Bool {
        guard let scale = screenScale else {
            return false
        }
        return scale >= 3.0
    }

    private var screenScale: CGFloat? {
        guard UIScreen.main.responds(to: #selector(getter: scale)) else {
            return nil
        }
        return UIScreen.main.scale
    }
}

extension UIDeviceOrientation {
    func getUIImageOrientationFromDevice() -> UIImage.Orientation {
        // return CGImagePropertyOrientation based on Device Orientation
        switch self {
        case UIDeviceOrientation.portrait, .faceUp: return UIImage.Orientation.right
        case UIDeviceOrientation.portraitUpsideDown, .faceDown: return UIImage.Orientation.left
        case UIDeviceOrientation.landscapeLeft: return UIImage.Orientation.up // this is the base orientation
        case UIDeviceOrientation.landscapeRight: return UIImage.Orientation.down
        case UIDeviceOrientation.unknown: return UIImage.Orientation.up
        @unknown default:
            fatalError()
        }
    }
}

func videoOrientationFromCurrentDeviceOrientation() -> CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        switch
        windowScene.windows.first?.windowScene?.interfaceOrientation {
        case .portrait:
            return 90
        case .landscapeLeft:
            return 180
        case .landscapeRight:
            return -180
        case .portraitUpsideDown:
            return -90
        default:
            // might not ever happen
            return 90
        }
    }
    
    return 0
}

func exifOrientation() -> CGImagePropertyOrientation {
    let curDeviceOrientation = UIDevice.current.orientation
    let exifOrientation: CGImagePropertyOrientation
    
    switch curDeviceOrientation {
        
    case UIDeviceOrientation.portraitUpsideDown:
        // Device oriented vertically, home button on the top
        exifOrientation = .left
    case UIDeviceOrientation.landscapeLeft:
        // Device oriented horizontally, home button on the right
        exifOrientation = .upMirrored
    case UIDeviceOrientation.landscapeRight:
        // Device oriented horizontally, home button on the left
        exifOrientation = .down
    case UIDeviceOrientation.portrait:
        // Device oriented vertically, home button on the bottom
        exifOrientation = .up
    default:
        exifOrientation = .up
    }
    return exifOrientation
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
