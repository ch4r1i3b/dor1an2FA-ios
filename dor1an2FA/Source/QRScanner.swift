//  QRScanner.swift
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

import AVFoundation

protocol QRScannerDelegate: AnyObject {
    func handleDecodedText(_ text: String)
}

class QRScanner: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    weak var delegate: QRScannerDelegate?
    private let serialQueue = DispatchQueue(label: "QRScanner serial queue")
    private var captureSession: AVCaptureSession?

    // CEB start camera type
    enum CameraType {
        case front
        case rear
    }
    private var cameraType: CameraType = .rear // Default to rear camera
    // CEB end camera type

    // CEB start capture session error definition
    enum CaptureSessionError: Error {
        case noCaptureDevice
        case noQRCodeMetadataType
    }
    // CEB end capture session error definition
    
    func start(success: @escaping (AVCaptureSession) -> Void, failure: @escaping (Error) -> Void) {
        serialQueue.async {
            do {
                // CEB start pass camera type
                let captureSession = try self.captureSession ?? QRScanner.createCaptureSession(withDelegate: self, cameraType: self.cameraType)
                // CEB end pass camera type
                captureSession.startRunning()

                self.captureSession = captureSession
                DispatchQueue.main.async {
                    success(captureSession)
                }
            } catch {
                self.captureSession = nil
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }

    func stop() {
        serialQueue.async {
            self.captureSession?.stopRunning()
        }
    }

    // CEB start camera setup
    private class func createCaptureSession(withDelegate delegate: AVCaptureMetadataOutputObjectsDelegate, cameraType: CameraType) throws -> AVCaptureSession {
        let captureSession = AVCaptureSession()

        // Choose the appropriate camera
        let cameraPosition: AVCaptureDevice.Position = (cameraType == .rear) ? .back : .front
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition) else {
            throw CaptureSessionError.noCaptureDevice
        }

        let captureInput = try AVCaptureDeviceInput(device: captureDevice)
        captureSession.addInput(captureInput)

        let captureOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureOutput)
        guard captureOutput.availableMetadataObjectTypes.contains(.qr) else {
            throw CaptureSessionError.noQRCodeMetadataType
        }
        captureOutput.metadataObjectTypes = [.qr]
        captureOutput.setMetadataObjectsDelegate(delegate, queue: .main)

        return captureSession
    }
    // CEB end camera setup

    class var deviceCanScan: Bool {
        return (AVCaptureDevice.default(for: .video) != nil)
    }

    class var authorizationStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }

    class func requestAccess(_ completionHandler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { accessGranted in
            DispatchQueue.main.async {
                completionHandler(accessGranted)
            }
        }
    }

    // CEB start set camera
    func setCamera(type: CameraType) {
        self.cameraType = type
        //print("QRScanner Camera type: ", type)
    }
    // CEB end set camera
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects {
            if let metadata = metadata as? AVMetadataMachineReadableCodeObject,
                metadata.type == .qr,
                let string = metadata.stringValue {
                DispatchQueue.main.async {
                    self.delegate?.handleDecodedText(string)
                }
            }
        }
    }
}
