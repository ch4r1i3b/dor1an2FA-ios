//  TokenListViewController.swift
//  dor1an2FA (formerly Authenticator)
//
//  Based on Authenticator, Copyright (c) 2015-2019 Authenticator authors
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

class TokenListViewController: UITableViewController {
    private let dispatchAction: (TokenList.Action) -> Void
    private var viewModel: TokenList.ViewModel
    private var ignoreTableViewUpdates = false

    // CEB QR start
    private var qrScannerViewController: TokenScannerViewController? // To launch the scanner when a row is tapped
    // CEB QR end

    init(viewModel: TokenList.ViewModel, dispatchAction: @escaping (TokenList.Action) -> Void) {
        self.viewModel = viewModel
        self.dispatchAction = dispatchAction
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var searchBar = SearchField(
        frame: CGRect(
            origin: .zero,
            size: CGSize(width: 0, height: 44)
        )
    )

    private lazy var noTokensLabel: UILabel = {
        let title = "No Tokens"
        let message = "Tap + to add a new token to dor1an 2FA"
        let titleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .light)]
        let messageAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .light)]
        let plusAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .light)]

        let noTokenString = NSMutableAttributedString(string: title + "\n", attributes: titleAttributes)
        noTokenString.append(NSAttributedString(string: message, attributes: messageAttributes))
        noTokenString.addAttributes(plusAttributes, range: (noTokenString.string as NSString).range(of: "+"))

        let label = UILabel()
        label.numberOfLines = 2
        label.attributedText = noTokenString
        label.textAlignment = .center
        label.textColor = UIColor.otpForegroundColor
        return label
    }()

    private lazy var noTokensButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(addToken), for: .touchUpInside)

        self.noTokensLabel.frame = button.bounds
        self.noTokensLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.addSubview(self.noTokensLabel)

        button.accessibilityLabel = "No Tokens"
        button.accessibilityHint = "Double-tap to add a new token."

        return button
    }()

    private let backupWarningLabel: UILabel = {
        let linkTitle = "Learn More →"
        let message = "For security reasons, tokens will be stored only on this \(UIDevice.current.model), and will not be included in iCloud or unencrypted backups.  \(linkTitle)"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.paragraphSpacing = 5
        let attributedMessage = NSMutableAttributedString(string: message, attributes: [
            .font: UIFont.systemFont(ofSize: 15, weight: .light),
            .paragraphStyle: paragraphStyle,
        ])
        attributedMessage.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 15),
                                       range: (attributedMessage.string as NSString).range(of: "not"))
        attributedMessage.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 15),
                                       range: (attributedMessage.string as NSString).range(of: linkTitle))

        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = attributedMessage
        label.textAlignment = .center
        label.textColor = UIColor.otpForegroundColor
        return label
    }()

    private lazy var backupWarning: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(showBackupInfo), for: .touchUpInside)

        self.backupWarningLabel.frame = button.bounds
        self.backupWarningLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.addSubview(self.backupWarningLabel)

        button.accessibilityLabel = "For security reasons, tokens will be stored only on this \(UIDevice.current.model), and will not be included in iCloud or unencrypted backups."
        button.accessibilityHint = "Double-tap to learn more."

        return button
    }()

    private let infoButton = UIButton(type: .infoLight)

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.keyboardDismissMode = .interactive
        self.title = "dor1an 2FA"
        self.view.backgroundColor = UIColor.otpBackgroundColor

        // Configure table view
        self.tableView.separatorStyle = .none
        self.tableView.indicatorStyle = .white
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        self.tableView.allowsSelectionDuringEditing = true

        // Configure navigation bar
        self.navigationItem.titleView = searchBar

        self.searchBar.delegate = self

        // Configure toolbar
        let addAction = #selector(TokenListViewController.addToken)
        self.toolbarItems = [
            self.editButtonItem,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: infoButton),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: addAction),
        ]
        self.navigationController?.isToolbarHidden = false

        // Configure empty state
        view.addSubview(noTokensButton)
        view.addSubview(backupWarning)

        infoButton.addTarget(self, action: #selector(TokenListViewController.showLicenseInfo), for: .touchUpInside)

        // Update with current viewModel
        self.updatePeripheralViews()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let searchSelector = #selector(TokenListViewController.filterTokens)
        searchBar.textField.addTarget(self, action: searchSelector, for: .editingChanged)
        searchBar.update(with: viewModel)

        // CEB QR start
        // print("TokenListViewController: View will appear, model: \(viewModel.rowModels)")
        // CEB QR end
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.isEditing = false
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let labelMargin: CGFloat = 20
        let insetBounds = view.bounds.insetBy(dx: labelMargin, dy: labelMargin)
        let noTokensLabelSize = noTokensLabel.sizeThatFits(insetBounds.size)
        let noTokensLabelOrigin = CGPoint(x: (view.bounds.width - noTokensLabelSize.width) / 2,
                                          y: (view.bounds.height * 0.6 - noTokensLabelSize.height) / 2)
        noTokensButton.frame = CGRect(origin: noTokensLabelOrigin, size: noTokensLabelSize)

        let labelSize = backupWarningLabel.sizeThatFits(insetBounds.size)
        let labelOrigin = CGPoint(x: labelMargin, y: view.bounds.maxY - labelMargin - labelSize.height)
        backupWarning.frame = CGRect(origin: labelOrigin, size: labelSize)
    }

    // MARK: Target Actions

    @objc
    func addToken() {
        dispatchAction(.beginAddToken)
    }

    @objc
    func filterTokens() {
        guard let filter = searchBar.text else {
            return dispatchAction(.clearFilter)
        }
        dispatchAction(.filter(filter))
    }

    @objc
    func showBackupInfo() {
        dispatchAction(.showBackupInfo)
    }

    @objc
    func showLicenseInfo() {
        dispatchAction(.showInfo)
    }
}

// MARK: UITableViewDataSource
extension TokenListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TokenRowCell.self)
        updateCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }

// CEB start delete
    private func updateCell(_ cell: TokenRowCell, forRowAtIndexPath indexPath: IndexPath) {
        guard indexPath.row < viewModel.rowModels.count else {
            return
        }
        let rowModel = viewModel.rowModels[indexPath.row]
        cell.update(with: rowModel)
        cell.dispatchAction = dispatchAction
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tokenRow = viewModel.rowModels[indexPath.row]
            // here is where token is actually deleted (though the Delete red square is shown)
            dispatchAction(tokenRow.deleteAction)
        }
    }
// CEB end delete
    
    override func tableView(_ tableView: UITableView, moveRowAt source: IndexPath, to destination: IndexPath) {
        ignoreTableViewUpdates = true
        dispatchAction(.moveToken(fromIndex: source.row, toIndex: destination.row))
        ignoreTableViewUpdates = false
    }
}

// MARK: UITableViewDelegate
extension TokenListViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowModel = viewModel.rowModels[indexPath.row]
        if isEditing {
            dispatchAction(rowModel.editAction)
        } else {
            dispatchAction(rowModel.selectAction)
        }

        // CEB QR start
        // When a row is selected, show QR scanner view
        showQRScanner(forNewIssuer: false)
        // CEB QR end
    }

    // CEB QR start
    // CEB camera type start
    private func showQRScanner(forNewIssuer: Bool) {
        //print("TokenListViewController: Launching QR Scanner")
        
        // CEB camera type start
        let cameraType: QRScanner.CameraType = forNewIssuer ? .rear : .front
        //print("Camera type: ",cameraType)
        // CEB camera type end
        
        qrScannerViewController = TokenScannerViewController(
            viewModel: TokenScanner.ViewModel(isScanning: true),
            dispatchAction: { [weak self] action in
                guard let self = self else { return }
                
                switch action {
                case .scannerDecodedText(let text):
                    print("Decoded QR Code: \(text)")
                    
                    // Stop the scanner after decoding
                    self.qrScannerViewController?.stopScanning()
                    
                    // Dismiss the scanner view
                    DispatchQueue.main.async {
                        if let navigationController = self.navigationController {
                            navigationController.popViewController(animated: true)
                        }
                        
                        // CEB hostname mismatch start
                        // Extract the hostname from the token list

                        if let selectedIndexPath = self.tableView.indexPathForSelectedRow,
                           let selectedCell = self.tableView.cellForRow(at: selectedIndexPath) as? TokenRowCell,
                           let tokenName = selectedCell.rowModel?.hostname {

                           // Split the tokenName to get the hostname part
                            //print("tokenName: \(tokenName)")
                            let tokenHostname = tokenName.split(separator: ";", maxSplits: 1).last?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                           // Print both strings for debugging
                           // print("Decoded Text: \(text)")
                           // print("Token Hostname: \(tokenHostname)")
                           // Compare decoded string with the token hostname
                           if text == tokenHostname {
                                print("Hostnames match!")
                                // Continue to show the QR code if they match
                                selectedCell.showDynamicQRCode()
                            } else {
                                print("Hostnames do not match!")
                                // Show a "hostname mismatch" QR code if they don't match
                                selectedCell.showHostnameMismatchQRCode()
                            }
                        }
                        // CEB hostname mismatch end
                    }
                    
                default:
                    break
                }
            },
            cameraType: cameraType // CEB camera type usage
        )
        if let qrScannerViewController = qrScannerViewController {
            navigationController?.pushViewController(qrScannerViewController, animated: true)
        }
    }
    // CEB QR end
    
}

// MARK: TokenListPresenter
extension TokenListViewController {
    func update(with viewModel: TokenList.ViewModel) {
        let changes = changesFrom(self.viewModel.rowModels, to: viewModel.rowModels)
        let filtering = viewModel.isFiltering || self.viewModel.isFiltering
        self.viewModel = viewModel

        if filtering && !changes.isEmpty {
            tableView.reloadData()
        } else if !ignoreTableViewUpdates {
            let sectionIndex = 0
            let tableViewChanges = changes.map({ change in
                change.map({ row in
                    IndexPath(row: row, section: sectionIndex)
                })
            })
            tableView.applyChanges(tableViewChanges, updateRow: { indexPath in
                if let cell = tableView.cellForRow(at: indexPath) as? TokenRowCell {
                    updateCell(cell, forRowAtIndexPath: indexPath)
                }
            })
        }
        updatePeripheralViews()
    }

    private func updatePeripheralViews() {
        searchBar.update(with: viewModel)

        tableView.isScrollEnabled = viewModel.hasTokens
        editButtonItem.isEnabled = viewModel.hasTokens
        noTokensButton.isHidden = viewModel.hasTokens
        backupWarning.isHidden = viewModel.hasTokens

        // Exit editing mode if no tokens remain
        if self.isEditing && viewModel.rowModels.isEmpty {
            self.setEditing(false, animated: true)
        }
    }
}

extension TokenListViewController: UITextFieldDelegate {
    // Dismisses keyboard when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
