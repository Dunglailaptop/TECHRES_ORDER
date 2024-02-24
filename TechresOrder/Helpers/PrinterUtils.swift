//
//  PrinterUtils.swift
//  Techres - Order
//
//  Created by Kelvin on 31/03/2022.
//  Copyright © 2022 vn.techres.sale. All rights reserved.
//

import UIKit

class PrinterUtils {
    static func getLine80() -> String {
        
      return "------------------------------------------------"//48
    }
    static func getBreakLine() -> String {
        
      return "\n"
    }
    static func getTab() -> String {
        
      return "\t"
    }
    
    static func getSpace20Size() -> String {
        
      return "                    "
    }
    
    static func getSpace15Size() -> String {
        
      return "               "
    }
    
    static func getLineSpace80() -> String {
        
      return "                                              "
    }
    
    
    static func printTextData(client:TCPClient, text_data:String){
    
           switch client.connect(timeout: 5) {
           case .success:
               appendToTextField(string: "Connected to host \(client.address)")
               if let response = sendRequest(string: text_data, using: client) {
                   appendToTextField(string: "Response: \(response)")
             }
           case .failure(let error):
             appendToTextField(string: String(describing: error))
           }
        
        let cut_and_feed: [UInt8] = [0x1b, 0x69]
        client.send(data: cut_and_feed)
        client.close()
        
    }
    static func printData(client:TCPClient, data:NSData){
    
           switch client.connect(timeout: 5) {
           case .success:
               if let response = sendRequests(data: data, using: client) {
               appendToTextField(string: "Response: \(response)")
             }
           case .failure(let error):
             appendToTextField(string: String(describing: error))
           }
        
        let cut_and_feed: [UInt8] = [0x1b, 0x69]
        client.send(data: cut_and_feed)
        client.close()
        
    }

private static func sendRequests(data: NSData, using client: TCPClient) -> String? {
       appendToTextField(string: "Sending data ... ")
       
    switch client.send(data: data as Data) {
       case .success:
         return readResponse(from: client)
       case .failure(let error):
         appendToTextField(string: String(describing: error))
         return nil
       }
 }

    private static func sendRequest(string: String, using client: TCPClient) -> String? {
       appendToTextField(string: "Sending data ... ")
       
       switch client.send(string: string) {
       case .success:
         return readResponse(from: client)
       case .failure(let error):
         appendToTextField(string: String(describing: error))
         return nil
       }
     }
     
     private static func readResponse(from client: TCPClient) -> String? {
       guard let response = client.read(1024*10) else { return nil }
       
      
         
       return String(bytes: response, encoding: .utf8)
     }
     
     private static func appendToTextField(string: String) {
       print(string)
     }

    
}
