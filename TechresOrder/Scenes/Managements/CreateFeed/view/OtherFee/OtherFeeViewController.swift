//
//  OtherFeeViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit
import JonAlert

class OtherFeeViewController: BaseViewController {
    var viewModel = FeeManagerViewModel()
    var router = FeeManagerRouter()
    @IBOutlet weak var root_view: UIView!
    
    @IBOutlet weak var btnChooseDate: UIButton!
    @IBOutlet weak var textfield_reason: UITextField!
    
    @IBOutlet weak var textfield_date: UILabel!
    
    @IBOutlet weak var textfield_amount: UITextField!

    @IBOutlet weak var btnChooseAmount: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var textview_note: UITextView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var picker: DateTimePicker?
    
   var selectedFeeTypeIndex = 0
    
    var strings = ["Ăn uống",
                    "Chi tiêu",
                    "Đi lại",
                    "Giáo dục",
                    "Mỹ phẩm",
                    "Giao lưu",
                    "Liên lạc",
                    "Quần áo",
                    "Tiền điện",
                    "Tiền nước",
                    "Tiền nhà",
                    "Y tế"]
    var imgs = ["icon_an_uong",
                "icon_chi_tieu_hang_ngay",
                "icon_di_lai",
                "icon_giao_duc",
                "icon_my_pham",
                "icon_phi_giao_luu",
                "icon_phi_lien_lac",
                "icon_quan_ao",
                "icon_tien_dien",
                "icon_tien_nuoc",
                "icon_tien_nha",
                "icon_y_te"]
    var otherFees = [Fee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        viewModel.bind(view: self, router: router)
        textview_note.withDoneButton()
        
        textview_note.setPlaceholderColor("Ghi chú", false)
        
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)

        textfield_date.text = Utils.getCurrentDateString()
        
        for var i in 0..<strings.count {
            var fee = Fee.init()
            fee?.id = i
            fee?.object_name = strings[i]
            fee?.icon = imgs[i]
            otherFees.append(fee!)
        }
        
        btnChooseAmount.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              dLog("btnChooseAmount")
                              self!.presentModalCaculatorInputMoneyViewController()
                          }).disposed(by: rxbag)
        
        btnChooseDate.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              dLog("btnChooseDate")
                              self?.chooseDate()
                          }).disposed(by: rxbag)
        
        btnSave.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              dLog("btnSave")
                              self!.viewModel.addition_fee_reason_type_id.accept(8) // Chi phí khác
                              
                              let isValidOtherFee = self!.isValidOtherFee(fees: self!.otherFees, textField: self!.textfield_reason)
                              if  isValidOtherFee {
                                  self?.createFee()
                              }else{
                                  JonAlert.showError(message: String(format: "Hạng mục không tồn tại!" ), duration: 2.0)
                              }
                              
                          }).disposed(by: rxbag)

        
        registerCollectionViewCell()
        binđDataCollectionView()
        
        viewModel.titleText.subscribe( // Thực hiện subscribe Observable
          onNext: { [weak self] titleText in
              self?.textfield_reason.text = titleText
          }).disposed(by: rxbag)
        
        // Register for keyboard notifications
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        viewModel.other_fees.accept(otherFees)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        root_view.frame.origin.y = 0
        }

    @objc func keyboardWillShow(_ notification: Notification) {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let adjustedKeyboardFrame = root_view.convert(keyboardFrame, from: nil)
                let intersection = root_view.frame.intersection(adjustedKeyboardFrame)

                // Adjust the view's frame by subtracting the height of the keyboard
                let keyboardHeight = intersection.size.height
                root_view.frame.origin.y -= keyboardHeight


            }
        }
    
    func isValidOtherFee(fees: [Fee], textField: UITextField) -> Bool{
        for fee in fees {
            if fee.object_name == textField.text {
                return true
            }
            
        }
        return false
    }
}
