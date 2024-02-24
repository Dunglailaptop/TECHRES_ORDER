//
//  OutSocket.swift
//  TECHRES-ORDER
//
//  Created by Kelvin on 22/09/2023.
//

import UIKit

class OutSocket {

    var addr: String
    var port: Int
    var task: URLSessionStreamTask!

    init(host: String, port: Int){
        print("init")
        self.addr = host
        self.port = port
        setupConnection()
    }

    func setupConnection() {
        print("setup")
        let session = URLSession(configuration: .default)

        task = session.streamTask(withHostName: addr, port: port)
        self.task.resume()
    }

    func send(data: NSData) {
        self.task.write(data as Data, timeout: 5.0) { (error) in
            if error == nil {
                print("Data sent")
            } else {
                print("Nope")
            }
        }
    }
}

