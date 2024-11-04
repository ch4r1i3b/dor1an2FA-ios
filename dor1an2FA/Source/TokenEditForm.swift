//
//  TokenEditForm.swift
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


import OneTimePassword

struct TokenEditForm: Component {
    private let persistentToken: PersistentToken

    private var issuer: String
    private var name: String
    // CEB start
    private var hostname: String
    // CEB end

    private var isValid: Bool {
// CEB start
        return !(issuer.isEmpty && name.isEmpty && hostname.isEmpty)
// CEB stop
    }

    // MARK: Initialization

    init(persistentToken: PersistentToken) {
        self.persistentToken = persistentToken

// CEB start (hostname is in name)

        let parts = persistentToken.token.name.split(separator: ";", maxSplits: 1, omittingEmptySubsequences: true)
        name = persistentToken.token.name
        if let tokenName = parts.first {
            name = String(tokenName)
        }
      hostname = persistentToken.token.name
        if let namehostname = parts.last {
            hostname = String(namehostname)
        }
        issuer = persistentToken.token.issuer

// CEB stop (hostname is in name)
    }
}

// MARK: Associated Types

extension TokenEditForm: TableViewModelRepresentable {
    enum Action {
        case issuer(String)
        case name(String)
        // CEB start
        case hostname(String)
        case parts(String)
        // CEB end
        case cancel
        case submit
    }

    typealias HeaderModel = TokenFormHeaderModel<Action>
    typealias RowModel = TokenFormRowModel<Action>
}

// MARK: View Model

extension TokenEditForm {
    typealias ViewModel = TableViewModel<TokenEditForm>

    var viewModel: ViewModel {
        return TableViewModel(
            title: "Edit Token",
            leftBarButton: BarButtonViewModel(style: .cancel, action: .cancel),
            rightBarButton: BarButtonViewModel(style: .done, action: .submit, enabled: isValid),
            sections: [
                [
                    issuerRowModel,
                    nameRowModel,
                    // CEB start
                    hostnameRowModel,
                    // CEB end
                ],
            ],
            doneKeyAction: .submit
        )
    }

    private var issuerRowModel: RowModel {
        return .textFieldRow(
            identity: "token.issuer",
            viewModel: TextFieldRowViewModel(
                issuer: issuer,
                changeAction: Action.issuer
            )
        )
    }
    // CEB start
    private var hostnameRowModel: RowModel {
        return .textFieldRow(
           identity: "token.hostname",
            viewModel: TextFieldRowViewModel(
                hostname: hostname,
                returnKeyType: .done,
                changeAction: Action.hostname
            )
        )
    }
    // CEB end
    
    private var nameRowModel: RowModel {
        return .textFieldRow(
            identity: "token.name",
            viewModel: TextFieldRowViewModel(
                name: name,
                returnKeyType: .done,
                changeAction: Action.name
            )
        )
    }
}

// MARK: Actions

extension TokenEditForm {
    enum Effect {
        case cancel
        case saveChanges(Token, PersistentToken)
        case showErrorMessage(String)
    }
   mutating func update(with action: Action) -> Effect? {
        switch action {
        case let .issuer(issuer):
            self.issuer = issuer
        case let .name(name):
            self.name = name
        // CEB start
        case let .hostname(hostname):
            self.hostname = hostname
        // CEB end
        case .cancel:
            return .cancel
        case .submit:
            return submit()
        default:
            // Handle other actions or ignore
            break
        }
        return nil
    }

    private mutating func submit() -> Effect? {
        guard isValid else {
            return .showErrorMessage("An issuer, name, and hostname are required.")
        }

        let token = Token(
// CEB start (hostname is in name)
            name: name+";"+hostname,
            issuer: issuer,
// CEB end (hostname is in name)


            generator: persistentToken.token.generator
        )
        //CEB start
        //print(">>>>>> token in TokenEditForm = ",token)
        //CEB end
        return .saveChanges(token, persistentToken)
    }
}

