import UIKit
import SwiftUI

class TokenRowCell: UITableViewCell {
    var dispatchAction: ((TokenRowModel.Action) -> Void)?
    private var rowModel: TokenRowModel?

    private let titleLabel = UILabel()
    private let passwordLabel = UILabel()
    private let nextPasswordButton = UIButton(type: .contactAdd)
    
    //CEB Start 
    //private var qrWebView: WKWebView?
    //CEB End 
    
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
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        titleLabel.textColor = .otpForegroundColor
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        
        passwordLabel.font = UIFont.systemFont(ofSize: 60, weight: .thin)
        passwordLabel.textColor = .otpForegroundColor
        passwordLabel.textAlignment = .left
        contentView.addSubview(passwordLabel)

        nextPasswordButton.tintColor = .otpForegroundColor
        // CEB Start - Modify the target action to start the camera instead of showing a QR code
        nextPasswordButton.addTarget(self, action: #selector(startCamera), for: .touchUpInside)
        nextPasswordButton.accessibilityLabel = "Start Camera"
        nextPasswordButton.accessibilityHint = "Double-tap to activate the camera."
        // CEB End
        contentView.addSubview(nextPasswordButton)
    }

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
        self.rowModel = rowModel
        titleLabel.text = rowModel.name
        passwordLabel.text = rowModel.password
        nextPasswordButton.isHidden = !rowModel.showsButton
    }

    // CEB Start - Method to activate the camera
    @objc func startCamera() {
        // Placeholder for camera activation logic
        if let viewController = findViewController() as? YourViewControllerHandlingCamera { // Adapt this cast to your specific view controller that handles camera
            viewController.startCameraFromFront()
        }
    }
    // CEB End

    // Helper function to find the view controller
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
}

