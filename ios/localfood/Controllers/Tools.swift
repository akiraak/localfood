import Foundation
import UIKit
//import Alamofire

class Tools {
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    static func documentDirectoryURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    static func makeDir(dirName: String) {
        let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path: URL = documentsURL.appendingPathComponent(dirName)
        do {
            try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
        } catch let e {
            print("Error:", e)
        }
    }

    static func savePng(image: UIImage, path: String, filename: String) {
        Tools.makeDir(dirName: path)

        let data: NSData = image.pngData()! as NSData
        let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL: URL = documentsURL.appendingPathComponent(path).appendingPathComponent(filename)
        do {
            try data.write(to: fileURL)
        } catch let e {
            print("Error:", e)
        }
        print("Finish")
    }

    static func saveJpeg(image: UIImage, path: String, filename: String) {
        Tools.makeDir(dirName: path)

        let data: NSData = image.jpegData(compressionQuality: 0.8)! as NSData
        let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL: URL = documentsURL.appendingPathComponent(path).appendingPathComponent(filename)
        do {
            try data.write(to: fileURL)
        } catch let e {
            print("Error:", e)
        }
        print("Finish")
    }

    static func removeFile(path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch let e {
            print("Error:", e)
        }
    }

    static func pngList(path: String) -> Array<URL> {
        var contentUrls: Array<URL> = []
        let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath: URL = documentsURL.appendingPathComponent(path)
        do {
            contentUrls = try FileManager.default.contentsOfDirectory(at: filePath, includingPropertiesForKeys: nil)
        } catch {
            print(error)
        }
        var pngFiles: Array<URL> = []
        for url in contentUrls {
            if url.pathExtension == "png" {
                pngFiles.append(url)
            }
        }
        return pngFiles
    }

    static func nowDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter.string(from: Date())
    }

    static func posFromInstaxSize(pos: CGPoint, w: CGFloat) -> CGPoint {
        let h = w * 4 / 3
        return CGPoint(
            x: w * pos.x / 600,
            y: h * pos.y / 800)
    }

    struct SynthesizeImage {
        var image: UIImage
        var rect: CGRect
    }
    static func synthesizeImage(images: [SynthesizeImage]) -> UIImage {
        let firstImage = images[0]
        let imageSize = CGSize(width: firstImage.image.size.width, height: firstImage.image.size.height)
        let screenSize = CGSize(width: firstImage.rect.size.width, height: firstImage.rect.size.height)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, firstImage.image.scale)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 1)
        for image in images {
            let rect = CGRect(
                x: image.rect.origin.x * imageSize.width / screenSize.width,
                y: image.rect.origin.y * imageSize.height / screenSize.height,
                width: image.rect.size.width * imageSize.width / screenSize.width,
                height: image.rect.size.height * imageSize.height / screenSize.height)
            image.image.draw(in: rect, blendMode:CGBlendMode.normal, alpha:1.0)
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    /*
    static func psotImage(url: String, image: UIImage) {
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image.jpegData(compressionQuality: 0.8)!, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        },
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        // 成功
                        let responseData = response
                        print(responseData)
                    }
                case .failure(let encodingError):
                    // 失敗
                    print(encodingError)
                }
        })
    }
 */
}

class Screen {
    static func widthRateBy13() -> CGFloat {
        return UIScreen.main.bounds.size.width / 390.0
    }
    static func heightRateBy13() -> CGFloat {
        return UIScreen.main.bounds.size.height / 844.0
    }
}

extension UIView {
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    func flipHorizontal() -> UIImage {
        return UIImage(cgImage: cgImage!, scale: 1.0, orientation: .leftMirrored)
    }

    func cropping(to: CGRect) -> UIImage? {
        var opaque = false
        if let cgImage = cgImage {
            switch cgImage.alphaInfo {
            case .noneSkipLast, .noneSkipFirst:
                opaque = true
            default:
                break
            }
        }
        UIGraphicsBeginImageContextWithOptions(to.size, opaque, scale)
        draw(at: CGPoint(x: -to.origin.x, y: -to.origin.y))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    func square() -> UIImage? {
        if size.height > size.width {
            let rect = CGRect(x: 0, y: (size.height - size.width) / 2, width: size.width, height: size.width)
            return cropping(to: rect)
        } else {
            let rect = CGRect(x: (size.width - size.height) / 2, y: 0, width: size.height, height: size.height)
            return cropping(to: rect)
        }
    }

    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContext(resizedSize)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }

    func setDismissKeyboard() {
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
