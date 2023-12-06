//
//  QRCodeView.swift
//  Authenticator
//
//  Created by ch4r1i3b on 20/08/2023.
//

import Foundation
import SwiftUI

struct QRCodeView: SwiftUI.View {
    let qrImage: UIImage?

    var body: some SwiftUI.View {
        VStack {
            if let uiImage = qrImage.map(Image.init(uiImage:)) {
                uiImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200) // Adjust the size as needed
            } else {
                Text("No QR Code Available")
            }
        }
    }
}
