// 
//  TokenEntryForm.swift
//  Authenticator
//
//  Copyright (c) 2015-2023 Authenticator authors
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

/*
import Foundation
import OneTimePassword
import Base32

private let defaultTimerFactor = Generator.Factor.timer(period: 30)
private let defaultCounterFactor = Generator.Factor.counter(0)

struct TokenEntryForm: Component {
    private var issuer: String = ""
    private var name: String = ""
    private var secret: String = ""
    private var tokenType: TokenType = .timer
    private var digitCount: Int = 6
    private var algorithm: Generator.Algorithm = .sha1

    private var showsAdvancedOptions: Bool = false

    private var isValid: Bool {
        return !secret.isEmpty && !(issuer.isEmpty && name.isEmpty)
    }

    // MARK: Initialization

    init() {
    }
}

// MARK: Associated Types

extension TokenEntryForm: TableViewModelRepresentable {
    enum Action {
        case issuer(String)
        case name(String)
        case secret(String)
        case tokenType(TokenType)
        case digitCount(Int)
        case algorithm(Generator.Algorithm)

        case showAdvancedOptions
        case cancel
        case submit
    }

    typealias HeaderModel = TokenFormHeaderModel<Action>
    typealias RowModel = TokenFormRowModel<Action>
}

// MARK: View Model

extension TokenEntryForm {
    typealias ViewModel = TableViewModel<TokenEntryForm>

    var viewModel: ViewModel {
        return TableViewModel(
            title: "Add Token",
            leftBarButton: BarButtonViewModel(style: .cancel, action: .cancel),
            rightBarButton: BarButtonViewModel(style: .done, action: .submit, enabled: isValid),
            sections: [
                [
                    issuerRowModel,
                    nameRowModel,
                    secretRowModel,
                ],
                Section(
                    header: advancedSectionHeader,
                    rows: !showsAdvancedOptions ? [] :
                        [
                            tokenTypeRowModel,
                            digitCountRowModel,
                            algorithmRowModel,
                        ]
                ),
            ],
            doneKeyAction: .submit
        )
    }

    private var advancedSectionHeader: HeaderModel {
        return .buttonHeader(
            identity: "advanced-options",
            viewModel: ButtonHeaderViewModel(
                title: "Advanced Options",
                action: Action.showAdvancedOptions
            )
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

    private var nameRowModel: RowModel {
        return .textFieldRow(
            identity: "token.name",
            viewModel: TextFieldRowViewModel(
                name: name,
                returnKeyType: .next,
                changeAction: Action.name
            )
        )
    }

    private var secretRowModel: RowModel {
        return .textFieldRow(
            identity: "token.secret",
            viewModel: TextFieldRowViewModel(
                secret: secret,
                // TODO: Change the behavior of the return key based on validation of the form.
                changeAction: Action.secret
            )
        )
    }

    private var tokenTypeRowModel: RowModel {
        return .segmentedControlRow(
            identity: "token.tokenType",
            viewModel: SegmentedControlRowViewModel(
                tokenType: tokenType,
                changeAction: Action.tokenType
            )
        )
    }

    private var digitCountRowModel: RowModel {
        return .segmentedControlRow(
            identity: "token.digitCount",
            viewModel: SegmentedControlRowViewModel(
                digitCount: digitCount,
                changeAction: Action.digitCount
            )
        )
    }

    private var algorithmRowModel: RowModel {
        return .segmentedControlRow(
            identity: "token.algorithm",
            viewModel: SegmentedControlRowViewModel(
                algorithm: algorithm,
                changeAction: Action.algorithm
            )
        )
    }
}

// MARK: Actions

extension TokenEntryForm {
    enum Effect {
        case cancel
        case saveNewToken(Token)
        case showErrorMessage(String)
    }

    mutating func update(with action: Action) -> Effect? {
        switch action {
        case let .issuer(issuer):
            self.issuer = issuer
        case let .name(name):
            self.name = name
        case let .secret(secret):
            self.secret = secret
        case let .tokenType(tokenType):
            self.tokenType = tokenType
        case let .digitCount(digitCount):
            self.digitCount = digitCount
        case let .algorithm(algorithm):
            self.algorithm = algorithm
        case .showAdvancedOptions:
            showsAdvancedOptions = true
        case .cancel:
            return .cancel
        case .submit:
            return submit()
        }
        return nil
    }

    private mutating func submit() -> Effect? {
        guard isValid else {
            return .showErrorMessage("A secret and some identifier are required.")
        }

        guard let secretData = MF_Base32Codec.data(fromBase32String: secret),
            !secretData.isEmpty else {
                return .showErrorMessage("The secret key is invalid.")
        }

        let factor: Generator.Factor
        switch tokenType {
        case .counter:
            factor = defaultCounterFactor
        case .timer:
            factor = defaultTimerFactor
        }

        guard let generator = try? Generator(
            factor: factor,
            secret: secretData,
            algorithm: algorithm,
            digits: digitCount
            ) else {
                // This UI doesn't allow the user to create an invalid period or digit count,
                // so a generic error message is acceptable here.
                return .showErrorMessage("Invalid Token")
        }

        let token = Token(
            name: name,
            issuer: issuer,
            generator: generator
        )
        print("token: ", token)
        return .saveNewToken(token)
    }
}


*/

import Foundation
import OneTimePassword
import Base32

private let defaultTimerFactor = Generator.Factor.timer(period: 30)
private let defaultCounterFactor = Generator.Factor.counter(0)

struct TokenEntryForm: Component {
    private var issuer: String = ""
    private var name: String = ""
    private var secret: String = ""
    // CEB start
    private var domain: String = ""
    // CEB end
    private var tokenType: TokenType = .timer
    private var digitCount: Int = 6
    private var algorithm: Generator.Algorithm = .sha1

    private var showsAdvancedOptions: Bool = false

    private var isValid: Bool {
        return !secret.isEmpty && !(issuer.isEmpty && name.isEmpty)
    }

    // MARK: Initialization

    init() {
    }
}

// MARK: Associated Types

extension TokenEntryForm: TableViewModelRepresentable {
    enum Action {
        case issuer(String)
        case name(String)
        case secret(String)
        // CEB start
        case domain(String)
        // CEB end
        case tokenType(TokenType)
        case digitCount(Int)
        case algorithm(Generator.Algorithm)

        case showAdvancedOptions
        case cancel
        case submit
    }

    typealias HeaderModel = TokenFormHeaderModel<Action>
    typealias RowModel = TokenFormRowModel<Action>
}

// MARK: View Model

extension TokenEntryForm {
    typealias ViewModel = TableViewModel<TokenEntryForm>

    var viewModel: ViewModel {
        return TableViewModel(
            title: "Add Token",
            leftBarButton: BarButtonViewModel(style: .cancel, action: .cancel),
            rightBarButton: BarButtonViewModel(style: .done, action: .submit, enabled: isValid),
            sections: [
                [
                    issuerRowModel,
                    nameRowModel,
                    secretRowModel,
                    // CEB start
                    domainRowModel,
                    // CEB end
                ],
                Section(
                    header: advancedSectionHeader,
                    rows: !showsAdvancedOptions ? [] :
                        [
                            tokenTypeRowModel,
                            digitCountRowModel,
                            algorithmRowModel,
                        ]
                ),
            ],
            doneKeyAction: .submit
        )
    }

    private var advancedSectionHeader: HeaderModel {
        return .buttonHeader(
            identity: "advanced-options",
            viewModel: ButtonHeaderViewModel(
                title: "Advanced Options",
                action: Action.showAdvancedOptions
            )
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

    private var nameRowModel: RowModel {
        return .textFieldRow(
            identity: "token.name",
            viewModel: TextFieldRowViewModel(
                name: name,
                returnKeyType: .next,
                changeAction: Action.name
            )
        )
    }

    private var secretRowModel: RowModel {
        return .textFieldRow(
            identity: "token.secret",
            viewModel: TextFieldRowViewModel(
                secret: secret,
                changeAction: Action.secret
            )
        )
    }

    // CEB start
    private var domainRowModel: RowModel {
        return .textFieldRow(
            identity: "token.domain",
            viewModel: TextFieldRowViewModel(
                domain: domain,
                returnKeyType: .done,  // Provide the returnKeyType here
                changeAction: Action.domain
            )
        )
    }
    // CEB end

    private var tokenTypeRowModel: RowModel {
        return .segmentedControlRow(
            identity: "token.tokenType",
            viewModel: SegmentedControlRowViewModel(
                tokenType: tokenType,
                changeAction: Action.tokenType
            )
        )
    }

    private var digitCountRowModel: RowModel {
        return .segmentedControlRow(
            identity: "token.digitCount",
            viewModel: SegmentedControlRowViewModel(
                digitCount: digitCount,
                changeAction: Action.digitCount
            )
        )
    }

    private var algorithmRowModel: RowModel {
        return .segmentedControlRow(
            identity: "token.algorithm",
            viewModel: SegmentedControlRowViewModel(
                algorithm: algorithm,
                changeAction: Action.algorithm
            )
        )
    }
}

// MARK: Actions

extension TokenEntryForm {
    enum Effect {
        case cancel
        case saveNewToken(Token)
        case showErrorMessage(String)
    }

    mutating func update(with action: Action) -> Effect? {
        switch action {
        case let .issuer(issuer):
            self.issuer = issuer
        case let .name(name):
            self.name = name
        case let .secret(secret):
            self.secret = secret
        // CEB start
        case let .domain(domain):
            self.domain = domain
        // CEB end
        case let .tokenType(tokenType):
            self.tokenType = tokenType
        case let .digitCount(digitCount):
            self.digitCount = digitCount
        case let .algorithm(algorithm):
            self.algorithm = algorithm
        case .showAdvancedOptions:
            showsAdvancedOptions = true
        case .cancel:
            return .cancel
        case .submit:
            return submit()
        }
        return nil
    }

    private mutating func submit() -> Effect? {
        guard isValid else {
            return .showErrorMessage("A secret and some identifier are required.")
        }

        guard let secretData = MF_Base32Codec.data(fromBase32String: secret),
              !secretData.isEmpty else {
                return .showErrorMessage("The secret key is invalid.")
        }

        let factor: Generator.Factor
        switch tokenType {
        case .counter:
            factor = defaultCounterFactor
        case .timer:
            factor = defaultTimerFactor
        }

        guard let generator = try? Generator(
            factor: factor,
            secret: secretData,
            algorithm: algorithm,
            digits: digitCount
            ) else {
                return .showErrorMessage("Invalid Token")
        }

        let token = Token(
            name: name,
            issuer: issuer,
            domain: domain, // Include domain
            generator: generator
        )
        print("token: ", token)
        return .saveNewToken(token)
    }
}

