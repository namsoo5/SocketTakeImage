//
//  ViewController.swift
//  SocketTakeImage
//
//  Created by 남수김 on 2020/12/22.
//

import UIKit

class ViewController: UIViewController, StreamDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func goToClient(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "Client") as! Client
        present(nextVC, animated: false)
    }
}

//extension ViewController: ImageCaptureDelegate {
//    func didCapture(imageData: Data) {
//        imageView.image = UIImage(data: imageData)
//    }
//}

/*
class Server: NSObject, GCDAsyncSocketDelegate {
    private var server: GCDAsyncSocket?
    private var client: GCDAsyncSocket?
    
    private let port: UInt16 = 8080
    private var delegate: GCDAsyncSocketDelegate?
    deinit {
        print("server deinit")
    }
    
    func accept() {
        
        self.server = GCDAsyncSocket(delegate: self, delegateQueue: .main)
        
        self.delegate = server?.delegate
        do {
            try server?.accept(onPort: port)
        } catch let error {
            print("Cannot listen on port \(port): \(error)")
        }
        
        server?.autoDisconnectOnClosedReadStream = false
    }
    
    // Is called when a client connects to the server
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        // Creates new connection from server to client
        print("server: accept!!")
        client = sock
        sock.write("hihi".data(using: .utf8), withTimeout: 3000, tag: 0)
        client?.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        print("Receive data")
        print("Data : ", data)
        print("tag : ", tag)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        if let error = err {
            print("server Will disconnect with error: \(error)")
        }
        else{
            print("server Success disconnect")
        }
    }
}

*/
