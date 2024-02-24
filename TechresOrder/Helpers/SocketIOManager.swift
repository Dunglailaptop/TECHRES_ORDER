//
//  SocketIOManager.swift
//  Techres-Sale
//
//  Created by kelvin on 4/19/19.
//  Copyright © 2019 vn.printstudio.res.employee. All rights reserved.
//

import UIKit
import SocketIO
import ObjectMapper

class SocketIOManager: NSObject {
    //singleton
       private static var shareSocketRealtime: SocketIOManager = {
           let socketManager = SocketIOManager()
            return socketManager
       }()
    
    class func shareSocketRealtimeInstance() -> SocketIOManager {
           return shareSocketRealtime
       }
    
    
        var managerRealTime: SocketManager?
        
        var  socketRealTime:SocketIOClient?
    
    override init() {
        super.init()
        
       dLog(ManageCacheObject.getConfig().realtime_domain)
        if let url = URL(string: ManageCacheObject.isLogin() ? ManageCacheObject.getConfig().realtime_domain : APIEndPoint.endPointRealTimeURL) {
            
            let auth = ["token": ManageCacheObject.getCurrentUser().jwt_token]
               dLog(auth)
            self.managerRealTime = SocketManager(socketURL: url, config: [.log(true), .compress, .reconnects(true), .extraHeaders(auth)])
            
            let namespace = "/"
           
                
            self.socketRealTime =  self.managerRealTime!.socket(forNamespace: namespace)
            self.managerRealTime?.connectSocket(self.socketRealTime!, withPayload: auth)
            
            self.socketRealTime?.connect()
            dLog(url)
        }
        
    }
    
    func initSocketInstance(_ namespace: String) {
        
        let auth = ["token": ManageCacheObject.getCurrentUser().jwt_token]
            dLog(auth)
        self.socketRealTime =  self.managerRealTime!.socket(forNamespace: namespace)
        self.managerRealTime?.connectSocket(self.socketRealTime!, withPayload: auth)
        
        self.socketRealTime?.connect()
        
    }
    
    func establishConnection() {
      
        socketRealTime?.on("connect") {data, ack in
            dLog("connected==============: \(data.description)")
        }
        
        self.socketRealTime?.connect()

    }
    
    func closeConnection() {
        self.socketRealTime!.disconnect()
        socketRealTime?.on("disconnect") {data, ack in
            dLog("disconnect: \(data.description)")
            
        }
    }
    

 
}


class SocketChatIOManager: NSObject {
    static let sharedInstance = SocketChatIOManager()
    
    let manager = SocketManager(socketURL: URL(string:ManageCacheObject.isLogin() ? ManageCacheObject.getConfig().realtime_domain : APIEndPoint.endPointRealTimeURL)!, config: [.log(false), .compress])
   
    var  socket:SocketIOClient?
    
    override init() {
        super.init()
        self.socket = manager.defaultSocket
        
    }
    
    func establishConnection() {
        self.socket?.connect()
    }
    

    func closeConnection() {
        self.socket!.disconnect()
    }

 
}

