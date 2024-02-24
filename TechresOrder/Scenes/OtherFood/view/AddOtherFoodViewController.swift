//
//  AddOtherFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 17/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import RxRelay
import JonAlert
class AddOtherFoodViewController: BaseViewController {
     var viewModel = AddOtherFoodViewModel()
    var router = AddOtherFoodRouter()
    
    @IBOutlet weak var lbl_number_character_note: UILabel!

    
    var order_id = 0
    var branch_id = ManageCacheObject.getCurrentBranch().id
    var table_name = ""
    var kitchen_names = [String]()
    
    var vat_names = [String]()
    var kitchense = [Kitchen]()
    var vats = [Vat]()
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var textfield_food_name: UITextField!
    @IBOutlet weak var textfield_food_price: UITextField!
    @IBOutlet weak var textfield_node: UITextView!
    @IBOutlet weak var btnChooseChef: UIButton!
    @IBOutlet weak var lbl_chef: UILabel!

    @IBOutlet weak var root_view_header: UIView!
    @IBOutlet weak var constraint_top_food_name: NSLayoutConstraint!
    
    
    

    @IBOutlet weak var checkAllowPrint: UIButton!
    
//    @IBOutlet weak var radioCheck: UIButton!

    @IBOutlet weak var btnSub: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnchecked : UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnInputAmount: UIButton!
    @IBOutlet weak var btnInputQuantity: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var view_chefbar: UIView!
    @IBOutlet weak var view_print_chef_bar: UIView!
    
    @IBOutlet weak var view_btn_save: UIView!
    
    @IBOutlet weak var constraint_height_view_dropdown: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Utils.isHideAllView(isHide: true, view: view_chefbar)
        Utils.isHideAllView(isHide: true, view: view_print_chef_bar)
        
        textfield_node.withDoneButton()
        
        viewModel.bind(view: self, router: router)
        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE){
            constraint_top_food_name.constant = 100
            Utils.isHideAllView(isHide: false, view: root_view_header)
        }else{
            constraint_top_food_name.constant = 0
            Utils.isHideAllView(isHide: true, view: root_view_header)
        }
        
        //bind value of textfield to variable of viewmodel
        _ = textfield_food_name.rx.text.map { $0! }.bind(to: viewModel.food_name)

//        _ = lbl_quantity.rx.text.map { $0 }.bind(to: viewModel.food_quantity)
        
        
//        _ = lbl_quantity.rx.text.map { $0 ?? "" }.bind(to: viewModel.food_quantity)

//        _ = viewModel.isValid.subscribe({ [weak self] isValid in
//           dLog(isValid)
//           guard let strongSelf = self, let isValid = isValid.element else { return }
//           strongSelf.btnSave.isEnabled = isValid
//           strongSelf.view_btn_save.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
//           strongSelf.btnSave.tintColor = ColorUtils.white()
//            strongSelf.btnSave.titleLabel?.textColor = isValid ? ColorUtils.white() : ColorUtils.grayColor()
        
        // kiểm tra trường tên món ăn đã nhập chưa
        _ = viewModel.isValidFoodName.subscribe({ [weak self] isValid in
           dLog(isValid)
           guard let strongSelf = self, let isValid = isValid.element else { return }
           strongSelf.btnSave.isEnabled = isValid
            strongSelf.view_btn_save.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
 
       })
        
//        check GPBH 1 opt 1 or GPBH 3
//        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_THREE){
            if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE){
                Utils.isHideAllView(isHide: true, view: view_chefbar)
                Utils.isHideAllView(isHide: true, view: view_print_chef_bar)
                constraint_height_view_dropdown.constant = 200
            }else{
                Utils.isHideAllView(isHide: false, view: view_chefbar)
                Utils.isHideAllView(isHide: false, view: view_print_chef_bar)
                constraint_height_view_dropdown.constant = 300
            }
//        }
        
        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_THREE){
            Utils.isHideAllView(isHide: true, view: view_print_chef_bar)
        }

        _ = textfield_node.rx.text.map { $0 ?? "" }.bind(to: viewModel.food_description)

        
        textfield_node.rx.text
               .subscribe(onNext: {
                   if $0!.count > 255 {
                       self.lbl_number_character_note.textColor = ColorUtils.red_color()
                       self.textfield_node.text = String(self.textfield_node.text!.prefix(255))
                       return
                   } else {
                       self.lbl_number_character_note.textColor = ColorUtils.grey()
                       self.lbl_number_character_note.text = String(format: "%d/%d", $0!.count, 255)
                   }
                  
               })
               .disposed(by: rxbag)
        
        
//        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE){
//            Utils.isHideAllView(isHide: true, view: view_vat)
//        }
        
//        if(ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_THREE){
//            Utils.isHideAllView(isHide: false, view: view_print_chef_bar)
//        }else{
//            Utils.isHideAllView(isHide: true, view: view_print_chef_bar)
//        }
        //Call API Get Data
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.brand_id.accept(ManageCacheObject.getCurrentBrand().id)
        viewModel.status.accept(ACTIVE)
        
        getKitchenes()
//        getVAT()
        

        
        btnAdd.rx.tap.asDriver()
               .drive(onNext: { [weak self] in
                  
                  dLog("btnAdd")
                   if let number = Float(self!.lbl_quantity.text!){
                       var quantity = number
                     
                       quantity += 1
                       quantity = quantity >= 1000 ? 1000 : quantity
                       self!.lbl_quantity.text = String(format: "%.0f", quantity)
                       self!.viewModel.food_quantity.accept(quantity)
                   }
                  
                   
               }).disposed(by: rxbag)
        
        btnSub.rx.tap.asDriver()
               .drive(onNext: { [weak self] in
                  
                   if let number = Float(self!.lbl_quantity.text!){
                       var quantity = number
                     
                       
                       quantity -= 1
                       quantity = quantity <= 1 ? 1 : quantity
                       self!.lbl_quantity.text = String(format: "%.0f", quantity)
                       self!.viewModel.food_quantity.accept(quantity)
                   }
                  
                   
               }).disposed(by: rxbag)
        
        checkAllowPrint.rx.tap.asDriver()
               .drive(onNext: { [weak self] in
                  
                   if(self!.viewModel.check_allow_print.value == 0){
                       self!.viewModel.check_allow_print.accept(1)
                       self!.btnchecked.setImage(UIImage(named: "check_2"), for: .normal)
                   }else{
                       self!.viewModel.check_allow_print.accept(0)
                       self!.btnchecked.setImage(UIImage(named: "un_check_2"), for: .normal)
                   }
                   
               }).disposed(by: rxbag)
        
        btnchecked.rx.tap.asDriver()
               .drive(onNext: { [weak self] in
                  
                   if(self!.viewModel.check_allow_print.value == 0){
                       self!.viewModel.check_allow_print.accept(1)
                       self!.btnchecked.setImage(UIImage(named: "check_2"), for: .normal)
                   }else{
                       self!.viewModel.check_allow_print.accept(0)
                       self!.btnchecked.setImage(UIImage(named: "un_check_2"), for: .normal)
                   }
                   
               }).disposed(by: rxbag)
        
        
        btnInputAmount.rx.tap.asDriver()
               .drive(onNext: { [weak self] in
                   self?.presentModalCaculatorInputMoneyViewController()
                   
               }).disposed(by: rxbag)
        btnInputQuantity.rx.tap.asDriver()
               .drive(onNext: { [weak self] in
                   self?.presentModalInputQuantityViewController()
                   
               }).disposed(by: rxbag)
        
        
        btnChooseChef.rx.tap.asDriver()
               .drive(onNext: { [weak self] in
                   self!.showChooseChef()
               }).disposed(by: rxbag)
        
//        btnChooseVAT.rx.tap.asDriver()
//               .drive(onNext: { [weak self] in
//                   self!.showChooseVAT()
//               }).disposed(by: rxbag)
       
        btnBack.rx.tap.asDriver()
               .drive(onNext: { [weak self] in
                   self!.viewModel.makePopViewController()
               }).disposed(by: rxbag)
        
    }
    
    
    @IBAction func actionCreateFood(_ sender: Any) {
        if(viewModel.food_price.value > 0){
            var foodRequest  = OtherFoodRequest.init()
            viewModel.order_id.accept(self.order_id)
            viewModel.food_name.accept(textfield_food_name.text!)
            foodRequest.food_name = viewModel.food_name.value
            foodRequest.quantity = viewModel.food_quantity.value
            foodRequest.restaurant_kitchen_place_id = viewModel.kitchen_id.value
            foodRequest.restaurant_vat_config_id = viewModel.vat_id.value
            foodRequest.price = viewModel.food_price.value
            foodRequest.note = viewModel.food_description.value
            foodRequest.is_allow_print = viewModel.check_allow_print.value
            viewModel.dataOtherFoodRequest.accept(foodRequest)
            self.addOtherFoodsToOrder()
        }else{
//            Toast.show(message: "Vui lòng nhập giá món ăn trước khi thêm.", controller: self)
            JonAlert.showError(message: "Vui lòng nhập giá món ăn trước khi thêm!", duration: 2.0)
        }
        
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    
}
extension AddOtherFoodViewController{
    func getKitchenes(){
        viewModel.getKitchenes().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get kitchen Success...")
                if let kitchenes  = Mapper<Kitchen>().mapArray(JSONObject: response.data){
                    self.kitchense = kitchenes.filter({$0.type == CHEF}) // Chỉ lấy loại bếp nấu
                    dLog(kitchenes.toJSON())
                        for i in 0..<self.kitchense.count {
                            self.kitchen_names.append(self.kitchense[i].name)
                        }
                        if self.kitchense.count > 0 {
                            self.viewModel.kitchen_id.accept(self.kitchense[0].id)
                            self.lbl_chef.text = self.kitchense[0].name
                        }
                }

            }
        }).disposed(by: rxbag)
        
    }
    
//    func getVAT(){
//        viewModel.getVAT().subscribe(onNext: { (response) in
//            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                dLog("Get VAT Success...")
//                if let vats  = Mapper<Vat>().mapArray(JSONObject: response.data){
//                    dLog(vats.toJSON())
//                    self.vats = vats
//                    for i in 0..<vats.count {
//                        self.vat_names.append(vats[i].vat_config_name)
//                    }
//                    if vats.count > 0 {
////                        self.lbl_vat.text = vats[0].vat_config_name
//                        self.viewModel.vat_id.accept(vats[0].id)
//                    }
//                }
//
//            }
//        }).disposed(by: rxbag)
//
//    }
    private func addOtherFoodsToOrder(){
        viewModel.addOtherFoods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog(response.message)
//                Toast.show(message: "Thêm món thành công...", controller: self)
                JonAlert.showSuccess(message: "Thêm món thành công...",duration: 2.0)
                self.viewModel.makePopViewController()
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
//                Toast.show(message: response.message ?? "Có lỗi trong quá trình thêm món", controller: self)
            }
         
        }).disposed(by: rxbag)
    }
    
}
