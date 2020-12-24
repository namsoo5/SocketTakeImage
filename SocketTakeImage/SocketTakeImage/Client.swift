//
//  Client.swift
//  SocketTakeImage
//
//  Created by 남수김 on 2020/12/23.
//

import UIKit
import AVFoundation
import SocketIO

protocol ImageCaptureDelegate {
    func didCapture(imageData: Data)
}

class Client: UIViewController {
    private let socket = SocketClient.shared
    private lazy var captureDevice = AVCaptureDevice.default(for: .video)
    private var session: AVCaptureSession?
    private var output = AVCapturePhotoOutput()
    
    override func viewDidLoad() {
        settingCamera()
        socket.connect(output: output, delegate: self)
    }
    
    func settingCamera() {
        guard let captureDevice = captureDevice else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session = AVCaptureSession()
            session?.sessionPreset = .photo
            session?.addInput(input)
            session?.addOutput(output)
        } catch {
            print(error)
        }
        guard let session = session else { return }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        session.startRunning()
        
    }
}

extension Client: ImageCaptureDelegate {
    func didCapture(imageData: Data) {
        socket.sendImage(imageData)
    }
}

extension Client: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let data = photo.fileDataRepresentation()
        socket.sendImage(data!)
    }
}

class SocketClient {
    static let shared = SocketClient()
    var manager = SocketManager(socketURL: URL(string: "http://localhost:10000")!,
                                config: [.log(true), .compress, .reconnects(true)])
    var socket: SocketIOClient!
    weak var captureOutput: AVCapturePhotoOutput?
    var delegate: AVCapturePhotoCaptureDelegate?
        
    private init() {
        socket = manager.defaultSocket
    }
    
    func connect(output: AVCapturePhotoOutput, delegate: AVCapturePhotoCaptureDelegate) {
        self.delegate = delegate
        captureOutput = output
        socket.connect()
        eventListen()
    }
    
    func eventListen() {
        guard let delegate = self.delegate else { return }
        socket.on("take") { [weak self] data, emitter in
            self?.captureOutput?.capturePhoto(with: .init(),
                                             delegate: delegate)
        }
    }
    
    func sendImage(_ image: Data) {
        socket.emit("imageData", image)
    }
}

/*
class Client: UIViewController {
    private var client: GCDAsyncSocket?
    private var server: GCDAsyncSocket?

    override func viewDidLoad() {
        super.viewDidLoad()
        client = GCDAsyncSocket(delegate: self, delegateQueue: .main)
        client?.readData(withTimeout: -1, tag: 0)
        client?.autoDisconnectOnClosedReadStream = false
        do{
            print("Connecting to socket server...")
            try client?.connect(toHost: "127.0.0.1", onPort: UInt16(8080), withTimeout: -1)
        } catch let error{
            print(error)
        }

    }

    @IBAction func write(_ sender: Any) {
        let data = "hello".data(using: .utf8)
        server?.write(data, withTimeout: -1, tag: 0)

    }
}
 */
/*
extension Client: GCDAsyncSocketDelegate {

    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        let data = "hello".data(using: .utf8)

        sock.readData(withTimeout: -1, tag: 0)
        print(#function)
        print(host)
        print(port)
    }

    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        print("Receive data")
        print("Data : ", data)
        print("tag : ", tag)
    }

    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        if let error = err {
            print("Will disconnect with error: \(error)")
        }
        else{
            print("Success disconnect")
        }
    }
}
*/
