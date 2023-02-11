//
//  TextFieldRow.swift
//  Authenticator
//
//  Copyright (c) 2014-2019 Authenticator authors
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

struct TextFieldRowViewModel<Action> {
    let label: String
    let placeholder: String

    let autocapitalizationType: UITextAutocapitalizationType
    let autocorrectionType: UITextAutocorrectionType
    let keyboardType: UIKeyboardType
    let returnKeyType: UIReturnKeyType

    let value: String
    let changeAction: (String) -> Action
}

protocol TextFieldRowCellDelegate: AnyObject {
    func textFieldCellDidReturn<Action>(_ textFieldCell: TextFieldRowCell<Action>)
}

private let preferredHeight: CGFloat = 74

class TextFieldRowCell<Action>: UITableViewCell, UITextFieldDelegate {
    let textField = UITextField()
    weak var delegate: TextFieldRowCellDelegate?
    var dispatchAction: ((Action) -> Void)?
    private var changeAction: ((String) -> Action)?

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }

    // MARK: - Subviews

    private func configureSubviews() {
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .light)

        textField.delegate = self
        textField.addTarget(self, action: #selector(TextFieldRowCell.textFieldValueChanged), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16, weight: .light)
        contentView.addSubview(textField)

        accessibilityElements = [textField]
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let margin: CGFloat = 20
        let width = contentView.bounds.width - (2 * margin)
        textLabel?.frame = CGRect(x: margin, y: 15, width: width, height: 21)
        textField.frame = CGRect(x: margin, y: 44, width: width, height: 30)
    }

    // MARK: - View Model

    func update(with viewModel: TextFieldRowViewModel<Action>) {
        textLabel?.text = viewModel.label
        textField.placeholder = viewModel.placeholder

        textField.autocapitalizationType = viewModel.autocapitalizationType
        textField.autocorrectionType = viewModel.autocorrectionType
        textField.keyboardType = viewModel.keyboardType
        textField.returnKeyType = viewModel.returnKeyType

        // UITextField can behave erratically if its text is updated while it is being edited,
        // especially with Chinese text entry. Only update if truly necessary.
        if textField.text != viewModel.value {
            textField.text = viewModel.value
        }
        changeAction = viewModel.changeAction

        textField.accessibilityLabel = viewModel.label
    }

    static func heightForRow(with viewModel: TextFieldRowViewModel<Action>) -> CGFloat {
        return preferredHeight
    }

    // MARK: - Target Action

    @objc
    func textFieldValueChanged() {
        let newText = textField.text ?? ""
        if let action = changeAction?(newText) {
            dispatchAction?(action)
        }
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === self.textField {
            delegate?.textFieldCellDidReturn(self)
        }
        return false
    }
}

extension TextFieldRowCell: FocusCell {
    @discardableResult
    func focus() -> Bool {
        return textField.becomeFirstResponder()
    }

    @discardableResult
    func unfocus() -> Bool {
        return textField.resignFirstResponder()
    }
}
