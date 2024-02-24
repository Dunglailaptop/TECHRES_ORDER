//
//  SettingPrinterViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift

extension SettingPrinterViewController {
    //MARK: Register Cells as you want
    func registerCell(){
        let printerBillTableViewCell = UINib(nibName: "PrinterBillTableViewCell", bundle: .main)
        tableView.register(printerBillTableViewCell, forCellReuseIdentifier: "PrinterBillTableViewCell")
        
        let printerChefBarTableViewCell = UINib(nibName: "PrinterChefBarTableViewCell", bundle: .main)
        tableView.register(printerChefBarTableViewCell, forCellReuseIdentifier: "PrinterChefBarTableViewCell")
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
   
        tableView
            .rx.setDelegate(self)
            .disposed(by: rxbag)
      
        
    }
    
    func bindTableView(){
        viewModel.dataSectionArray.asObservable()
            .bind(to: tableView.rx.items){ [self] (tableView, index, element) in
                switch(element){

                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"PrinterBillTableViewCell" ) as! PrinterBillTableViewCell
                    cell.viewModel = self.viewModel
                    cell.switch_btn.isOn = viewModel.isBillPrinterOn.value
                    cell.switch_btn.rx.controlEvent(.valueChanged).withLatestFrom(cell.switch_btn.rx.value)
                    .subscribe(onNext : {[self] status in
                        /*
                                khi bấm tắt sẽ load lại row đầu tiên của table bên trong và
                                load lại section đầu tiên của self.table (table ngoài)
                             */
                        var billPrinter = viewModel.printersBill.value[0]
                        billPrinter.is_have_printer = status ? ACTIVE : DEACTIVE
                        self.viewModel.printersBill.accept([billPrinter])
                        self.updateKitchen()
                       
                        let indexPathOfSection = IndexPath(item: 0, section: 1)
                        self.viewModel.isBillPrinterOn.accept(!self.viewModel.isBillPrinterOn.value)
                        self.tableView.reloadRows(at: [indexPathOfSection], with: .fade)
                    }).disposed(by: rxbag)
                    
                 
                    return cell
          
          
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier:"PrinterChefBarTableViewCell" ) as! PrinterChefBarTableViewCell
                    cell.viewModel = viewModel
                    return cell
                }
            }
    }
    
}
extension SettingPrinterViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           
            switch indexPath.row{
                case 0:
                    /*
                         - if: nếu GPBH 1 OPTIOn 2 thì ẩn luôn section 1
                         - else : nếu nút in hoá đơn bật thì return chiều cao của section 1 = 100, ngược lại = 50
                        */
                    if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE &&
                       ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO){
                      return 0
                    }
                    return viewModel.isBillPrinterOn.value ? 120 : 60
                
                default :
                    return CGFloat(viewModel.printer_chef_bar_height.value + 60)
                                
            }
    }
}
//MARK: -- CALL API
extension SettingPrinterViewController {
    /*
    func printersBill(is_print_bill:Int){
        viewModel.printers(is_print_bill: is_print_bill).subscribe(onNext: { [unowned self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let printers = Mapper<Printer>().mapArray(JSONObject: response.data) {
                    
                    if(printers.count > 0){
                        var dataPrinters = printers
                        
                        dLog(dataPrinters.toJSONString(prettyPrint: true) as Any)
                        self.viewModel.printer_bill_height.accept(dataPrinters.count * 70)
                        
                        dataPrinters.enumerated().forEach { (index, value) in
                            if(ManageCacheObject.getPrinterBill(cache_key: KEY_PRINTER_BILL).id == value.id){
                                dataPrinters[index].is_selected = 1
                            }else{
                                dataPrinters[index].is_selected = 0
                            }
                        }
                        
                        self.viewModel.printersBill.accept(dataPrinters)
                    }else{
                        self.viewModel.printersBill.accept([])
                    }
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    */
    
    func updateKitchen(){
            viewModel.updateKitchen().subscribe(onNext: { [self] (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    if let kitchen = Mapper<Kitchen>().map(JSONObject: response.data) {
      
                        ManageCacheObject.savePrinterBill(kitchen, cache_key: KEY_PRINTER_BILL)
                        self.viewModel.isBillPrinterOn.accept(kitchen.is_have_printer == ACTIVE ? true : false)
                        let indexPathOfSection = IndexPath(item: 0, section: 1)
                        self.tableView.reloadRows(at: [indexPathOfSection], with: .fade)
                    }
                }else{
                    dLog(response.message ?? "")
                }
            }).disposed(by: rxbag)
        }
    
    func kitchens(){
        viewModel.kitchens().subscribe(onNext: { [unowned self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let kitchens = Mapper<Kitchen>().mapArray(JSONObject: response.data) {
                    if(kitchens.count > 0){
                       
                        let CashierPrinter = kitchens.filter({element in element.type == Constants.PRINTER_TYPE.CASHIER})
                        self.viewModel.printer_bill_height.accept(CashierPrinter.count * 60)
                        self.viewModel.printersBill.accept(CashierPrinter)
                        self.viewModel.isBillPrinterOn.accept(CashierPrinter.first?.is_have_printer == ACTIVE ? true : false)
                        let indexPathOfSection = IndexPath(item: 0, section: 1)
                        self.tableView.reloadRows(at: [indexPathOfSection], with: .fade)
                        
                        
                        let barChefPrinter = kitchens.filter({element in element.type == Constants.PRINTER_TYPE.BAR || element.type == Constants.PRINTER_TYPE.CHEF})
                        self.viewModel.printer_chef_bar_height.accept(barChefPrinter.count * 60)
                        self.viewModel.printersChefBar.accept(barChefPrinter)
                        
                        for kit in kitchens{
                            print(kit.name + " - status: " + String(kit.status) + " - print_number: " + String(kit.print_number) + " - is_have_printer: " + String(kit.is_have_printer))
                        }
                        ManageCacheObject.setChefBarConfigs(kitchens, cache_key: KEY_CHEF_BARS)
                        tableView.reloadData()
                    }else{
                        self.viewModel.printersChefBar.accept([])
                    }
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}
