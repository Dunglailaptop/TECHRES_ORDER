//
//  CreateCategoryViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import JonAlert

class CreateCategoryViewController: BaseViewController {
    var viewModel = CreateCategoryViewModel()
    var router = CreateCategoryRouter()
    
    var delegate:TechresDelegate?
    
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var btnChooseCategory: UIButton!
    @IBOutlet weak var btnCheckStatus: UIButton!
    @IBOutlet weak var btnChooseStatus: UIButton!
    @IBOutlet weak var txt_categoryName: UITextField!
    
    @IBOutlet weak var lbl_btn_create_Categoty: UILabel!
    @IBOutlet weak var btnCreateCategory: UIButton!
    @IBOutlet weak var lbl_header: UILabel!
    
    @IBOutlet weak var lbl_note_categoryName: UILabel!
    @IBOutlet weak var textfield_category_type: UITextField!
    let title_array = ["Món ăn", "Đồ uống", "Loại khác"]
    
    
    let list_icons = ["baseline_assessment_black_48pt",
                      "baseline_assessment_black_48pt",
                      "baseline_assessment_black_48pt",
                      "baseline_assessment_black_48pt"]
    
    var categoryType = 0
    var categoryCode = ""
    
    var cate = Category()
    var isPressed = true
    override func viewDidLoad() {
        super.viewDidLoad()
        root_view.round(with: .both, radius: 8)
        // Do any additional setup after loading the view.
        btnCheckStatus.isUserInteractionEnabled = false
        btnChooseStatus.isUserInteractionEnabled = false
        btnCheckStatus.setImage(UIImage(named: "check_2"), for: .normal)
//        btnCreateCategory.setTitle("THÊM", for: .normal)
        txt_categoryName.becomeFirstResponder()
        btnCheckStatus.setImage(UIImage(named: "check_2"), for: .normal)
        viewModel.status.accept(ACTIVE)
        
        textfield_category_type.text = title_array[0]
        viewModel.categoryType.accept(0)
        
        
        _ = txt_categoryName.rx.text.map { $0 ?? "" }.bind(to: viewModel.name)

        _ = viewModel.isValid.subscribe({ [weak self] isValid in
            dLog(isValid)
            guard let strongSelf = self, let isValid = isValid.element else { return }
            //strongSelf.btnCreateCategory.isEnabled = isValid
//            strongSelf.btnCreateCategory.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
//            strongSelf.btnCreateCategory.titleLabel?.textColor = .white
            
            //không cho nhập lớn hơn 50 ký tự
            if isValid
            {
                strongSelf.lbl_note_categoryName.text = ""
     
            }else{
                strongSelf.lbl_note_categoryName.text = "Tên danh mục từ \(Constants.CATEGORY_FORM_REQUIRED.requiredUserIDMinLength) đến \(Constants.CATEGORY_FORM_REQUIRED.requiredUserIDMaxLength) ký tự"
                
                if strongSelf.txt_categoryName.text!.count > Constants.CATEGORY_FORM_REQUIRED.requiredUserIDMaxLength {
                    strongSelf.txt_categoryName.text = String(strongSelf.txt_categoryName.text!.prefix(Constants.CATEGORY_FORM_REQUIRED.requiredUserIDMaxLength))
                    
                    strongSelf.lbl_note_categoryName.text = ""
                }
            }
            
        })
        
        if(cate!.id > 0){// update category
            txt_categoryName.text = cate?.name
            btnCheckStatus.isUserInteractionEnabled = true
            btnChooseStatus.isUserInteractionEnabled = true
            lbl_header.text = "CHỈNH SỬA DANH MỤC"
            btnCreateCategory.setTitle("CẬP NHẬT", for: .normal)
            lbl_btn_create_Categoty.text = "CẬP NHẬT"
            if(cate?.status == ACTIVE){
                btnCheckStatus.setImage(UIImage(named: "check_2"), for: .normal)
            }else{
                btnCheckStatus.setImage(UIImage(named: "un_check_2"), for: .normal)
            }
            title_array.enumerated().forEach { (index, value) in
                if(self.cate?.category_type == index+1){
                    self.textfield_category_type.text = value
                    self.viewModel.categoryType.accept(index+1)
                    
                }
            }
            
            
        }
        
        btnCheckStatus.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           
                           if(self!.viewModel.status.value == ACTIVE){
                               self!.btnCheckStatus.setImage(UIImage(named: "un_check_2"), for: .normal)
                               self!.viewModel.status.accept(DEACTIVE)
                           }else{
                               self!.viewModel.status.accept(ACTIVE)
                               self!.btnCheckStatus.setImage(UIImage(named: "check_2"), for: .normal)
                           }
                           
                       }).disposed(by: rxbag)
        
        btnChooseStatus.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           if(self!.viewModel.status.value == ACTIVE){
                               self!.btnCheckStatus.setImage(UIImage(named: "un_check_2"), for: .normal)
                               self!.viewModel.status.accept(DEACTIVE)
                           }else{
                               self!.viewModel.status.accept(ACTIVE)
                               self!.btnCheckStatus.setImage(UIImage(named: "check_2"), for: .normal)
                           }
                           
                       }).disposed(by: rxbag)
        
    }

    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }

    
    @IBAction func actionCreate(_ sender: Any) {
        
        for i in self.txt_categoryName.text!{
            if Utils.ischaracter(string: String(i)){
//                Toast.show(message: "Tên danh mục không được phép nhập ký tự đặc biệt.", controller: self)
                JonAlert.showError(message: "Tên danh mục không được phép nhập ký tự đặc biệt!", duration: 2.0)
                return
            }
        }
        // hiển thị cảnh báo
        if (self.txt_categoryName.text!.count < Constants.CATEGORY_FORM_REQUIRED.requiredUserIDMinLength) || (self.txt_categoryName.text!.count > Constants.CATEGORY_FORM_REQUIRED.requiredUserIDMaxLength) {
            
            JonAlert.showError(message: String(format: "Tên danh mục từ \(Constants.CATEGORY_FORM_REQUIRED.requiredUserIDMinLength) đến \(Constants.CATEGORY_FORM_REQUIRED.requiredUserIDMaxLength) ký tự" ), duration: 2.0)
            
        }else{
            if(cate!.id > 0){
                self.viewModel.id.accept(cate!.id)
                self.viewModel.code.accept(cate!.code)
                if (self.isPressed){
                    self.isPressed = false
                    self.updateCategory()
                    
                }
                
            }
            else{
                
                    categoryCode = (self.txt_categoryName.text?.stripingDiacritics.replacingOccurrences(of: " ", with: ""))!
                    
                    self.createCategory()

            }
        }
        
        
        
    }
    
    @IBAction func actionChooseCategory(_ sender: Any) {
        if(cate!.id > 0){
            return
        }
        self.showChooseCategory()
        
    }
    
}
extension CreateCategoryViewController{
    func createCategory(){
        viewModel.createCategory().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Create category Success...")
//                Toast.show(message: "Thêm danh mục thành công", controller:  UIApplication.topViewController()!)
                JonAlert.showSuccess(message: "Thêm danh mục thành công", duration: 2.0)
//                UIApplication.topViewController()?.view.showToast(embedding: self.view)
                
                self.delegate?.callBackReload()
                self.navigationController?.dismiss(animated: true)
            }else{
//                UIAlertController.showAlert(title: "Thêm danh mục".uppercased(), message:response.message)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message)
            }
        }).disposed(by: rxbag)
}
    func updateCategory(){
        viewModel.updateCategory().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Update category Success...")
//                Toast.show(message: "Cập nhật danh mục thành công", controller: self)
//                Toast.show(message: "Cập nhật danh mục thành công", controller:  UIApplication.topViewController()!)
                JonAlert.showSuccess(message: "Cập nhật danh mục thành công", duration: 2.0)
                self.delegate?.callBackReload()
                self.navigationController?.dismiss(animated: true)
            }else{
//                UIAlertController.showAlert(title: "Cập nhật danh mục".uppercased(), message:response.message)
//                Toast.show(message: response.message ?? "Cập nhật danh mục thất bại", controller: self)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message ?? "")
            }
            self.isPressed = true
        }).disposed(by: rxbag)
}
    
}
