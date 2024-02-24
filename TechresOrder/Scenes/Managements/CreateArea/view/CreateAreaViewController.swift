//
//  CreateAreaViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import RxSwift
import JonAlert
class CreateAreaViewController: BaseViewController {
    var viewModel = CreateAreaViewModel()
    var router = CreateAreaRouter()
    
    @IBOutlet weak var root_view: UIView!
    
    var delegate:TechresDelegate?
    
//    var branch_id = 0
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var textfield_area_name: UITextField!
    @IBOutlet weak var btnStatusActivity: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lbl_create: UILabel!
    @IBOutlet weak var lbl_header: UILabel!
    
    // Thong báo lỗi
    @IBOutlet weak var lbl_error_Message: UILabel!
    
    
    var ischecked = 1
    
    var area = Area()
    var isPressed = true;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_error_Message.isHidden = true // Ẩn label báo lỗi
        root_view.round(with: .both, radius: 8)
        // Do any additional setup after loading the view.
        btnStatusActivity.isEnabled = false
        btnCreate.setTitle("THÊM MỚI", for: .normal)
        lbl_create.text = "THÊM MỚI"
        btnCheck.setImage(UIImage(named: "check_2"), for: .normal)
        
        textfield_area_name.becomeFirstResponder()
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        
        //  subscribe result of variable isValid in CreateAreaViewModel then handle button login is enable or not?
        _ = textfield_area_name.rx.text.map { $0 ?? "" }.bind(to: viewModel.areaNameText)

        _ = viewModel.isValid.subscribe({ [weak self] isValid in
            dLog(isValid)
            guard let strongSelf = self, let isValid = isValid.element else { return }
//            strongSelf.btnCreate.isEnabled = isValid
//            strongSelf.btnCreate.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
//            strongSelf.btnCreate.titleLabel?.textColor = .white
            // tối đa 20 ký tự
            if isValid {
               
                self?.lbl_error_Message.isHidden = true
               
            }else
            {
                if (self?.textfield_area_name.text!.count)! > 0 {
                    strongSelf.textfield_area_name.text = String((strongSelf.textfield_area_name.text?.prefix(20))!)
                    if strongSelf.textfield_area_name.text!.count < Constants.AREA_FORM_REQUIRED.requiredAreaNameMinLength {
                        
                        self?.lbl_error_Message.isHidden = false
                        self!.lbl_error_Message.text = "Tên khu vực phải từ \(Constants.AREA_FORM_REQUIRED.requiredAreaNameMinLength) tới \( Constants.AREA_FORM_REQUIRED.requiredAreaNameMaxLength) ký tự"
                        
                    }
                    
                }
              
            }
            //không cho nhập ký tự đặc biệt "!@#$%^&*(),.?\":{}|<>"
            self?.textfield_area_name.text = Utils.blockSpecialCharacters((self?.textfield_area_name.text!)!)
        })
        //chặn khoảng trắng đầu input
        _ = viewModel.checkAreaNameText.subscribe({ [weak self] areaNameText in
            guard let areaNameText = areaNameText.element else { return }
            if ((areaNameText.count == 1) && (areaNameText  == " ")){
                self?.textfield_area_name.text = ""
            }
            
        })
        
        if(area!.id > 0){// update area
            btnCreate.setTitle("CẬP NHẬT", for: .normal)
            lbl_create.text = "CẬP NHẬT"
            lbl_header.text = "CHỈNH SỬA KHU VỰC"
            textfield_area_name.text = area?.name
            var areaRequest = viewModel.areaRequest.value
            areaRequest.id = area!.id
            areaRequest.name = area!.name
                
            areaRequest.branch_id = ManageCacheObject.getCurrentBranch().id
            areaRequest.status = area!.status
            viewModel.areaRequest.accept(areaRequest)
            if(area?.status == ACTIVE){
                btnCheck.setImage(UIImage(named: "check_2"), for: .normal)
            }else{
                btnCheck.setImage(UIImage(named: "un_check_2"), for: .normal)
            }
            
        }else{
            btnCheck.isUserInteractionEnabled = false
            btnCheck.setImage(UIImage(named: "check_2"), for: .normal)
        }
        
        
        btnCancel.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.navigationController?.dismiss(animated: true)
                       }).disposed(by: rxbag)
        
        btnCreate.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           
                           if(self!.area!.id > 0){// update area
                               var areaRequest = self?.viewModel.areaRequest.value
                               areaRequest?.name = (self?.viewModel.areaNameText.value)!.trimmingCharacters(in: .whitespacesAndNewlines)
                               if areaRequest!.name.count > 20 {
                                   areaRequest!.name = String(((areaRequest!.name).prefix(20)))
                               }
                              
                               areaRequest?.branch_id = self!.viewModel.branch_id.value
                               areaRequest?.status = self!.ischecked
                               self!.viewModel.areaRequest.accept(areaRequest!)
                           }else{// create area
                               var areaRequest = AreaRequest.init()
                               areaRequest.name = (self!.viewModel.areaNameText.value).trimmingCharacters(in: .whitespacesAndNewlines)
                               if areaRequest.name.count > 20 {
                                   areaRequest.name = String(((areaRequest.name).prefix(20)))
                                  
                               }
                              
                               areaRequest.branch_id = self!.viewModel.branch_id.value
                               areaRequest.status = ACTIVE
                               self!.viewModel.areaRequest.accept(areaRequest)
                           }
                          
                           for i in self!.textfield_area_name.text!{
                               if Utils.ischaracter(string: String(i)){
//                                   Toast.show(message: "Tên khu vực không được phép nhập ký tự đặc biệt.", controller: self!)
                                   JonAlert.showSuccess(message: "Tên khu vực không được phép nhập ký tự đặc biệt!", duration: 2.0)
                                   return
                               }
                           }
                           
                           
                           // Thêm điều kiện kiểm tra trường valid giới hạn 2 đến 20 ký tự
                           if self!.checkValidInTextAreaName(textArea: (self?.textfield_area_name.text)!)
                            {
                               JonAlert.showSuccess(message: "Tối thiểu từ \(Constants.AREA_FORM_REQUIRED.requiredAreaNameMinLength) đến \(Constants.AREA_FORM_REQUIRED.requiredAreaNameMaxLength) ký tự", duration: 2.0)
//                               Toast.show(message: "Tối đa từ \(Constants.AREA_FORM_REQUIRED.requiredAreaNameMinLength) đến \(Constants.AREA_FORM_REQUIRED.requiredAreaNameMaxLength) ký tự", controller: self!)
                               return
                           }

                           if (self!.isPressed){
                               self?.isPressed = false
                               self?.createArea()

                           }
                           
                       }).disposed(by: rxbag)
        
        if(area!.id > 0){ // chỉ hoạt động khi update | disable khi tạo mới
            btnStatusActivity.isEnabled = true
            
            btnStatusActivity.rx.tap.asDriver()
                           .drive(onNext: { [weak self] in
                            
                               if(self!.ischecked == 0){
                                   self!.btnCheck.setImage(UIImage(named: "check_2"), for: .normal)
                                   self!.ischecked = 1
                               }else{
                                   self?.btnCheck.setImage(UIImage(named: "un_check_2"), for: .normal)
                                   self!.ischecked = 0
                               }
                                    
                              
                           }).disposed(by: rxbag)
        }
        
    }

    
}
