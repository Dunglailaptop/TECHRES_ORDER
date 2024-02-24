//
//  CreatePrinterViewController+Extension.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 31/01/2023.
//

import UIKit

extension CreatePrinterViewController{
    func updateKitchen(){
        viewModel.updateKitchen().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Update Kitchen Success...")
                self.viewModel.makePopViewController()
            }
        }).disposed(by: rxbag)
        
//    func updatePrinter(){
//        viewModel.updatePrinter().subscribe(onNext: { (response) in
//            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                dLog("Update printer Success...")
//                Toast.show(message: "Cập nhật máy in thành công...", controller: self)
//                self.viewModel.makePopViewController()
//            }else{
//                Toast.show(message: response.message ?? "Có lỗi xảy ra từ phía máy chủ", controller: self)
//            }
//        }).disposed(by: rxbag)
}
    
}

extension CreatePrinterViewController{
    // ============== Handler printer ==============
   
    func createReceiptData(food_prepare_prints:[Food]) {
        let textData: NSMutableString = NSMutableString()
        textData.append("                    ")//20
        textData.append(String(format: "%@", "HOA DON"))
        textData.append("               ")//15
        textData.append("\n")
        
        
        
        textData.append("                ")//16
        textData.append(String(format: "Hoa don so: %@ ", "#32342"))
        textData.append("               ")//15
        textData.append("\n")
        
      
        textData.append(String(format: "Ngay: %@", Utils.getFullCurrentDate()))
        textData.append("\n")
        
        
        textData.append(String(format: "Ban: %@\n","A1"))
        textData.append(String(format: "Nhan vien: %@\n", ConverHelper.convertVietNam(text: ManageCacheObject.getCurrentUser().name)))
        textData.append(String(format: "So Dien Thoai: %@\n", "0925 123 123"))
        textData.append(PrinterUtils.getLine80())
        
        
        // Section 2 : Purchaced items
        for food in self.print_foods {
            amount += food.price
            total_payment += amount + vat - discount
            let total_amount = Float(food.price) * Float(food.quantity)
            
            
            textData.append(String(format: "%@", ConverHelper.convertVietNam(text: food.name)))
//            let remind_number = left_space - ConverHelper.convertVietNam(text: food.name).count
//            dLog(ConverHelper.convertVietNam(text: food.name).count)
//            if(remind_number > 0){
//                for _number in (0...remind_number) {
//                    textData.append(" ")
//                }
//            }
//            textData.append(String(format: "          %@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(total_amount))))
            /*Tổng số ký tự trên 1  dòng của bill là 48*/
            let remaining_space = 48 - ConverHelper.convertVietNam(text: food.name).count - Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(total_amount)).count
            if(remaining_space > 0){
                for _number in (0..<remaining_space) {
                    textData.append(" ")
                }
            }
            textData.append(String(format: "%@", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(total_amount))))
           
            textData.append(String(format: "%d x %@", Int(food.quantity), Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(food.price))))
           
            textData.append(PrinterUtils.getBreakLine())
            
           

            textData.append(PrinterUtils.getLine80())
            textData.append(PrinterUtils.getBreakLine())
            
        }
        
     
        
        textData.append("THANH TIEN:")
        textData.append("                          ")//23
        textData.append(Utils.stringVietnameseMoneyFormatWithNumberInt(amount: self.amount))
        textData.append(PrinterUtils.getBreakLine())
        
        textData.append("GIAM GIA:  ")
        textData.append("                          ")//23
        textData.append(Utils.stringVietnameseMoneyFormatWithNumberInt(amount: self.discount))
        textData.append(PrinterUtils.getBreakLine())
        
        textData.append("VAT:       ")
        textData.append("                          ")//23
        textData.append(Utils.stringVietnameseMoneyFormatWithNumberInt(amount: self.vat))
        textData.append(PrinterUtils.getBreakLine())
        
        
        textData.append("THANH TOAN:")
        textData.append("                          ")//23

        textData.append(Utils.stringVietnameseMoneyFormatWithNumberInt(amount: self.total_payment))
        textData.append(PrinterUtils.getBreakLine())
        
        textData.append(PrinterUtils.getLine80())
        textData.append(PrinterUtils.getBreakLine())
        
        textData.append("              ")//10
        textData.append("TRAN TRONG CAM ON!")
        textData.append("              ")//10
        textData.append(PrinterUtils.getBreakLine())
        
        textData.append("   ")//3
        textData.append(String(format: "%@", "TECHRES.VN SP CUA OVERATE-VNTECH"))//32
        textData.append("    ")//4
        textData.append(PrinterUtils.getBreakLine())
        
     
        
        textData.append("\n")
        textData.append("\n")
        textData.append("\n")
        
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
        textData.append(PrinterUtils.getBreakLine())
               
        PrinterUtils.printTextData(client: self.client!, text_data: textData.substring(from: 0))
        self.client?.close()
    }
    
//    ========= End Handler printer ==============
    
    
}
