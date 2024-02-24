//
//  OrderDetailViewController+HandlerPrinter+Extensions.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 28/01/2023.
//

import UIKit

extension OrderDetailViewController {

        // ============== Handler printer ==============
        
        //MARK: print_type = 0 => món mới; print_type = 1 => món cập nhật tăng giảm; print_type = 2 => món huỷ;
        func runPrinterChefSequence(food_prints:[Food], print_type:Int) {
            DispatchQueue(label: "queue", attributes: .concurrent).async {
            let chef_bars = ManageCacheObject.getChefBarConfigs(cache_key: KEY_CHEF_BARS)
 
            for chef_bar in chef_bars {
                if(chef_bar.is_have_printer == ACTIVE){
                    var prepare_food_prints = [Food]()
                    debugPrint(String(format: "Hình thức in phiếu chế biến: ",  chef_bar.is_print_each_food))
                    prepare_food_prints.removeAll()
                    for food in food_prints {
                        if food.restaurant_kitchen_place_id == chef_bar.id {
                            prepare_food_prints.append(food)
                        }
                    }
                    if(prepare_food_prints.count > 0){
                        if chef_bar.is_print_each_food == ACTIVE {
                      
//                            DispatchQueue(label: "queue", attributes: .concurrent).async {
                                for fd in prepare_food_prints {
                                    for _ in 1...chef_bar.print_number{
                                        self.createChef(food: fd, print_type: print_type, ketchen:chef_bar)
                                        sleep(1)
                                    }
                                  
//                                }
                            }
                           
                        }else{
//                            DispatchQueue(label: "queue", attributes: .concurrent).async {
                            for _ in 1...chef_bar.print_number{
                                self.createChefBarDatas(food_prints: prepare_food_prints, print_type: print_type, ketchen:chef_bar)
                                sleep(1)
//                            }
                             
                        }
                            
                        }
                    }
                }
                
            }
            }
         
        }
        
        //MARK: print_type = 0 => món mới; print_type = 1 => món cập nhật tăng giảm; print_type = 2 => món huỷ;
        func runPrinterBarSequence(food_prints:[Food], print_type:Int) {
            DispatchQueue(label: "pham_khanh_huy", attributes: .concurrent).async {
            let chef_bars = ManageCacheObject.getChefBarConfigs(cache_key: KEY_CHEF_BARS)
            dLog(chef_bars.toJSON())
            var prepar_food_prints = [Food]()
            for chef_bar in chef_bars {
                if(chef_bar.is_have_printer == ACTIVE){
                    prepar_food_prints.removeAll()
                    for food in food_prints {
                        if food.restaurant_kitchen_place_id == chef_bar.id {
                            prepar_food_prints.append(food)
                        }
                    }

                    if(prepar_food_prints.count > 0){
                        if chef_bar.is_print_each_food == ACTIVE {
                            dLog(prepar_food_prints)
                            
                                dLog(prepar_food_prints)
                                for fd in prepar_food_prints {
                                    for _ in 1...chef_bar.print_number{
                                        self.createChef(food: fd, print_type: print_type, ketchen:chef_bar)
                                        sleep(1)
                                    }
                                }
                                
                            
                        }else{

                                for _ in 1...chef_bar.print_number{
                                    self.createChefBarDatas(food_prints: prepar_food_prints, print_type: print_type, ketchen:chef_bar)
                                    sleep(1)
                                    
                                }
                            
                        }
                    }
                }
            }
            }
        }
        
        func createChefBarDatas(food_prints:[Food], print_type:Int, ketchen:Kitchen) {
        
            client = TCPClient(address: ketchen.printer_ip_address, port: Int32(PRINTER_PORT))
        
            
            let textData: NSMutableString = NSMutableString()

            
            let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
            print(timestamp)
            
            var title = "PHIEU MOI"
            
            if(print_type == 0){
                title = "PHIEU MOI"
            }else if(print_type == 1){
                title = "PHIEU CAP NHAT SO LUONG"
            }else if (print_type == 2){
                title = "PHIEU HUY"
            } else {
                title = "PHIEU TRA"
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
            
            if (print_type == 3){//phiếu trả
                
                textData.append(String(format: "Ten mon: %@", ConverHelper.convertVietNam(text: food_prints[0].name)))
                textData.append(PrinterUtils.getBreakLine())

                textData.append(String(format: "So luong da goi: %d", Int(food_prints[0].printed_quantity)))
                textData.append(PrinterUtils.getBreakLine())
                
                textData.append(String(format: "So luong cap nhat: %d", Int(food_prints[0].quantity)))
                textData.append(PrinterUtils.getBreakLine())
                
                textData.append(String(format: "Ma HD: %d", self.orderData!.id))
                textData.append(PrinterUtils.getBreakLine())
                
                textData.append(String(format: "Ten Ban: %@",ConverHelper.convertVietNam(text: self.orderData!.table_name)))
                textData.append(PrinterUtils.getBreakLine())
                
                textData.append(String(format: "Ghi chu: %@", ConverHelper.convertVietNam(text: self.note_return))) // lý do trả món
                textData.append(PrinterUtils.getBreakLine())
                
                textData.append(String(format: "Nhan vien: %@", ConverHelper.convertVietNam(text: self.orderData!.employee_name)))
                textData.append(PrinterUtils.getBreakLine())
                 
                textData.append(String(format: "Ngay: %@", Utils.getFullCurrentDate()))
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getLine80())

                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
            }else{
            
                textData.append(String(format: "Ngay: %@", Utils.getFullCurrentDate()))
                textData.append(PrinterUtils.getBreakLine())
                textData.append(String(format: "Ma HD: %d", self.orderData!.id))
                textData.append(PrinterUtils.getBreakLine())
                
                textData.append(String(format: "Ban: %@",ConverHelper.convertVietNam(text: self.orderData!.table_name)))
                textData.append(PrinterUtils.getBreakLine())
                textData.append(String(format: "Nhan vien: %@", ConverHelper.convertVietNam(text: self.orderData!.employee_name)))
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
                   
                    if print_type == 3 {
                        textData.append(String(format: "%d", Int(food.printed_quantity) - Int(food.quantity)))
                        textData.append(PrinterUtils.getBreakLine())
                    }
                    
                    if(print_type == 0 || print_type == 2){ // huy hoac them moi (cũ print_type != 1)
                        textData.append(String(format: "%d", Int(food.quantity)))
                        if print_type == 0 && !food.note.isEmpty {
                            textData.append(PrinterUtils.getBreakLine())
                            let note = food.note.folding(options: .diacriticInsensitive, locale: .current)
                            textData.append(String(format: "(%@)", note))
                        }
                        textData.append(PrinterUtils.getBreakLine())
                    }else{
                        textData.append(PrinterUtils.getBreakLine())
                    }
                    
                    textData.append(PrinterUtils.getLine80())
                    textData.append(PrinterUtils.getBreakLine())
                    
                }
                
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
            }
            
            
            PrinterUtils.printTextData(client: self.client!, text_data: textData.substring(from: 0))
            
        }

        func createChef(food:Food, print_type:Int, ketchen:Kitchen) {
        
            client = TCPClient(address: ketchen.printer_ip_address, port: Int32(PRINTER_PORT))

            let textData: NSMutableString = NSMutableString()

            
            let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
            print(timestamp)
            
            var title = "PHIEU MOI"
            
            if(print_type == 0){
                title = "PHIEU MOI"
            }else if(print_type == 1){
                title = "PHIEU CAP NHAT SO LUONG"
            }else if (print_type == 2){
                title = "PHIEU HUY"
            } else {
                title = "PHIEU TRA"
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
            if (print_type == 3){//phiếu trả
                textData.append(String(format: "Ten mon: %@", ConverHelper.convertVietNam(text: food.name)))
                textData.append(PrinterUtils.getBreakLine())
                
                textData.append(String(format: "So luong da goi: %d", Int(food.printed_quantity)))
                textData.append(PrinterUtils.getBreakLine())
                
                textData.append(String(format: "So luong cap nhat: %d", Int(food.quantity)))
                textData.append(PrinterUtils.getBreakLine())
                
                textData.append(String(format: "Ma HD: %d", self.orderData!.id))
                textData.append(PrinterUtils.getBreakLine())
                
                textData.append(String(format: "Ten Ban: %@",ConverHelper.convertVietNam(text: self.orderData!.table_name)))
                textData.append(PrinterUtils.getBreakLine())
                
                textData.append(String(format: "Ghi chu: %@", ConverHelper.convertVietNam(text: self.note_return))) // lý do trả món
                textData.append(PrinterUtils.getBreakLine())
                
                textData.append(String(format: "Nhan vien: %@", ConverHelper.convertVietNam(text: self.orderData!.employee_name)))
                textData.append(PrinterUtils.getBreakLine())
                 
                textData.append(String(format: "Ngay: %@", Utils.getFullCurrentDate()))
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getLine80())

                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
            }else{
                textData.append(String(format: "Ngay: %@", Utils.getFullCurrentDate()))
                textData.append(PrinterUtils.getBreakLine())
                textData.append(String(format: "Ma HD: %d", self.orderData!.id))
                textData.append(PrinterUtils.getBreakLine())
                textData.append(String(format: "Ban: %@",ConverHelper.convertVietNam(text: self.orderData!.table_name)))
                textData.append(PrinterUtils.getBreakLine())
                textData.append(String(format: "Nhan vien: %@", ConverHelper.convertVietNam(text: self.orderData!.employee_name)))
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
                
                if print_type == 3 {
                    textData.append(String(format: "%d", Int(food.printed_quantity) - Int(food.quantity)))
                    textData.append(PrinterUtils.getBreakLine())
                }
                
                if(print_type == 0 || print_type == 2){ // huy hoac them moi (cũ print_type != 1)
                    textData.append(String(format: "%d", Int(food.quantity)))
                    if print_type == 0 && !food.note.isEmpty {
                        textData.append(PrinterUtils.getBreakLine())
                        let note = food.note.folding(options: .diacriticInsensitive, locale: .current)
                        textData.append(String(format: "(%@)", note))
                    }
                    textData.append(PrinterUtils.getBreakLine())
                }else{
                    textData.append(PrinterUtils.getBreakLine())
                }
                
                textData.append(PrinterUtils.getLine80())
                textData.append(PrinterUtils.getBreakLine())
                
                //        }
                
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
                textData.append(PrinterUtils.getBreakLine())
            }
        
            
            
            PrinterUtils.printTextData(client: self.client!, text_data: textData.substring(from: 0))
            self.client?.close()
        }
        
        
    //    ========= End Handler printer ==============
    
}
