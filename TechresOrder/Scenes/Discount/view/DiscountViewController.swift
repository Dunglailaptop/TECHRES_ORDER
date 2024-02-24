//
//  DiscountViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 20/01/2023.
//

import UIKit
import Alamofire
import JonAlert
class DiscountViewController: BaseViewController {
    var viewModel = DiscountViewModel()
    var router = DiscountRouter()
    let listName = ["Khách quen của quán","Khách vip của quán","Chương trình khuyến mãi", "Khác"]

    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var btnDiscountTotalBill: UIButton!
    @IBOutlet weak var btnDiscountFood: UIButton!
    @IBOutlet weak var btnDiscountDrink: UIButton!
    @IBOutlet weak var btnDiscountReason: UIButton!
    @IBOutlet weak var textfield_discount_percent: UITextField!
    @IBOutlet weak var textfield_discount_reason: UITextField!

    @IBOutlet weak var rdDiscountTotalBill: UIButton!
    @IBOutlet weak var rdDiscountFood: UIButton!
    @IBOutlet weak var rdDiscountDrink: UIButton!

    @IBOutlet weak var btnDiscount: UIButton!
    var discount_type = 1
    var order_id = 0
    var delegate:DiscountDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        root_view.round(with: .both, radius: 8)
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        
        self.viewModel.note.accept(self.listName[0])
        
        //bind value of textfield to variable of viewmodel
//        _ = textfield_discount_percent.rx.text.map { $0 ?? "" }.bind(to: viewModel.discountReasonText)
        _ = textfield_discount_reason.rx.text.map { $0 ?? "" }.bind(to: viewModel.note)
        
        _ = viewModel.isValid.subscribe({ [weak self] isValid in
            dLog(isValid)
            guard let strongSelf = self, let isValid = isValid.element else { return }
            strongSelf.btnDiscount.isEnabled = isValid
            strongSelf.btnDiscount.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
            strongSelf.btnDiscount.titleLabel?.textColor = .white
            
        })
        
        
        // action btnDiscountTotalBill
        btnDiscountTotalBill.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           dLog("action btnDiscountTotalBill")
                           self!.discount_type = 1
                           if let image  = UIImage(named: "icon-radio-checked") {
                               self!.rdDiscountTotalBill.setImage(image, for: .normal)
                           }
                           if let image  = UIImage(named: "icon-radio-uncheck") {
                               self!.rdDiscountFood.setImage(image, for: .normal)
                           }
                           if let image  = UIImage(named: "icon-radio-uncheck") {
                               self!.rdDiscountDrink.setImage(image, for: .normal)
                           }
                       }).disposed(by: rxbag)
        
        // action btnDiscountFood
        btnDiscountFood.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           dLog("action btnDiscountFood")
                           self!.discount_type = 2
                           if let image  = UIImage(named: "icon-radio-checked") {
                               self!.rdDiscountFood.setImage(image, for: .normal)
                           }
                           if let image  = UIImage(named: "icon-radio-uncheck") {
                               self!.rdDiscountTotalBill.setImage(image, for: .normal)
                           }
                           if let image  = UIImage(named: "icon-radio-uncheck") {
                               self!.rdDiscountDrink.setImage(image, for: .normal)
                           }
                           
                       }).disposed(by: rxbag)
        
        // action btnDiscountDrink
        btnDiscountDrink.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           dLog("action btnDiscountDrink")
                           self!.discount_type = 3
                           if let image  = UIImage(named: "icon-radio-checked") {
                               self!.rdDiscountDrink.setImage(image, for: .normal)
                           }
                           if let image  = UIImage(named: "icon-radio-uncheck") {
                               self!.rdDiscountTotalBill.setImage(image, for: .normal)
                           }
                           if let image  = UIImage(named: "icon-radio-uncheck") {
                               self!.rdDiscountFood.setImage(image, for: .normal)
                           }
                       }).disposed(by: rxbag)
        
        
        
    }
  
    

    @IBAction func actionChooseReason(_ sender: Any) {
        self.showChooseReasonDiscount()
    }
    
    @IBAction func actionDiscount(_ sender: Any) {
        viewModel.note.accept(textfield_discount_reason.text ?? "")
        let discount_percent = textfield_discount_percent.text ?? "0"
        if(discount_percent.isEmpty){
            return
        }
        if(Int(discount_percent)! > 0 && Int(discount_percent)! <= 100){
            viewModel.discount_percent.accept(Int(discount_percent)!)
            viewModel.discount_type.accept(self.discount_type)
            viewModel.order_id.accept(self.order_id)
            viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
            
            self.applyDiscount()
        }else{
//            Toast.show(message: "Vui lòng nhập số % phải lớn hơn 0 và bé hơn 100", controller: self)
            JonAlert.showError(message: "Vui lòng nhập số % phải lớn hơn 0 và bé hơn 100",duration: 2.0)
        }
        
       
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }

}
