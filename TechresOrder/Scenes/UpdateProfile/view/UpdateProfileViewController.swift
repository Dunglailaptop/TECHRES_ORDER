//
//  UpdateProfileViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 04/02/2023.
//

import UIKit
import ZLPhotoBrowser
import Photos
import JonAlert

class UpdateProfileViewController: BaseViewController {
    var viewModel = UpdateProfileViewModel()
    var router = UpdateProfileRouter()
    var account = Account()
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var btnChooseImage: UIButton!
    @IBOutlet weak var lbl_username: UILabel!
    
    @IBOutlet weak var lbl_branch_name: UILabel!
    @IBOutlet weak var lbl_branch_address: UILabel!
    @IBOutlet weak var lbl_role_name: UILabel!
    
    
    @IBOutlet weak var textfield_full_name: UITextField!
    
    @IBOutlet weak var textfiled_phone_number: UITextField!
    @IBOutlet weak var textfield_birthday: UITextField!
    @IBOutlet weak var textfield_email: UITextField!
    @IBOutlet weak var textfield_address: UITextField!
    @IBOutlet weak var textfield_city: UITextField!
    @IBOutlet weak var textfield_district: UITextField!
    @IBOutlet weak var textfield_ward: UITextField!
    
    
    @IBOutlet weak var radioMale: UIButton!
    @IBOutlet weak var radioFeMale: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    
    @IBOutlet weak var btnChooseBirthday: UIButton!
    @IBOutlet weak var btnChooseCity: UIButton!
    @IBOutlet weak var btnChooseDistrict: UIButton!
    @IBOutlet weak var btnChooseWard: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    
    var picker: DateTimePicker?
    var gender = 0
    var imagecover = [UIImage]()
    var resources_path = [URL]()
    var selectedAssets = [PHAsset]()
    
    var list_cities = [Cities]()
    var list_districts = [District]()
    var list_wards = [Ward]()
    
    //h
    var isValidFullName:Bool = false
    var isValidPhone:Bool = false
    var isValidEmail:Bool = false
    var isValidAddress:Bool = false
    var isValidDateOfBirth:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        //bind value of textfield to variable of viewmodel
        _ = textfield_full_name.rx.text.map { $0 ?? "" }.bind(to: viewModel.fullNameText)
        _ = textfield_email.rx.text.map { $0 ?? "" }.bind(to: viewModel.emailText)
        _ = textfield_birthday.rx.text.map { $0 ?? "" }.bind(to: viewModel.birthdayText)
        _ = textfield_city.rx.text.map { $0 ?? "" }.bind(to: viewModel.cityText)
        _ = textfield_district.rx.text.map { $0 ?? "" }.bind(to: viewModel.districtText)
        _ = textfield_ward.rx.text.map { $0 ?? "" }.bind(to: viewModel.wardText)
        _ = textfield_address.rx.text.map { $0 ?? "" }.bind(to: viewModel.addressText)
        _ = textfiled_phone_number.rx.text.map { $0 ?? "" }.bind(to: viewModel.phoneText)
    

        
        //  subscribe result of variable isValid in LoginViewModel then handle button login is enable or not?
//     viewModel.isValid.subscribe({ [weak self] isValid in
//            dLog(isValid)
//            guard let strongSelf = self, let isValid = isValid.element else { return }
//            strongSelf.btnUpdate.isEnabled = isValid
//            strongSelf.btnUpdate.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
//         strongSelf.btnUpdate.titleLabel?.textColor = .white
//
//        })
        
        
        btnChooseBirthday.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              var stringDate: String = self?.textfield_birthday.text ?? ""
                              let dateFormatter = DateFormatter()
                              dateFormatter.dateFormat = "dd/MM/yyyy"
                              var convertedString:Date?
                              
                              if let date = dateFormatter.date(from: stringDate) {
                                  let calendar = Calendar.current
                                  let components = calendar.dateComponents([.year, .month, .day], from: date)
                                  
                                convertedString = calendar.date(from: components)
                              }
                      
                              self?.chooseBirthDayDate(dateFromString: convertedString ?? Date())
                              
                              //do hàm chooseBirthDayDate chỉ cho phép đủ 16 tuổi
                              self?.isValidDateOfBirth = true // get current value
                          }).disposed(by: rxbag)
        
        
        btnCancel.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              dLog("btnCancel")
                              self!.viewModel.makePopViewController()
                          }).disposed(by: rxbag)
        
        btnBack.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              dLog("btnBack")
                              self!.viewModel.makePopViewController()
                          }).disposed(by: rxbag)
        
        btnChooseImage.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              dLog("btnBack")
                              self!.chooseAvatar()
                          }).disposed(by: rxbag)
        
        radioMale.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              self!.gender = ACTIVE
                              self?.radioMale.setImage(UIImage(named: "icon-radio-checked"), for: .normal)
                              self?.radioFeMale.setImage(UIImage(named: "icon-radio-uncheck"), for: .normal)
                              
                          }).disposed(by: rxbag)
        
        radioFeMale.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              self!.gender = DEACTIVE
                              self?.radioMale.setImage(UIImage(named: "icon-radio-uncheck"), for: .normal)
                              self?.radioFeMale.setImage(UIImage(named: "icon-radio-checked"), for: .normal)
                          }).disposed(by: rxbag)
        
        btnChooseCity.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              dLog("btnChooseCity")
                              self?.presentAddressDialogOfAccountInforViewController(areaType:"CITY")
                          }).disposed(by: rxbag)
        
        btnChooseDistrict.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              dLog("btnChooseDistrict")
                              self?.presentAddressDialogOfAccountInforViewController(areaType: "DISTRICT")
                          }).disposed(by: rxbag)
        
        btnChooseWard.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              dLog("btnChooseWard")
                              self!.presentAddressDialogOfAccountInforViewController(areaType: "WARD")
                          }).disposed(by: rxbag)
        //ahuy
//        btnUpdate.rx.tap.asDriver()
//                          .drive(onNext: { [weak self] in
//                            self!.imagecover.count > 0
//                            ? self!.updateProfileWithAvatar()
//                            : self!.updateProfileWithoutAvatar()
//                          }).disposed(by: rxbag)
        
        btnUpdate.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                            
               //fullname
                              if !self!.isValidFullName {

                                  JonAlert.showError(message: String(format: "Họ tên phải từ \(Constants.UPDATE_INFO_FORM_REQUIRED.requiredNameLength) đến \(Constants.UPDATE_INFO_FORM_REQUIRED.requiredNameLengthMax) ký tự" ), duration: 2.0)
                                      self!.textfield_full_name.text = String(self!.textfield_full_name.text!.prefix(Constants.UPDATE_INFO_FORM_REQUIRED.requiredNameLengthMax))
                              }
                          //phone
                          else if !self!.isValidPhone {
                              JonAlert.showError(message: String(format: "Số điện thoại không hợp lệ!"), duration: 2.0)
                          }
//                              //birthday
//                              else if !self!.isValidDateOfBirth {
//                                  JonAlert.showError(message: String(format: "Yêu cầu phải trên 16 tuổi"), duration: 2.0)
//
//                              }
                          //email
                          else if !self!.isValidEmail {
                              JonAlert.showError(message: String(format: "Email không hợp lệ!"), duration: 2.0)
                          }
                              //address
                              else if !self!.isValidAddress {
                                  JonAlert.showError(message: String(format: "Địa chỉ phải từ \(Constants.UPDATE_INFO_FORM_REQUIRED.requireAddressMin) đến \(Constants.UPDATE_INFO_FORM_REQUIRED.requireAddressLength) và chỉ chấp nhập các dấu , . - "), duration: 2.0)
                              }
                              
                          else{
                              self!.imagecover.count > 0
                              ? self!.updateProfileWithAvatar()
                              : self!.updateProfileWithoutAvatar()
                          }
             
                          }).disposed(by: rxbag)
       
        
        //h
        _ = viewModel.isValidFullName.subscribe({[weak self] isvalid in
            guard let strongSelf = self, let isvalid = isvalid.element else {
                return
            }
            strongSelf.isValidFullName = isvalid // Lấy giá trị hiện tại
            
            
            dLog("isValidFullName \(strongSelf.isValidFullName)")
            
            
            
        })
        _ = viewModel.isValidPhone.subscribe({ [weak self] isvalid in
            guard let strongSelf = self, let isvalid = isvalid.element else {
                return
            }
            strongSelf.isValidPhone = isvalid // Lấy giá trị hiện tại
          
            if let phoneNumber = strongSelf.textfiled_phone_number.text, phoneNumber.count > 0 {
                //chỉ cho nhập số
                    let allowedCharacters = CharacterSet.decimalDigits
                    let characterSet = CharacterSet(charactersIn: phoneNumber)
                    if !allowedCharacters.isSuperset(of: characterSet) {
                        strongSelf.textfiled_phone_number.text = String(strongSelf.textfiled_phone_number.text!.prefix(strongSelf.textfiled_phone_number.text!.count - 1))
                    }
                    //chỉ lấy 10 ký tự
                    if strongSelf.textfiled_phone_number.text!.count >= 10 {
                        strongSelf.textfiled_phone_number.text = String(strongSelf.textfiled_phone_number.text!.prefix(10))
                        strongSelf.isValidPhone = true // Lấy giá trị hiện tại
                    }
                //chỉ chấp nhận số 0 đầu
                if !phoneNumber.hasPrefix("0") {
                    strongSelf.isValidPhone = false
                }
            }
        })

        
        _ = viewModel.isValidEmail.subscribe({[weak self] isvalid in
            guard let strongSelf = self, let isvalid = isvalid.element else {
                return
            }
            strongSelf.isValidEmail = isvalid // get current value
            dLog("isValidEmail \(strongSelf.isValidEmail)")
        })
        
//        _ = viewModel.isValidDateOfBirth.subscribe({[weak self] isvalid in
//            guard let strongSelf = self, let isvalid = isvalid.element else {
//                return
//            }
//            strongSelf.isValidDateOfBirth = isvalid // get current value
//
//
//        })
        
        //chỉ chấp nhận 255 ký tự
        _ = viewModel.isValidAddress.subscribe({[weak self] isvalid in
            guard let strongSelf = self, let isvalid = isvalid.element else {
                return
            }
            strongSelf.isValidAddress = isvalid // get current value
            strongSelf.textfield_address.text = String(strongSelf.textfield_address.text!.prefix(255))
            dLog("isValidAddress \(strongSelf.isValidAddress)")
        })
        

        
    }

        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.employee_id.accept(ManageCacheObject.getCurrentUser().id)
        self.getProfile()
    }
    
    
    @IBAction func btnChooseMale(_ sender: Any) {
        viewModel.gender.accept(1)
    }
    
    @IBAction func btnChooseFemale(_ sender: Any) {
        viewModel.gender.accept(0)
    }
    
}
