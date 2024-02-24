//
//  ExtraFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 21/01/2023.
//

import UIKit
import JonAlert
class ExtraFoodViewController: BaseViewController {
    var viewModel = ExtraFoodViewModel()
   var router = ExtraFoodRouter()
    @IBOutlet weak var lbl_number_character_note: UILabel!

    @IBOutlet weak var lbl_extra_charge: UITextField!
    var extra_charges_names = [String]()
    var extra_charges = [ExtraCharge]()
    var order_id = 0
    
    @IBOutlet weak var lbl_extra_charge_amount: UITextField!
    
    @IBOutlet weak var textview_description: UITextView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    @IBOutlet weak var btnChoosExtraCharger: UIButton!
    
    @IBOutlet weak var btnChooseMoney: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textview_description.withDoneButton()


        viewModel.bind(view: self, router: router)
        
        
        viewModel.restaurant_brand_id.accept(ManageCacheObject.getCurrentUser().restaurant_brand_id)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.status.accept(1)
        viewModel.order_id.accept(self.order_id)
        
        
        //bind value of textfield to variable of viewmodel
        _ = lbl_extra_charge.rx.text.map { $0! }.bind(to: viewModel.food_name)
        _ = textview_description.rx.text.map { $0! }.bind(to: viewModel.food_note)
        
        _ = viewModel.isValid.subscribe({ [weak self] isValid in
           dLog(isValid)
           guard let strongSelf = self, let isValid = isValid.element else { return }
           strongSelf.btnSubmit.isEnabled = isValid
//           strongSelf.btnSubmit.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
//           strongSelf.btnSubmit.tintColor = ColorUtils.white()
//            strongSelf.btnSubmit.titleLabel?.textColor = isValid ? ColorUtils.white() : ColorUtils.grayColor()
       })
        
        
        btnChoosExtraCharger.rx.tap.asDriver()
               .drive(onNext: { [weak self] in
                   self!.showChooseExtraCharges()
               }).disposed(by: rxbag)
        
        btnChooseMoney.rx.tap.asDriver()
               .drive(onNext: { [weak self] in
                   self?.presentModalCaculatorInputMoneyViewController()
               }).disposed(by: rxbag)
        
        btnSubmit.rx.tap.asDriver()
               .drive(onNext: { [weak self] in
                   self!.viewModel.name.accept(self?.lbl_extra_charge.text ?? "")
                   if((self?.viewModel.extra_charge_id.value)! == 0){
                       if((self?.viewModel.food_note.value.count)! < 2 || (self?.viewModel.food_note.value.count)! > 50){
//                           Toast.show(message: "Vui lòng nhập mô tả từ 2 đến 50 ký tự", controller: self!)
                           JonAlert.showError(message: "Vui lòng nhập mô tả từ 2 đến 50 ký tự",duration: 2.0)
                           return
                       }
                   }
                   self!.viewModel.note.accept(self!.textview_description.text ?? "")
                   self!.viewModel.quantity.accept(1)
                   // Chỉnh 1000 - > 100
                   if((self?.viewModel.price.value)! >= 100 && (self?.viewModel.price.value)! <= 500000000){
                       self?.addExtraCharge()
                   }else{
//                       Toast.show(message: "Vui lòng nhập số tiền >= 1.000 và <= 500000000", controller: self!)
                       JonAlert.showError(message: "Vui lòng nhập số tiền >= 1.000 và <= 500000000",duration: 2.0)
                   }
                  
               }).disposed(by: rxbag)
        
        
        btnCancel.rx.tap.asDriver()
               .drive(onNext: { [weak self] in
                   self?.viewModel.makePopViewController()
               }).disposed(by: rxbag)
        
        
        textview_description.rx.text
               .subscribe(onNext: {
                   if $0!.count > 255 {
                       self.lbl_number_character_note.textColor = ColorUtils.red_color()
                       self.textview_description.text = String($0?.prefix(255) ?? "")// chặn ký tự nhập nếu quá 255 ký tự
                       return
                   } else {
                       self.lbl_number_character_note.textColor = ColorUtils.grey()
                       self.lbl_number_character_note.text = String(format: "%d/%d", $0!.count, 255)
                   }
                  
               })
               .disposed(by: rxbag)
        
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getExtraCharges()
    }


}
