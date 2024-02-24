//
//  CreateFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import Photos
import JonAlert

class CreateFoodViewController: BaseViewController {
    var viewModel = CreateFoodViewModel()
    var router = CreateFoodRouter()
    
    var delegate:TechresDelegate?
    
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var avatar_food: UIImageView!
    
    @IBOutlet weak var btnChooseImage: UIButton!
    
    @IBOutlet weak var textfield_name: UITextField!
    
    @IBOutlet weak var textfield_price: UITextField!
    
    @IBOutlet weak var btnCategory: UIButton!
    
    @IBOutlet weak var btnUnit: UIButton!
    
    @IBOutlet weak var btnPriceByTime: UIButton!
    
    @IBOutlet weak var btnCheckPriceByTime: UIButton!
    @IBOutlet weak var btnChooseFromDate: UIButton!

    @IBOutlet weak var lbl_from: UILabel!
    @IBOutlet weak var btnChooseToDate: UIButton!
    @IBOutlet weak var btnChooseTemPrice: UIButton!
    @IBOutlet weak var radioPrice: UIButton!
    
    @IBOutlet weak var radioPriceIncrease: UIButton!
    @IBOutlet weak var radioPriceDescrease: UIButton!
    
    @IBOutlet weak var radioPercent: UIButton!
    
    @IBOutlet weak var btnChoosePercent: UIButton!
    @IBOutlet weak var btnChoosePriceByMoney: UIButton!

    
    @IBOutlet weak var lbl_to: UILabel!
    @IBOutlet weak var btnCheckPrintChef: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var btnSelectChefNeedPrint: UIButton!
    @IBOutlet weak var btnChooseChef: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnChooseMoney: UIButton!
    
    @IBOutlet weak var textfield_price_by_time: UITextField!
    @IBOutlet weak var textfield_percent_by_time: UITextField!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var checkStatus: UIButton!
    
    @IBOutlet weak var constraint_height_scroll_edit: NSLayoutConstraint!
    
    var kitchen_names = [String]()
    var kitchenses = [Kitchen]()
    var categories = [Category]()
    var units = [Unit]()
    var vats = [Vat]()
    var vat_names = [String]()
    
    @IBOutlet weak var constraint_height_printer_config: NSLayoutConstraint!
    
    @IBOutlet weak var constraint_height_price_config: NSLayoutConstraint!
    
    // define view giá thời vụ
    
    @IBOutlet weak var view_from: UIView!
    
    @IBOutlet weak var view_to: UIView!
    
    @IBOutlet weak var view_price: UIView!
    
    @IBOutlet weak var view_percent: UIView!
    
    @IBOutlet weak var view_printer: UIView!
    
    @IBOutlet weak var view_price_type: UIView!
    
    @IBOutlet weak var root_view_print_chefbar: UIView!
   
    @IBOutlet weak var view_vat: UIView!
    @IBOutlet weak var constraint_height_vat_config: NSLayoutConstraint!
    
    
    @IBOutlet weak var constraint_height_vat_margin_config: NSLayoutConstraint!
    
    @IBOutlet weak var radioCheckboxVAT: UIButton!
    
    @IBOutlet weak var btnCheckVAT: UIButton!
    
    @IBOutlet weak var btnSelectVAT: UIButton!
    @IBOutlet weak var lbl_error_name: UILabel!
    
    @IBOutlet weak var contraint_view_btn_create_update: NSLayoutConstraint!
    @IBOutlet weak var lbl_btn_creeate_update: UILabel!
    var chooseType = 0
    
    var isPrinter = 0
    var isPriceCheck = 0
    var isFrom = 0 // check if datepicker current choose for from else for To date 
    var picker: DateTimePicker?
    var isChoosePriceByTime = 0 // 0 : giá thời vụ tăng theo số tiền| 1 Tăng theo %
    
    var isVATCheck = 0 // check vat
    var isStatusCheck = 0 // check status
    var imagecover = [UIImage]()
    var resources_path = [URL]()
    var selectedAssets = [PHAsset]()
    
    var food = Food.init()
    var is_partime_price = 0
    
    var isIncrease = 0
    
    //giá trị textfelid
    var text_value_price_tempory = ""
    var text_value_percent_tempory = ""
    var isPressed = true
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.constraint_height_scroll_edit.constant = 550
        
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
         
        _ = textfield_percent_by_time.rx.text.map {$0 ?? ""}.bind(to: viewModel.text_percent_tempory)

        _ = textfield_name.rx.text.map{String($0!.prefix(50))}.map({ [self](str) -> CreateFoodRequest in
                    var cloneFoodRequest = self.viewModel.foodRequest.value
                        cloneFoodRequest.name = str
                    self.textfield_name.text = str
                    self.lbl_error_name.isHidden = true
                    if textfield_name.isEditing{
                        if (str.count < 2) {
                            self.lbl_error_name.text = "Tên món ăn từ 2 đến 50 ký tự"
                            self.lbl_error_name.isHidden = false
                        }
                    }
                    
                    return cloneFoodRequest
        }).bind(to: viewModel.foodRequest)

        
        Utils.isHideAllView(isHide: true, view: self.view_from)
        Utils.isHideAllView(isHide: true, view: self.view_to)
        Utils.isHideAllView(isHide: true, view: self.view_price)
        Utils.isHideAllView(isHide: true, view: self.view_percent)
        Utils.isHideAllView(isHide: true, view: self.view_vat)
        Utils.isHideAllView(isHide: true, view: self.view_printer)
        Utils.isHideAllView(isHide: true, view: self.view_price_type)
        
        self.isPriceCheck = DEACTIVE
        self.constraint_height_price_config.constant = 60
        
        self.isVATCheck = DEACTIVE
        isStatusCheck = DEACTIVE
        self.constraint_height_vat_config.constant = 60
        
        self.isPriceCheck = DEACTIVE
        self.constraint_height_printer_config.constant = 60
       
        lbl_header.text = "THÊM MÓN ĂN"
        lbl_from.text = Date().dateTimeToString()
        lbl_to.text = Date().dateTimeToString()
        
        isStatusCheck = ACTIVE
        self.checkStatus.setImage(UIImage(named: "check_2"), for: .normal)
        self.btnStatus.isUserInteractionEnabled = false
        self.contraint_view_btn_create_update.constant = 75
        self.lbl_btn_creeate_update.text = "THÊM"

        if(food.id > 0){// update food

            self.btnStatus.isUserInteractionEnabled = true
            self.contraint_view_btn_create_update.constant = 110
            self.lbl_btn_creeate_update.text = "CẬP NHẬT"
            lbl_from.text = food.temporary_price_from_date
            lbl_to.text = food.temporary_price_to_date
            
//            var foodRequest = viewModel.foodRequest.value
//            foodRequest.temporary_price = Float(food.temporary_price)
//            foodRequest.temporary_price_from_date = food.temporary_price_from_date
//            foodRequest.temporary_price_to_date = food.temporary_price_to_date
//            foodRequest.name = food.name
//            foodRequest.price = Float(food.price)
//            foodRequest.status = food.status
//            foodRequest.restaurant_kitchen_place_id = food.restaurant_kitchen_place_id
//            foodRequest.id = food.id
//            foodRequest.temporary_price = Float(food.temporary_price)
//            foodRequest.temporary_percent = Float(food.temporary_percent)
//
//            viewModel.foodRequest.accept(foodRequest)
//
            lbl_header.text = "CẬP NHẬT MÓN ĂN"
            // Check printer config
            if(food.is_allow_print == ACTIVE){
                self.isPrinter = ACTIVE
                self.btnCheckPrintChef.setImage(UIImage(named: "check_2"), for: .normal)
                self.constraint_height_printer_config.constant = 120
                Utils.isHideAllView(isHide: false, view: self.view_printer)
            }else{
                self.isPrinter = DEACTIVE
                self.btnCheckPrintChef.setImage(UIImage(named: "un_check_2"), for: .normal)
                self.constraint_height_printer_config.constant = 60
                Utils.isHideAllView(isHide: true, view: self.view_printer)
            }
            if(food.status == ACTIVE){
                isStatusCheck = ACTIVE
                self.checkStatus.setImage(UIImage(named: "check_2"), for: .normal)
            }else{
                isStatusCheck = DEACTIVE
                self.checkStatus.setImage(UIImage(named: "un_check_2"), for: .normal)
            }
            
            if(food.temporary_percent > 0){
                checkTemPercent()
            }else{
                checkTemPrice()
            }
            
            var foodRequest = CreateFoodRequest.init()
            foodRequest.id = food.id
            foodRequest.category_id = food.category_id
            foodRequest.category_type = food.category_type
            foodRequest.restaurant_kitchen_place_id = food.restaurant_kitchen_place_id
            foodRequest.unit = food.unit_type
            foodRequest.temporary_price = Float(food.temporary_price)
            foodRequest.temporary_percent = Float(food.temporary_percent)
            foodRequest.price = Float(food.price)
            foodRequest.avatar = food.avatar
            foodRequest.code = food.code
            foodRequest.is_allow_print = isPrinter
            foodRequest.temporary_price_from_date = food.temporary_price_from_date
            foodRequest.temporary_price_to_date = food.temporary_price_to_date
            viewModel.foodRequest.accept(foodRequest)
            
            textfield_name.text = food.name
            textfield_price.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(food.price))
            
            avatar_food.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: food.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))

            
            // Check giá thời vụ
            if(food.temporary_price == 0 && food.temporary_percent == 0){
                lbl_from.text = Utils.getFullCurrentDate()
                lbl_to.text = Utils.getFullCurrentDate()
                Utils.isHideAllView(isHide: true, view: self.view_from)
                Utils.isHideAllView(isHide: true, view: self.view_to)
                Utils.isHideAllView(isHide: true, view: self.view_price)
                Utils.isHideAllView(isHide: true, view: self.view_percent)
                Utils.isHideAllView(isHide: true, view: self.view_price_type)
                self.isPriceCheck = DEACTIVE
                self.btnCheckPriceByTime.setImage(UIImage(named: "un_check_2"), for: .normal)
                self.constraint_height_price_config.constant = 60
                
            }else{
//                self.isPriceCheck = ACTIVE
//                self.btnCheckPriceByTime.setImage(UIImage(named: "check_2"), for: .normal)
//                self.constraint_height_price_config.constant = 350
//                Utils.isHideAllView(isHide: false, view: self.view_from)
//                Utils.isHideAllView(isHide: false, view: self.view_to)
//                Utils.isHideAllView(isHide: false, view: self.view_price)
//                Utils.isHideAllView(isHide: false, view: self.view_percent)
//                Utils.isHideAllView(isHide: false, view: self.view_price_type)
//                textfield_price_by_time.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(food.temporary_price))
//                textfield_percent_by_time.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(food.temporary_percent))
                if (food.temporary_price > 0){
                    checkIncreasePrice()
                }else if (food.temporary_price < 0) {
                   
                    checkPromotionPrice()
                    
                  
                }
            }
            if (food.temporary_price_from_date != "" && food.temporary_price_to_date != ""){
                lbl_from.text = food.temporary_price_from_date
                lbl_to.text = food.temporary_price_to_date
                if(food.temporary_percent != 0){
                    textfield_price_by_time.text = "0"
                }else{
                    textfield_price_by_time.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(food.temporary_price)).replacingOccurrences(of: "-", with: "")
                }
                self.isPriceCheck = ACTIVE
                self.btnCheckPriceByTime.setImage(UIImage(named: "check_2"), for: .normal)
                self.constraint_height_price_config.constant = 350
                Utils.isHideAllView(isHide: false, view: self.view_from)
                Utils.isHideAllView(isHide: false, view: self.view_to)
                Utils.isHideAllView(isHide: false, view: self.view_price)
                Utils.isHideAllView(isHide: false, view: self.view_percent)
                Utils.isHideAllView(isHide: false, view: (self.view_price_type)!)
                self.constraint_height_scroll_edit.constant = 830
//                UIView.animate(withDuration: 0.5) {
//                    self.view.layoutIfNeeded()
//                }
            }
            if(food.restaurant_vat_config_id > 0 ){
                radioCheckboxVAT.setImage(UIImage(named: "check_2"), for: .normal)
                Utils.isHideAllView(isHide: false, view: view_vat)
                isVATCheck = ACTIVE
                constraint_height_vat_config.constant = 120
                
            }else{
                isVATCheck = DEACTIVE
                radioCheckboxVAT.setImage(UIImage(named: "un_check_2"), for: .normal)
                constraint_height_vat_config.constant = 60
            }
            if(food.restaurant_kitchen_place_id > 0){
                isPrinter = ACTIVE // thay active thanh Deactive
                Utils.isHideAllView(isHide: false, view: view_printer)
                constraint_height_printer_config.constant = 120
                btnCheckPrintChef.setImage(UIImage(named: "check_2"), for: .normal)
            }
            //Nếu là GPBH1 Option 1
            if (ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE){
                isPrinter = DEACTIVE
            }
        

        }
        
        
        /*KIỂM TRA trường giá trị phần %
         */
        _ = viewModel.isValidTextPercentTempory.subscribe({ [weak self] isValid in
            dLog(isValid)
            guard let strongSelf = self, let isValid = isValid.element else {return}
            
            /*
              step1: cắt hết tất cả ký tự chỉ lấy đúng 3 ký tự
             step2: nếu lớn hơn hoặc bằng 3 ký tự thì bắt đầu kiểm lấy đúng 3 ký tự
             
             */
            if let numberpercent = strongSelf.textfield_percent_by_time.text, numberpercent.count > 0 {//step1
                let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: numberpercent)
                if !allowedCharacters.isSuperset(of: characterSet) {
                    strongSelf.textfield_percent_by_time.text = String(strongSelf.textfield_percent_by_time.text!.prefix(strongSelf.textfield_percent_by_time.text!.count - 1))
            }
            if strongSelf.textfield_percent_by_time.text!.count >= 3 {//step2
                if (Utils.validatePercentage(percent: strongSelf.textfield_percent_by_time.text!)){
                    strongSelf.textfield_percent_by_time.text = String(strongSelf.textfield_percent_by_time.text!.prefix(3))
                    
                }else{
                    strongSelf.textfield_percent_by_time.text = "100"
                    strongSelf.textfield_percent_by_time.text = String(strongSelf.textfield_percent_by_time.text!.prefix(3))
//                    Toast.show(message: "phần trăm phải nhỏ hơn hoặc bằng 100", controller: self!)
                    JonAlert.showError(message: "Phần trăm phải nhỏ hơn hoặc bằng 100", duration: 2.0)
                    return
                    
                }
              
            }
         }
        })
        
        btnCategory.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.showChooseCategory()
                       }).disposed(by: rxbag)
        
        btnChooseTemPrice.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.is_partime_price = ACTIVE
                           self?.presentModalCaculatorInputMoneyViewController(btnType:"CHOOSE_TEM_PRICE")
                       }).disposed(by: rxbag)
        
        btnUnit.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           dLog("unit")
                           self?.showChooseUnit()
                       }).disposed(by: rxbag)
        btnPriceByTime.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           if(self!.isPriceCheck == DEACTIVE){
                               self?.checkTemPrice()
                               self?.checkIncreasePrice()
                               self!.isPriceCheck = ACTIVE
                               self?.btnCheckPriceByTime.setImage(UIImage(named: "check_2"), for: .normal)
                               self!.constraint_height_price_config.constant = 350
                               Utils.isHideAllView(isHide: false, view: self!.view_from)
                               Utils.isHideAllView(isHide: false, view: self!.view_to)
                               Utils.isHideAllView(isHide: false, view: self!.view_price)
                               Utils.isHideAllView(isHide: false, view: self!.view_percent)
                               Utils.isHideAllView(isHide: false, view: (self?.view_price_type)!)

                               if (self?.isPriceCheck == ACTIVE){
                                   self?.constraint_height_scroll_edit.constant = 830
                               }
                               if (self?.isPriceCheck == ACTIVE && (self?.isPrinter == ACTIVE || self?.isVATCheck == ACTIVE)){
                                   self?.constraint_height_scroll_edit.constant = 890
                               }
                               if (self?.isPriceCheck == ACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == ACTIVE){
                                   self?.constraint_height_scroll_edit.constant = 950
                               }
                               if ((self?.isPriceCheck == DEACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == ACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == DEACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == DEACTIVE && self?.isVATCheck == ACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == DEACTIVE && self?.isVATCheck == DEACTIVE)){
                                   self?.constraint_height_scroll_edit.constant = 600
                               }
                               UIView.animate(withDuration: 0.5) {
                                   self?.view.layoutIfNeeded()
                               }
                           }else{
                               Utils.isHideAllView(isHide: true, view: self!.view_from)
                               Utils.isHideAllView(isHide: true, view: self!.view_to)
                               Utils.isHideAllView(isHide: true, view: self!.view_price)
                               Utils.isHideAllView(isHide: true, view: self!.view_percent)
                               Utils.isHideAllView(isHide: true, view: self!.view_price_type)
                               self!.isPriceCheck = DEACTIVE
                               self?.btnCheckPriceByTime.setImage(UIImage(named: "un_check_2"), for: .normal)
                               self!.constraint_height_price_config.constant = 60
                               
                               if (self?.isPriceCheck == ACTIVE ){
                                   self?.constraint_height_scroll_edit.constant = 830
                               }
                               if (self?.isPriceCheck == ACTIVE && (self?.isPrinter == ACTIVE || self?.isVATCheck == ACTIVE)){
                                   self?.constraint_height_scroll_edit.constant = 890
                               }
                               if (self?.isPriceCheck == ACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == ACTIVE){
                                   self?.constraint_height_scroll_edit.constant = 950
                               }
                               if ((self?.isPriceCheck == DEACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == ACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == DEACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == DEACTIVE && self?.isVATCheck == ACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == DEACTIVE && self?.isVATCheck == DEACTIVE)){
                                   self?.constraint_height_scroll_edit.constant = 600
                               }
                               UIView.animate(withDuration: 0.5) {
                                   self?.view.layoutIfNeeded()
                               }
                               
                           }
                        
                          
                       }).disposed(by: rxbag)
        btnChooseImage.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.chooseAvatar()
                       }).disposed(by: rxbag)
        
        btnChooseFromDate.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           dLog("btnChooseFromDate")
                           self!.isFrom = ACTIVE

                           self?.chooseDate(isFrom: self!.isFrom)
                       }).disposed(by: rxbag)
        
        btnChooseToDate.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           dLog("btnChooseToDate")
                           self!.isFrom = DEACTIVE
                           self?.chooseDate(isFrom: self!.isFrom)
                       }).disposed(by: rxbag)
        
        radioPrice.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           dLog("radioPrice")
                          //checkTemPrice
                           self?.textfield_price_by_time.text = self?.text_value_price_tempory
                           
                           
                           self?.text_value_percent_tempory = (self?.textfield_percent_by_time.text)!
                          
                           dLog(self!.viewModel.text_tempory_price_by_time.value)
                           self!.textfield_percent_by_time.text = ""
                        
                           self!.checkTemPrice()
                       }).disposed(by: rxbag)
        
        radioPercent.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                            
                           self?.textfield_percent_by_time.text = self?.text_value_percent_tempory
                           
                           self?.text_value_price_tempory = (self?.textfield_price_by_time.text)!
                           
                           self!.textfield_price_by_time.text = ""
                           self!.checkTemPercent()
                       }).disposed(by: rxbag)
        
        radioPriceIncrease.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.checkIncreasePrice()
                       }).disposed(by: rxbag)
        
        radioPriceDescrease.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.checkPromotionPrice()
                       }).disposed(by: rxbag)
        
        btnSelectChefNeedPrint.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.showChefBar()
                       }).disposed(by: rxbag)
        
        btnBack.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
        
        btnCancel.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
        
        btnChooseMoney.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.is_partime_price = DEACTIVE
                           self?.presentModalCaculatorInputMoneyViewController(btnType:"CHOOSE_MONEY")
                       }).disposed(by: rxbag)
        
        btnChooseChef.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           if(self!.isPrinter == DEACTIVE){
                               self!.isPrinter = ACTIVE
                               self?.btnCheckPrintChef.setImage(UIImage(named: "check_2"), for: .normal)
                               self!.constraint_height_printer_config.constant = 120
                               self?.constraint_height_scroll_edit.constant = 890
                               self?.constraint_height_vat_margin_config.constant = 120
                               Utils.isHideAllView(isHide: false, view: self!.view_printer)
                               if (self?.isPriceCheck == ACTIVE){
                                   self?.constraint_height_scroll_edit.constant = 830
                               }
                               if (self?.isPriceCheck == ACTIVE && (self?.isPrinter == ACTIVE || self?.isVATCheck == ACTIVE)){
                                   self?.constraint_height_scroll_edit.constant = 890
                               }
                               if (self?.isPriceCheck == ACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == ACTIVE){
                                   self?.constraint_height_scroll_edit.constant = 950
                               }
                               if ((self?.isPriceCheck == DEACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == ACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == DEACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == DEACTIVE && self?.isVATCheck == ACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == DEACTIVE && self?.isVATCheck == DEACTIVE)){
                                   self?.constraint_height_scroll_edit.constant = 600
                               }
                               UIView.animate(withDuration: 0.5) {
                                   self?.view.layoutIfNeeded()
                               }
                           }else{
                               self!.isPrinter = DEACTIVE
                               self?.btnCheckPrintChef.setImage(UIImage(named: "un_check_2"), for: .normal)
                               self!.constraint_height_printer_config.constant = 60
                               self?.constraint_height_vat_margin_config.constant = 60
                               Utils.isHideAllView(isHide: true, view: self!.view_printer)
                               if (self?.isPriceCheck == ACTIVE ){
                                   self?.constraint_height_scroll_edit.constant = 830
                               }
                               if (self?.isPriceCheck == ACTIVE && (self?.isPrinter == ACTIVE || self?.isVATCheck == ACTIVE)){
                                   self?.constraint_height_scroll_edit.constant = 890
                               }
                               if (self?.isPriceCheck == ACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == ACTIVE){
                                   self?.constraint_height_scroll_edit.constant = 950
                               }
                               if ((self?.isPriceCheck == DEACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == ACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == DEACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == DEACTIVE && self?.isVATCheck == ACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == DEACTIVE && self?.isVATCheck == DEACTIVE)){
                                   self?.constraint_height_scroll_edit.constant = 600
                               }
                               UIView.animate(withDuration: 0.5) {
                                   self?.view.layoutIfNeeded()
                               }
                           }
                       }).disposed(by: rxbag)
        
       
        btnCheckVAT.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           if(self!.isVATCheck == DEACTIVE){
                               self!.isVATCheck = ACTIVE
                               self?.radioCheckboxVAT.setImage(UIImage(named: "check_2"), for: .normal)
                               self!.constraint_height_vat_config.constant = 120
                               Utils.isHideAllView(isHide: false, view: self!.view_vat)
                               if (self?.isPriceCheck == ACTIVE ){
                                   self?.constraint_height_scroll_edit.constant = 830
                               }
                               if (self?.isPriceCheck == ACTIVE && (self?.isPrinter == ACTIVE || self?.isVATCheck == ACTIVE)){
                                   self?.constraint_height_scroll_edit.constant = 890
                               }
                               if (self?.isPriceCheck == ACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == ACTIVE){
                                   self?.constraint_height_scroll_edit.constant = 950
                               }
                               if ((self?.isPriceCheck == DEACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == ACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == DEACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == DEACTIVE && self?.isVATCheck == ACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == DEACTIVE && self?.isVATCheck == DEACTIVE)){
                                   self?.constraint_height_scroll_edit.constant = 600
                               }
                               UIView.animate(withDuration: 0.5) {
                                   self?.view.layoutIfNeeded()
                               }
                           }else{
                               self!.isVATCheck = DEACTIVE
                               self?.radioCheckboxVAT.setImage(UIImage(named: "un_check_2"), for: .normal)
                               self!.constraint_height_vat_config.constant = 60
                               Utils.isHideAllView(isHide: true, view: self!.view_vat)
                               if (self?.isPriceCheck == ACTIVE ){
                                   self?.constraint_height_scroll_edit.constant = 830
                               }
                               if (self?.isPriceCheck == ACTIVE && (self?.isPrinter == ACTIVE || self?.isVATCheck == ACTIVE)){
                                   self?.constraint_height_scroll_edit.constant = 890
                               }
                               if (self?.isPriceCheck == ACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == ACTIVE){
                                   self?.constraint_height_scroll_edit.constant = 950
                               }
                               if ((self?.isPriceCheck == DEACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == ACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == ACTIVE && self?.isVATCheck == DEACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == DEACTIVE && self?.isVATCheck == ACTIVE) || (self?.isPriceCheck == DEACTIVE && self?.isPrinter == DEACTIVE && self?.isVATCheck == DEACTIVE)){
                                   self?.constraint_height_scroll_edit.constant = 600
                               }
                               UIView.animate(withDuration: 0.5) {
                                   self?.view.layoutIfNeeded()
                               }
                           }
                       }).disposed(by: rxbag)
        
        btnSelectVAT.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.showChooseVAT()
                       }).disposed(by: rxbag)
        
        btnCreate.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           
                           for i in self!.textfield_name.text!{
                               if Utils.ischaracter(string: String(i)){
//                                   Toast.show(message: "Tên món ăn không được nhập ký tự đặc biệt.", controller: self!)
                                   JonAlert.showError(message: "Tên món ăn không được nhập ký tự đặc biệt!", duration: 2.0)
                                   return
                               }
                           }
                           if((self?.textfield_name.text!.count)! < 2 || (self?.textfield_name.text!.count)! > 50){
//                               Toast.show(message: "Tên món ăn tối thiểu là 2 và tối đa là 50", controller: self!)
                               JonAlert.showError(message: "Tên món ăn tối thiểu là 2 và tối đa là 50", duration: 2.0)
                               return
                           }
                           var foodRequest = self?.viewModel.foodRequest.value
                           foodRequest?.name =  self?.textfield_name.text ?? ""
                          
                                    
                           /*
                                    step1: kiểm tra có giá thời vụ và kiểm tra giá có ACTIVE hay ko
                                    
                                */
                           if self!.isChoosePriceByTime == ACTIVE && self!.isPriceCheck == ACTIVE {//step1
                               if self?.isIncrease == ACTIVE {
                                   if let temporay = self?.textfield_price_by_time.text?.trim().replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "-", with: ""){
                                       let temporary_price = Int(temporay.count > 0 ? temporay : "0")
                                       foodRequest?.temporary_price = Float(temporary_price!)
                                       self?.textfield_percent_by_time.text = ""
                                       foodRequest?.temporary_percent = 0 // Giảm giá thì trường giá trị phần trăm bằng 0
                                       if self!.isValidCheckPriceFoodwithPriceTempory(price_tempory: temporary_price!)
                                     {
                                           JonAlert.showError(message: "Giá thời vụ tối thiểu là 100", duration: 2.0)
                                         return
                                     }
                                       
                                   }
                                   
                               }else if self?.isIncrease == DEACTIVE {
                                   if let temporay = self?.textfield_price_by_time.text?.trim().replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "-", with: ""){
                                       let temporary_price = Int(temporay.count > 0 ? temporay : "0")
                                       foodRequest?.temporary_price = Float(temporary_price!) * -1
                                       self?.textfield_percent_by_time.text = ""
                                       foodRequest?.temporary_percent = 0 // Giảm giá thì trường giá trị phần trăm bằng 0
                                   }
                               }
                             if  self!.isCheckdatetimeValue()
                               {
                                 if ((self?.food.id)! > 0){
                                 }else{
                                     JonAlert.showError(message: "Ngày giờ kết thúc lớn hơn ngày giờ bắt đầu", duration: 2.0)
                                     return
                                 }
                                 
                             }
                           }else if self?.isChoosePriceByTime == DEACTIVE && self!.isPriceCheck == ACTIVE {
                               if let temporay_percent = self?.textfield_percent_by_time.text?.trim(){
                                   let percent = Int(temporay_percent.count > 0 ? temporay_percent : "0")
                                   foodRequest?.temporary_percent = Float(percent!)
                                   self?.textfield_price_by_time.text = ""
                               }
                               if  self!.isCheckdatetimeValue()
                                 {
                                   JonAlert.showError(message: "Ngày thời gian kết thúc lớn hơn ngày hiện tại", duration: 2.0)
                                   return
                               }
                           }
                           //=====================================================================
                          
                           
                           if let price_text = self?.textfield_price.text?.trim().replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "-", with: ""){
                               let price = Int(price_text.count > 0 ? price_text : "0")
                               foodRequest?.price = Float(price!)
                           }
                          
                          
                           foodRequest?.is_allow_print = self!.isPrinter
                             if(self?.isVATCheck == ACTIVE){
                                 foodRequest?.restaurant_vat_config_id = (self?.viewModel.vat_id.value)!
                             }else{
                                 foodRequest?.restaurant_vat_config_id = 0
                             }
                           if (self?.isPriceCheck == DEACTIVE){
                               foodRequest?.temporary_price = 0
                               foodRequest?.temporary_price_from_date = ""
                               foodRequest?.temporary_price_to_date = ""
                           }
                           if((self?.food.id)! > 0){ // update food
                               foodRequest?.status = self!.isStatusCheck
                               self?.viewModel.foodRequest.accept(foodRequest!)
                               if((self?.viewModel.medias.value.count)! > 0){
                                   self!.getGenerateFile()
                               }else{
                                   if(self!.isPressed){
                                       if(foodRequest?.temporary_price_to_date != self!.food.temporary_price_to_date){

                                           if (self!.isCheckFromDate()) {
                                               JonAlert.showError(message: "Ngày thời gian bắt đầu phải lớn hơn hoặc bằng thời gian hiện tại.", duration: 2.0)
                                               return
                                           }else if (self!.isCheckToDate()){
                                               JonAlert.showError(message: "Ngày thời gian kết thúc phải lớn hơn ngày thời gian bắt đầu.", duration: 2.0)
                                               return
                                           }else{
                                               self?.isPressed = false
                                               self?.updateFood()
                                               return
                                           }
                                       }
                                           self?.isPressed = false
                                           self?.updateFood()
                                   }
                               }
                           }else{// create food
                               foodRequest?.status = ACTIVE
                               self?.viewModel.foodRequest.accept(foodRequest!)
                               if((self?.viewModel.medias.value.count)! > 0){
                                   self!.getGenerateFile()
                               }else{
                                   self?.createFood()
                               }
                           }
                           
                           
                           
                       }).disposed(by: rxbag)
        
        
        btnStatus.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           if(self!.isStatusCheck == DEACTIVE){
                               self!.isStatusCheck = ACTIVE
                               self?.checkStatus.setImage(UIImage(named: "check_2"), for: .normal)
                               UIView.animate(withDuration: 0.5) {
                                   self?.view.layoutIfNeeded()
                               }
                           }else{
                               self!.isStatusCheck = DEACTIVE
                               self?.checkStatus.setImage(UIImage(named: "un_check_2"), for: .normal)
                               UIView.animate(withDuration: 0.5) {
                                   self?.view.layoutIfNeeded()
                               }
                           }
                       }).disposed(by: rxbag)
        
       
            
        
        
    }
    
    func checkTemPrice(){
       
        self.isChoosePriceByTime = ACTIVE
        self.radioPrice.setImage(UIImage(named: "icon-radio-checked"), for: .normal)
        self.radioPercent.setImage(UIImage(named: "icon-radio-uncheck"), for: .normal)
        self.btnChoosePercent.isUserInteractionEnabled = false
        self.btnChoosePriceByMoney.isUserInteractionEnabled = false
        
        self.textfield_price_by_time.isUserInteractionEnabled = false
        self.textfield_price_by_time.isEnabled = false
        
        self.textfield_percent_by_time.isEnabled = false
        self.textfield_percent_by_time.isUserInteractionEnabled = false
        self.btnChooseTemPrice.isUserInteractionEnabled = true
    }
    func checkTemPercent(){
      
        self.btnChooseTemPrice.isUserInteractionEnabled = false
        self.isChoosePriceByTime = DEACTIVE
        self.radioPercent.setImage(UIImage(named: "icon-radio-checked"), for: .normal)
        self.radioPrice.setImage(UIImage(named: "icon-radio-uncheck"), for: .normal)
        self.btnChoosePercent.isUserInteractionEnabled = false
        self.btnChoosePriceByMoney.isUserInteractionEnabled = false
        
        self.textfield_price_by_time.isUserInteractionEnabled = false
        self.textfield_price_by_time.isEnabled = false
        
        self.textfield_percent_by_time.isEnabled = true
        self.textfield_percent_by_time.isUserInteractionEnabled = true
    }
    
    func checkIncreasePrice() {
        self.isIncrease = ACTIVE
        self.radioPriceIncrease.setImage(UIImage(named: "icon-radio-checked"), for: .normal)
        self.radioPriceDescrease.setImage(UIImage(named: "icon-radio-uncheck"), for: .normal)
//        Utils.isHideAllView(isHide: false, view: self.view_percent)
        
        self.isPriceCheck = ACTIVE
        self.btnCheckPriceByTime.setImage(UIImage(named: "check_2"), for: .normal)
        self.constraint_height_price_config.constant = 350
        Utils.isHideAllView(isHide: false, view: self.view_from)
        Utils.isHideAllView(isHide: false, view: self.view_to)
        Utils.isHideAllView(isHide: false, view: self.view_price)
        Utils.isHideAllView(isHide: false, view: self.view_percent)
        Utils.isHideAllView(isHide: false, view: self.view_price_type)
        
        
        if food.temporary_price ==  0{
                textfield_price_by_time.placeholder = "Nhập giá tiền tăng thêm"
            
            }
        else{
            textfield_price_by_time.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(food.temporary_price)).replacingOccurrences(of: "-", with: "")
            textfield_percent_by_time.placeholder = "Nhập phần trăm tăng giá món ăn"
//            textfield_percent_by_time.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(food.temporary_percent)).replacingOccurrences(of: "-", with: "")
        }
       
        
        if food.temporary_percent == 0 {
                textfield_percent_by_time.placeholder = "Nhập phần trăm tăng giá món ăn"
        }else{
            
                textfield_percent_by_time.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(food.temporary_percent)).replacingOccurrences(of: "-", with: "")
            textfield_price_by_time.placeholder = "Nhập giá tiền tăng thêm"
        }

    }
    
    func checkPromotionPrice() {
        self.isIncrease = DEACTIVE
        self.radioPriceDescrease.setImage(UIImage(named: "icon-radio-checked"), for: .normal)
        self.radioPriceIncrease.setImage(UIImage(named: "icon-radio-uncheck"), for: .normal)
        Utils.isHideAllView(isHide: true, view: self.view_percent)
        
        // default set giảm theo giá
        self.isChoosePriceByTime = ACTIVE
        self.radioPrice.setImage(UIImage(named: "icon-radio-checked"), for: .normal)
        self.radioPercent.setImage(UIImage(named: "icon-radio-uncheck"), for: .normal)
        self.btnChoosePercent.isUserInteractionEnabled = false
        self.btnChoosePriceByMoney.isUserInteractionEnabled = false
        
        self.textfield_price_by_time.isUserInteractionEnabled = false
        self.textfield_price_by_time.isEnabled = false
        
        self.textfield_percent_by_time.isEnabled = false
        self.textfield_percent_by_time.isUserInteractionEnabled = false
        self.btnChooseTemPrice.isUserInteractionEnabled = true
        
        self.btnCheckPriceByTime.setImage(UIImage(named: "check_2"), for: .normal)
        self.constraint_height_price_config.constant = 350
        Utils.isHideAllView(isHide: false, view: self.view_from)
        Utils.isHideAllView(isHide: false, view: self.view_to)
        Utils.isHideAllView(isHide: false, view: self.view_price)
//                    Utils.isHideAllView(isHide: false, view: self.view_percent)
        Utils.isHideAllView(isHide: false, view: self.view_price_type)
        
        if food.temporary_price ==  0{
                textfield_price_by_time.placeholder = "Nhập giá tiền giảm"
        }
        else{
            textfield_price_by_time.text =  Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(food.temporary_price)).replacingOccurrences(of: "-", with: "")
        }

        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE){
            Utils.isHideAllView(isHide: true, view: root_view_print_chefbar)
            constraint_height_vat_margin_config.constant = 3
        }else{
            if (self.isPrinter == ACTIVE){
                constraint_height_vat_margin_config.constant = 120
            }else{
                constraint_height_vat_margin_config.constant = 60
            }


        }
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.brand_id.accept(ManageCacheObject.getCurrentBrand().id)
        viewModel.status.accept(ACTIVE)
        getCategories()
        getKitchenes()
        getUnits()
        getVAT()
    }
    

}
