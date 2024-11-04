//
//  TokenRowCell.swift
//  dor1an2FA (formerly Authenticator)
//
//  Based on Authenticator, Copyright (c) 2013-2023 Authenticator authors
//  Modified and renamed to dor1an2FA by [Your Name or Entity] in 2024
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import SwiftUI
//import MobileCoreServices
import WebKit


class TokenRowCell: UITableViewCell {
    var dispatchAction: ((TokenRowModel.Action) -> Void)?
// CEB hostname mismatch start
    //private var rowModel: TokenRowModel?
    internal var rowModel: TokenRowModel?
// CEB hostname mismatch end

    private let titleLabel = UILabel()
    private let passwordLabel = UILabel()
    private let nextPasswordButton = UIButton(type: .contactAdd)
    
    //CEB start
    private var qrWebView: WKWebView?
    //CEB end
    
    // MARK: - Setup

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureCell()
    }

    private func configureCell() {
        backgroundColor = .otpBackgroundColor
        selectionStyle = .none

        configureSubviews()
        updateAppearance(with: rowModel)
    }

    // MARK: - Subviews

    private func configureSubviews() {
/*
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        titleLabel.textColor = .otpForegroundColor
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)

        passwordLabel.font = UIFont.systemFont(ofSize: 50, weight: .thin)
        passwordLabel.textColor = .otpForegroundColor
        passwordLabel.textAlignment = .center
*/
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        titleLabel.textColor = .otpForegroundColor
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        
        passwordLabel.font = UIFont.systemFont(ofSize: 60, weight: .thin)
        passwordLabel.textColor = .otpForegroundColor
        passwordLabel.textAlignment = .left
        
        // CEB
        //CEBLabel.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        //CEBLabel.textColor = .otpForegroundColor
        //CEBLabel.textAlignment = .left
        // CEB
        // aparentemente, aca escribe la pass en el celu
        contentView.addSubview(passwordLabel)
        //contentView.addSubview(CEBLabel)

        nextPasswordButton.tintColor = .otpForegroundColor
        nextPasswordButton.addTarget(self, action: #selector(TokenRowCell.generateNextPassword), for: .touchUpInside)
        nextPasswordButton.accessibilityLabel = "Increment token"
        nextPasswordButton.accessibilityHint = "Double-tap to generate a new password."
        contentView.addSubview(nextPasswordButton)
    }
    // CEB hostname mismatch start

    func showHostnameMismatchQRCode() {
        // Create a QR code with the text "hostname mismatch"
        let mismatchText = "hostname mismatch"


        let qrCodeFilter = CIFilter(name: "CIQRCodeGenerator")
        qrCodeFilter?.setValue(mismatchText.data(using: .utf8), forKey: "inputMessage")
        
        if let qrCodeImage = qrCodeFilter?.outputImage {
            let largerQRCodeImage = qrCodeImage.transformed(by: CGAffineTransform(scaleX: 12, y: 12))

            let qrCodeImageView = UIImageView(image: UIImage(ciImage: largerQRCodeImage))
            qrCodeImageView.contentMode = .center
            qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false

            let alertController = UIAlertController(title: mismatchText, message: nil, preferredStyle: .alert)
            alertController.view.addSubview(qrCodeImageView)

            // Center the QR code in the alert
            alertController.view.addConstraint(NSLayoutConstraint(item: qrCodeImageView, attribute: .centerX, relatedBy: .equal, toItem: alertController.view, attribute: .centerX, multiplier: 1, constant: 0))
            alertController.view.addConstraint(NSLayoutConstraint(item: qrCodeImageView, attribute: .centerY, relatedBy: .equal, toItem: alertController.view, attribute: .centerY, multiplier: 1, constant: 0))

            let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertController.addAction(closeAction)
            
            if let viewController = findViewController() {
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    // CEB hostname mismatch end

    override func layoutSubviews() {
        super.layoutSubviews()

        // Keep the contents centered in the full cell even when the contentView shifts in edit mode
        let fullFrame = convert(bounds, to: contentView)

        titleLabel.frame = fullFrame
        titleLabel.frame.size.height = 20

        passwordLabel.frame = fullFrame
        passwordLabel.frame.origin.y += 20
        passwordLabel.frame.size.height -= 30

        nextPasswordButton.center = CGPoint(x: fullFrame.maxX - 25, y: passwordLabel.frame.midY)
    }

    // MARK: - Update

    func update(with rowModel: TokenRowModel) {
        updateAppearance(with: rowModel)
        self.rowModel = rowModel
    }
    // This function shows the dinamic image when the user clicks on the 6-digit token
    func showDynamicQRCode() {
        // 6-digit token QR generator
        if let password = rowModel?.password {
            let qrCodeFilter = CIFilter(name: "CIQRCodeGenerator")
            qrCodeFilter?.setValue(password.data(using: .utf8), forKey: "inputMessage")
            
            if let qrCodeImage = qrCodeFilter?.outputImage {
                // larger QR code
                let largerQRCodeImage = qrCodeImage.transformed(by: CGAffineTransform(scaleX: 12, y: 12)) // Adjust the scale factor as needed

                let qrCodeImageView = UIImageView(image: UIImage(ciImage: largerQRCodeImage))
                // end of larger QR code
//                let qrCodeImageView = UIImageView(image: UIImage(ciImage: qrCodeImage))
                // Ensure the image is displayed at its original size
                qrCodeImageView.contentMode = .center
                qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
                qrCodeImageView.widthAnchor.constraint(equalToConstant: qrCodeImage.extent.size.width).isActive = true
                qrCodeImageView.heightAnchor.constraint(equalToConstant: qrCodeImage.extent.size.height).isActive = true
                // End original size...
                
                // Crea una vista emergente para mostrar el código QR
                //let alertController = UIAlertController(title: "Código QR Dinámico", message: nil, preferredStyle: .alert)
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                alertController.view.addSubview(qrCodeImageView)
// CEB center image start
 //               let viewController = findViewController()
                alertController.view.addConstraint(NSLayoutConstraint(item: qrCodeImageView, attribute: .centerX, relatedBy: .equal, toItem: alertController.view, attribute: .centerX, multiplier: 1, constant: 0))
                alertController.view.addConstraint(NSLayoutConstraint(item: qrCodeImageView, attribute: .centerY, relatedBy: .equal, toItem: alertController.view, attribute: .centerY, multiplier: 1, constant: 0))
// CEB center image stop

                
                let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)

                // Configure CLose button at center
                if let button = closeAction.value(forKey: "__representer") as? UIView {
                    let verticalOffset: CGFloat = 5  // Ajusta este valor según tus preferencias
                    button.transform = button.transform.translatedBy(x: 10, y: verticalOffset)
                }

                // Assign "Close" as preferred action
                alertController.addAction(closeAction)
                alertController.preferredAction = closeAction
                
                // Adds touch recognize gesture to the QR image
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeQRCode))
                qrCodeImageView.isUserInteractionEnabled = true
                qrCodeImageView.addGestureRecognizer(tapGesture)
                
                // Shows the popup image
                if let viewController = findViewController() {
                    viewController.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func closeQRCode() {
        if let viewController = findViewController() {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    // CEB
    
    private func updateAppearance(with rowModel: TokenRowModel?) {
        let name = rowModel?.name ?? ""
        let issuer = rowModel?.issuer ?? ""
        let password = rowModel?.password ?? ""
        let showsButton = rowModel?.showsButton ?? false
        setName(name, issuer: issuer)
        setPassword(password)
        nextPasswordButton.isHidden = !showsButton
    }
// CEB start
// CEB function to display issuer and name above the token (hostname is in name)

    private func setName(_ name: String, issuer: String) {
        let titleString = NSMutableAttributedString()

        // Split the name variable by ';' and use the first part (corresponding to the name) only
        let tokenName = name.split(separator: ";", maxSplits: 1, omittingEmptySubsequences: true)
        let firstPartOfName = tokenName.first.map(String.init) ?? ""

        if !firstPartOfName.isEmpty {
            let nameAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)]
            titleString.append(NSAttributedString(string: firstPartOfName, attributes: nameAttributes))
        }
        if !firstPartOfName.isEmpty && !issuer.isEmpty {
            titleString.append(NSAttributedString(string: " "))
        }
        if !issuer.isEmpty {
            titleString.append(NSAttributedString(string: issuer))
        }
        titleLabel.attributedText = titleString
    }

// CEB end  (hostname is in name)

    
    // CEB
    // Here, the 6-digit token is set to be shown
    private func setPassword(_ password: String) {
        passwordLabel.attributedText = NSAttributedString(string: password, attributes: [.kern: 2])
    }
    
    // MARK: - Editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.showsReorderControl = editing && (rowModel?.canReorder ?? true)
        UIView.animate(withDuration: 0.3) {
            self.passwordLabel.alpha = !editing ? 1 : 0.2
            self.nextPasswordButton.alpha = !editing ? 1 : 0
        }
    }
    
    // MARK: - Actions

    @objc
    func generateNextPassword() {
        if let password = rowModel?.password {
            
            if let webView = qrWebView {
                if let htmlString = generateHTMLStringForQRCode(password) {
                    webView.loadHTMLString(htmlString, baseURL: nil)
                    webView.frame = contentView.bounds
                    contentView.addSubview(webView)
                }
            }
        }
    }
    
    private func generateHTMLStringForQRCode(_ password: String) -> String? {
        guard let base64QRCode = generateBase64QRCode(password) else {
            return nil
        }
        
        let htmlString = """
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
                    background-color: transparent;
                }
                #qrCode {
                    max-width: 100%;
                    max-height: 80%;
                }
            </style>
        </head>
        <body>
            <img id="qrCode" src="data:image/png;base64,\(base64QRCode)" alt="QR Code">
        </body>
        </html>
        """
        return htmlString
    }

    private func generateBase64QRCode(_ password: String) -> String? {
        let exampleBase64QRCode = "base64-encoded-image-data"
        return exampleBase64QRCode
    }
    
}


