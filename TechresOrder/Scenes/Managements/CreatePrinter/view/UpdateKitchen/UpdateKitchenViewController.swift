//
//  UpdateKitchenViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 31/01/2023.
//

import UIKit
import RxSwift
class UpdateKitchenViewController: BaseViewController,UITextFieldDelegate {
    var viewModel = UpdateKitchenViewModel()
    var router = UpdateKitchenRouter()
    var kitchen = Kitchen.init()

    
    @IBOutlet weak var textfield_print_name: UITextField!
    @IBOutlet weak var textfield_print_ipaddress: UITextField!
    @IBOutlet weak var textfield_print_port: UITextField!
    
    @IBOutlet weak var textfield_print_number: UITextField!
    
    @IBOutlet weak var btnPrintOneBill: UIButton!
    @IBOutlet weak var btnPrintPrivateBill: UIButton!
    
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnPrintTest: UIButton!
    
    @IBOutlet weak var btnFindPrinter: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var printerSwitch: UISwitch!
    @IBOutlet weak var btnPrintOneBillCheck: UIButton!
    @IBOutlet weak var btnPrintPrivateBillCheck: UIButton!
    @IBOutlet weak var viewSnapShot: UIView!
    
    
    var isOnlyBillPrint = 0
    
    
    let left_space = 27
    var amount = 0
    var total_payment = 0
    var discount = 200000
    var vat = 210000

    let host = "172.16.1.233"
    let port = 9100
    var client: TCPClient?
    
    var print_foods = [Food]()
    
    var print_number = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSnapShot.isHidden = true
        // Do any additional setup after loading the view.
        for i in 1...5{
            var food = Food()
            food.id = i
            food.name =  "Cơm sườn"
            food.quantity = Float(i)
            food.price = 12000000
            food.note = "ghi chu"
            print_foods.append(food)
        }
        
        viewModel.bind(view: self, router: router)
        if let kitchen = kitchen{
            
            textfield_print_name.text = kitchen.printer_name
            textfield_print_ipaddress.text = kitchen.printer_ip_address
            textfield_print_port.text = kitchen.printer_port
            textfield_print_number.text = String(kitchen.print_number)
            isOnlyBillPrint = kitchen.is_print_each_food
            printerSwitch.isOn = kitchen.is_have_printer == ACTIVE ? true : false
            btnPrintTest.isEnabled = kitchen.is_have_printer == ACTIVE ? true : false
            print_number = kitchen.print_number
            
            if(isOnlyBillPrint == ACTIVE){
                btnPrintOneBillCheck.setImage(UIImage(named:"icon-radio-uncheck"), for: .normal)
                btnPrintPrivateBillCheck.setImage(UIImage(named:"icon-radio-checked"), for: .normal)
            }else{
                btnPrintOneBillCheck.setImage(UIImage(named:"icon-radio-checked"), for: .normal)
                btnPrintPrivateBillCheck.setImage(UIImage(named:"icon-radio-uncheck"), for: .normal)
            }
            
        }
       
        
        btnFindPrinter.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           dLog("btnFindPrinter")
                           self?.presentModalDialogFindPrinterViewController()
                       }).disposed(by: rxbag)
        
        btnPrintOneBill.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in //in tất cả order trên 1 phiếu
                           self!.isOnlyBillPrint = ACTIVE
                           self?.kitchen?.is_print_each_food = DEACTIVE
                           if(self?.isOnlyBillPrint == ACTIVE){
                               self!.btnPrintOneBillCheck.setImage(UIImage(named:"icon-radio-checked"), for: .normal)
                               self!.btnPrintPrivateBillCheck.setImage(UIImage(named:"icon-radio-uncheck"), for: .normal)
                           }else{
                               self!.btnPrintOneBillCheck.setImage(UIImage(named:"icon-radio-uncheck"), for: .normal)
                               self!.btnPrintPrivateBillCheck.setImage(UIImage(named:"icon-radio-checked"), for: .normal)
                           }
                           self?.viewModel.kitchen.accept((self?.kitchen)!)
                           
                       }).disposed(by: rxbag)

        
       
        textfield_print_number.addTarget(self, action: #selector(textFieldDidEndEditing), for: UIControl.Event.editingChanged)
        
        
    
        btnPrintPrivateBill.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in // in riêng từng món
                           self!.isOnlyBillPrint = DEACTIVE
                           self?.kitchen?.is_print_each_food = ACTIVE
                           if(self?.isOnlyBillPrint == ACTIVE){
                               self!.btnPrintOneBillCheck.setImage(UIImage(named:"icon-radio-checked"), for: .normal)
                               self!.btnPrintPrivateBillCheck.setImage(UIImage(named:"icon-radio-uncheck"), for: .normal)
                           }else{
                               self!.btnPrintOneBillCheck.setImage(UIImage(named:"icon-radio-uncheck"), for: .normal)
                               self!.btnPrintPrivateBillCheck.setImage(UIImage(named:"icon-radio-checked"), for: .normal)
                           }
                           self?.viewModel.kitchen.accept((self?.kitchen)!)
                           
                       }).disposed(by: rxbag)
        

        
        btnUpdate.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                        // CALL API UPDATE KITCHEN
                           self?.kitchen?.printer_name = self!.textfield_print_name.text ?? ""
                           self?.kitchen?.printer_ip_address = self!.textfield_print_ipaddress.text ?? ""
                           self?.kitchen?.printer_port = self!.textfield_print_port.text ?? ""
                           self?.kitchen?.printer_paper_size = 1
                           self?.kitchen?.is_have_printer = self!.printerSwitch.isOn ? ACTIVE : DEACTIVE
                           self?.kitchen?.print_number = Int(self!.textfield_print_number.text!)!
                           self?.viewModel.kitchen.accept((self?.kitchen)!)
                           self?.updateKitchen()
                       }).disposed(by: rxbag)
        
        btnPrintTest.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           if(self!.isOnlyBillPrint == DEACTIVE){

                               DispatchQueue(label: "queue", attributes: .concurrent).async {
                                  
                                   
                                   for _ in 0..<self!.print_number{
                                       self!.createChefBarDatas(food_prints: self!.print_foods, print_type: 0)
                                       sleep(1)
                                   }
                                   
                               }
  
                           }else{
                               //self?.snapShot()
                               
                               DispatchQueue(label: "queue", attributes: .concurrent).async {
                                   for _ in 0..<self!.print_number{
                                       for food in self!.print_foods {
                                           self!.createChefBarPrintEachFood(food: food, print_type: 0)
                                           sleep(1)
                                       }
                                   }
                               }
                                

                           }
                           
                       }).disposed(by: rxbag)
        
        btnBack.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
        
        
    }
    
    
    @objc internal func textFieldDidEndEditing(_ textField: UITextField) {
        
        /*
            nếu empty thì tự động trả về một
            chia lấy dự cho 10 để lấy dc số cuối cùng vì value thật chất là luôn > 10
         */
        guard let value = Int(textField.text!) else {
            textField.text = String(1)
            return
        }
        
        let remainder = value%10
        textField.text = String(remainder)

        if(remainder > 5){
            textField.text = String(5)
        }else if (remainder < 1){
            textField.text = String(1)
        }
    
    }

}
