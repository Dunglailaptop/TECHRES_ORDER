//
//  UpdateKitechenViewController+Extensions.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 31/01/2023.
//

import UIKit
import Printer

extension UpdateKitchenViewController{
    func updateKitchen(){
        viewModel.updateKitchen().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Update Kitchen Success...")
                self.viewModel.makePopViewController()
            }
        }).disposed(by: rxbag)
    }
    
}
extension UpdateKitchenViewController{
    // ============== Handler printer ==============
   
    func createChefBarDatas(food_prints:[Food], print_type:Int) {
    
        client = TCPClient(address: self.textfield_print_ipaddress.text!, port: Int32(PRINTER_PORT))

        let textData: NSMutableString = NSMutableString()
        let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
        print(timestamp)
        
        var title = "PHIEU MOI"
        
        if(print_type == 0){
            title = "PHIEU MOI"
        }else if(print_type == 1){
            title = "PHIEU CAP NHAT SO LUONG"
        }else{
            title = "PHIEU HUY"
        }
        
        let remind_number_title = PrinterUtils.getLineSpace80().count - ConverHelper.convertVietNam(text: String(format: "%@", title)).count
         let left_space = remind_number_title/2
         let right_space = remind_number_title/2
        
        for _ in (0...left_space) {
            textData.append(" ")
        }
        textData.append(String(format: "%@", title))
       
        for _ in (0...right_space) {
            textData.append(" ")
        }
     
        textData.append(PrinterUtils.getBreakLine())

    
        textData.append(String(format: "Ngay: %@", Utils.getFullCurrentDate()))
        textData.append(PrinterUtils.getBreakLine())
        textData.append(String(format: "Ma HD: %@", "05062001"))
        textData.append(PrinterUtils.getBreakLine())
        textData.append(String(format: "Ban: %@", "Ban A1"))
        textData.append(PrinterUtils.getBreakLine())
        textData.append(String(format: "Nhan vien: %@","Phuc vu 001"))
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getLine80())

        
        // Section 2 : Purchaced items
        for food in food_prints {

            //"Món gà số lượng thay đổi từ 2 thành 4"
            var food_name = ""
            if(print_type == 1){
                var quantity_change = Int(food.quantity) - Int(food.printed_quantity)
            
                let current_quantity = Int(food.quantity)
                let printed_quantity = Int(food.printed_quantity)
                
                if(quantity_change > 0){
                    food_name = String(format: "%@ tang tu %@ thanh %@", ConverHelper.convertVietNam(text: food.name), String(format: "%d", printed_quantity), String(format: "%d", current_quantity))
                }else{
                    quantity_change = printed_quantity - current_quantity
                    food_name = String(format: "%@ giam tu %@ thanh %@",ConverHelper.convertVietNam(text: food.name), String(format: "%d", printed_quantity), String(format: "%d", quantity_change))
                }
            }else{
                food_name = String(format: "%@", ConverHelper.convertVietNam(text: food.name))
            }
            
            textData.append(food_name)
            let remind_number = PrinterUtils.getLineSpace80().count - ConverHelper.convertVietNam(text: food.name).count - 2
            print(food.name)
            if(remind_number > 0){
                for _ in (0...remind_number) {
                    textData.append(" ")
                }
            }
            if(print_type != 1){
                textData.append(String(format: "%d", Int(food.quantity)))
                textData.append(PrinterUtils.getBreakLine())
            }else{
                textData.append(PrinterUtils.getBreakLine())
            }
            
//            textData.append(PrinterUtils.getLine80())
            textData.append(PrinterUtils.getBreakLine())
            
        }
        
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        
        PrinterUtils.printTextData(client: self.client!, text_data: textData.substring(from: 0))
//        self.client?.close()
    }
    
    func createChefBarPrintEachFood(food:Food, print_type:Int) {
        
        
        
        client = TCPClient(address: self.textfield_print_ipaddress.text!, port: Int32(PRINTER_PORT))
        
        let textData: NSMutableString = NSMutableString()
        let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
        print(timestamp)
        
        var title = "PHIEU MOI"
        
        if(print_type == 0){
            title = "PHIEU MOI"
        }else if(print_type == 1){
            title = "PHIEU CAP NHAT SO LUONG"
        }else{
            title = "PHIEU HUY"
        }
        
        let remind_number_title = PrinterUtils.getLineSpace80().count - ConverHelper.convertVietNam(text: String(format: "%@", title)).count
         let left_space = remind_number_title/2
         let right_space = remind_number_title/2
        
        for _ in (0...left_space) {
            textData.append(" ")
        }
        textData.append(String(format: "%@", title))
       
        for _ in (0...right_space) {
            textData.append(" ")
        }
     
        textData.append(PrinterUtils.getBreakLine())

    
        textData.append(String(format: "Ngay: %@", Utils.getFullCurrentDate()))
        textData.append(PrinterUtils.getBreakLine())
        textData.append(String(format: "Ma HD: %@", "05062001"))
        textData.append(PrinterUtils.getBreakLine())
        textData.append(String(format: "Ban: %@", "Ban A1"))
        textData.append(PrinterUtils.getBreakLine())
        textData.append(String(format: "Nhan vien: %@","Phuc vu 001"))
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getLine80())

        
        // Section 2 : Purchaced items
//        for food in food_prints {

            //"Món gà số lượng thay đổi từ 2 thành 4"
            var food_name = ""
            if(print_type == 1){
                var quantity_change = Int(food.quantity) - Int(food.printed_quantity)
            
                let current_quantity = Int(food.quantity)
                let printed_quantity = Int(food.printed_quantity)
                
                if(quantity_change > 0){
                    food_name = String(format: "%@ tang tu %@ thanh %@", ConverHelper.convertVietNam(text: food.name), String(format: "%d", printed_quantity), String(format: "%d", current_quantity))
                }else{
                    quantity_change = printed_quantity - current_quantity
                    food_name = String(format: "%@ giam tu %@ thanh %@",ConverHelper.convertVietNam(text: food.name), String(format: "%d", printed_quantity), String(format: "%d", quantity_change))
                }
            }else{
                food_name = String(format: "%@", ConverHelper.convertVietNam(text: food.name))
            }
            
            textData.append(food_name)
            let remind_number = PrinterUtils.getLineSpace80().count - ConverHelper.convertVietNam(text: food.name).count - 2
            print(food.name)
            if(remind_number > 0){
                for _ in (0...remind_number) {
                    textData.append(" ")
                }
            }
            if(print_type != 1){
                textData.append(String(format: "%d", Int(food.quantity)))
                textData.append(PrinterUtils.getBreakLine())
            }else{
                textData.append(PrinterUtils.getBreakLine())
            }
//            textData.append(PrinterUtils.getLine80())
            textData.append(PrinterUtils.getBreakLine())
//        }
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        dLog(textData)
        
        
        
       
//        PrinterUtils.printTextData(client: self.client!, text_data: receipt)

//        let receipt = Receipt(.🖨️58(.ascii))
//        <<< textData.capitalized(with: .current)
//        PrinterUtils.printData(client: client!, data: Data(receipt.data) as NSData)
        
        PrinterUtils.printTextData(client: self.client!, text_data: textData.substring(from: 0))
//        client?.close()
        
        
    }
//    ========= End Handler printer ==============
}
extension UpdateKitchenViewController{
    
    func snapShot(){
        
        let socket = OutSocket(host: self.textfield_print_ipaddress.text!, port: 9100)
        let image = UIImage(named: "image_defauft_medium")
        let imgData = image!.pngData()
//        let imgEncoded =  image!.pngData()! as NSData
        socket.send(data: imgData as! NSData)
        
        
        //Chụp màn hình
        viewSnapShot.isHidden = true
        let delay = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
           // self.makeSnapshot(view: self.viewSnapShot)
//            self.hideViewSnapShot()
//            self.viewCode.isHidden = true
//            self.heightViewCode.constant = 0
        }
    }
    func makeSnapshot(view:UIView) {
      
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        let image = screenshot
        viewSnapShot.isHidden = true
        
//        let imageData: NSData = image!.pngData()! as NSData

        
//        let socket = OutSocket(host: self.textfield_print_ipaddress.text!, port: Int(Int32(PRINTER_PORT)))
//        let imgData = image!.pngData()
//        let imgEncoded = imgData!.base64EncodedDataWithOptions(.Encoding64CharacterLineLength)
//        socket.send(imgEncoded)
        
        
//        client = TCPClient(address: self.textfield_print_ipaddress.text!, port: Int32(PRINTER_PORT))
//
//        PrinterUtils.printData(client: client!, data: imageData)

        
        
    }
    
}
