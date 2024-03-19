// The Swift Programming Language
// https://docs.swift.org/swift-book

import Cocoa
import Foundation
import SwiftUI

public func generateQRCode(from string: String) -> NSImage? {
  let data = string.data(using: String.Encoding.ascii)
  if let filter = CIFilter(name: "CIQRCodeGenerator") {
    filter.setValue(data, forKey: "inputMessage")
    let transform = CGAffineTransform(scaleX: 3, y: 3)
    if let output = filter.outputImage?.transformed(by: transform) {
      return NSImage(cgImage: CIContext().createCGImage(output, from: output.extent)!, size: NSSize(width: output.extent.width, height: output.extent.height))
    }
  }
  return nil
}

public struct QRCode: View {
  var url: String?
  var qrimage: NSImage?

  public init(_ url: String?) {
    self.url = url
  }

  public init(_ url_: URL) {
    self.url = url_.absoluteString
  }

  func checkURL() -> Bool {
    guard let url = url else {
      return false
    }
    if url == "" {
      return false
    }
    if url.contains("bilibili") {
      return true
    }
    return false
  }

  public var body: some View {
    if checkURL() {
      // 如果url通过检查，显示QRCode
      Image(nsImage: generateQRCode(from: url!)!)
        .interpolation(.none)
        .resizable()
        .frame(width: 200, height: 200)
      } else {
      // 否则显示一个X的NSImage
        Image(systemName: "xmark")
        .resizable()
        .offset(x: 3, y: 3)
        .frame(width: 200, height: 200)
    }
  }
}

#Preview("failed") {
    QRCode("")
}
#Preview("succeed") {
    QRCode("https://passport.bilibili.com/h5-app/passport/login/scan?navhide=1&qrcode_key=a66857c6272f0236a796bcc9b9c0c2f0&from=")
}
