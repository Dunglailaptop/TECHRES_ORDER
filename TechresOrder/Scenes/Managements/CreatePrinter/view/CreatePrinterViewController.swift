//
//  CreatePrinterViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 31/01/2023.
//

import UIKit

class CreatePrinterViewController: BaseViewController {
    var viewModel = CreatePrinterViewModel()
    var router = CreatePrinterRouter()
    
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var textfiel_printer_name: UITextField!
    @IBOutlet weak var textfiel_printer_ip_address: UITextField!
    @IBOutlet weak var textfiel_printer_port: UITextField!
    
    @IBOutlet weak var btnFindPrinter: UIButton!
    
    @IBOutlet weak var btnPrintTest: UIButton!
    
    @IBOutlet weak var btnPrinterCreate: UIButton!
    
    @IBOutlet weak var btnPrinterCreateUpdate: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lbl_create_update_printer: UILabel!
    var isUpdate = 0
    var printer = Kitchen.init()
    
    

    let left_space = 26
    var amount = 0
    var total_payment = 0
    var discount = 200000
    var vat = 210000

    let host = "172.16.1.233"
    let port = 9100
    var client: TCPClient?
    
    var print_foods = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        client = TCPClient(address: ManageCacheObject.getPrinterBill(cache_key: KEY_PRINTER_BILL).printer_ip_address, port: Int32(PRINTER_PORT))

        for i in 1...10{
            var food = Food()
            food.id = i
            food.name =  "Cơm sườn"
            food.quantity = Float(i)
            food.price = 12000000 + i
            food.note = "ghi chu món ăn"
            print_foods.append(food)
        }
        
        
        btnBack.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
        
        btnPrintTest.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                            self!.printer?.printer_name = self!.textfiel_printer_name.text ?? ""
                            self!.printer?.printer_ip_address = self!.textfiel_printer_ip_address.text ?? ""
                            self!.printer?.printer_port = self!.textfiel_printer_port.text ?? ""
                            self!.printer?.printer_port = self!.textfiel_printer_port.text ?? ""
                            self!.viewModel.kitchen.accept((self!.printer)!)
                           ManageCacheObject.savePrinterBill((self?.printer)!, cache_key: KEY_PRINTER_BILL)
                           self?.createReceiptData(food_prepare_prints: self!.print_foods)
//
//                            self!.printer?.printer_name = self!.textfiel_printer_name.text ?? ""
//                            self!.printer?.printer_ip_address = self!.textfiel_printer_ip_address.text ?? ""
//                            self!.printer?.printer_port = self!.textfiel_printer_port.text ?? ""
//                            self!.printer?.printer_port = self!.textfiel_printer_port.text ?? ""
//                           self!.viewModel.printer.accept((self!.printer)!)
//                           self?.updatePrinter()
                       }).disposed(by: rxbag)
        
        btnFindPrinter.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.presentModalDialogFindPrinterViewController()
                       }).disposed(by: rxbag)
//
        btnPrinterCreateUpdate.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.printer?.printer_name = self!.textfiel_printer_name.text ?? ""
                           self!.printer?.printer_ip_address = self!.textfiel_printer_ip_address.text ?? ""
                           self!.printer?.printer_port = self!.textfiel_printer_port.text ?? ""
                           self!.printer?.printer_port = self!.textfiel_printer_port.text ?? ""
                           self?.printer?.printer_paper_size = 80
                           self!.printer?.type = CASHIER
                          self!.viewModel.kitchen.accept((self!.printer)!)
                           self?.updateKitchen()
                       }).disposed(by: rxbag)
        
    
        if let printer = self.printer{
            textfiel_printer_name.text = printer.printer_name
            textfiel_printer_ip_address.text = printer.printer_ip_address
            textfiel_printer_port.text = printer.printer_port
            if(isUpdate == ACTIVE){
                btnPrinterCreateUpdate.setTitle("CẬP NHẬT MÁY IN", for: .normal)
            }
        }
        
    }


    @IBAction func actionCreateUpdate(_ sender: Any) {
        // CALL API UPDATE PRINTER
        self.printer?.printer_name = self.textfiel_printer_name.text ?? ""
        self.printer?.printer_ip_address = self.textfiel_printer_ip_address.text ?? ""
        self.printer?.printer_port = self.textfiel_printer_port.text ?? ""
        self.printer?.printer_port = self.textfiel_printer_port.text ?? ""
        self.printer?.type = CASHIER
        self.printer?.printer_paper_size = 80
        self.viewModel.kitchen.accept((self.printer)!)
     //   viewModel.makePopViewController()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
