//
//  TokenRowModel.swift
//  dor1an2FA (formerly Authenticator)
//
//  Based on Authenticator, Copyright (c) 2015-2019 Authenticator authors
//  Modified and renamed to dor1an2FA by ch4r1i3b in 2024
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

import Foundation
import OneTimePassword

struct TokenRowModel: Equatable, Identifiable {
    typealias Action = TokenList.Action
    let name, issuer, hostname, password: String
    let showsButton: Bool
    let canReorder: Bool
    let buttonAction: Action
    let selectAction: Action
    let editAction: Action
    let deleteAction: Action

    private let identifier: Data

    init(persistentToken: PersistentToken, displayTime: DisplayTime, digitGroupSize: Int, canReorder reorderable: Bool = true) {
        let rawPassword = (try? persistentToken.token.generator.password(at: displayTime.date)) ?? ""

        // CEB scan cancel start
        let fullName = persistentToken.token.name
        let nameParts = fullName.split(separator: ";", maxSplits: 1).map { String($0) }
        if nameParts.count == 2 {
            name = nameParts[0] // Before the semicolon
            hostname = nameParts[1] // After the semicolon
        } else {
            name = fullName // If no semicolon, use the whole name
            hostname = "" // No hostname
        }
        // CEB scan cancel end
        
        issuer = persistentToken.token.issuer
        password = TokenRowModel.chunkPassword(rawPassword, chunkSize: digitGroupSize)

        //CEB start
        /*
        print("---------")
        print("name:  ", name)
        print("issuer:", issuer)
        print("pass:  ", password)
        print("hostname:", hostname)
        print("---------")
        */
        // CEB end

        if case .counter = persistentToken.token.generator.factor {
            showsButton = true
        } else {
            showsButton = false
        }
        
        buttonAction = .updatePersistentToken(persistentToken)
        selectAction = .copyPassword(rawPassword)
        editAction = .editPersistentToken(persistentToken)
        deleteAction = .deletePersistentToken(persistentToken)
        identifier = persistentToken.identifier
        canReorder = reorderable
    }
    func hasSameIdentity(as other: TokenRowModel) -> Bool {
        return (self.identifier == other.identifier)
    }

    // Group the password into chunks of two digits, separated by spaces.
    private static func chunkPassword(_ password: String, chunkSize: Int) -> String {
        var mutablePassword = password
        for i in stride(from: chunkSize, to: mutablePassword.count, by: chunkSize).reversed() {
            mutablePassword.insert(" ", at: mutablePassword.index(mutablePassword.startIndex, offsetBy: i))
        }
        return mutablePassword
    }
}
