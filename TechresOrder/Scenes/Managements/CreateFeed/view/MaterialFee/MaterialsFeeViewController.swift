//
//  MaterialsFeeViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit

class MaterialsFeeViewController: BaseViewController {
    var viewModel = FeeManagerViewModel()
    var router = FeeManagerRouter()
    
    @IBOutlet weak var btnChooseDate: UIButton!
    @IBOutlet weak var textfield_reason: UITextField!
    
    @IBOutlet weak var textfield_amount: UITextField!

    @IBOutlet weak var root_view: UIView!
    
    @IBOutlet weak var textfield_date: UITextField!
    
    @IBOutlet weak var btnChooseAmount: UIButton!
    

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var textview_note: UITextView!
    
    var picker: DateTimePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        viewModel.bind(view: self, router: router)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        textview_note.withDoneButton()
        textview_note.setPlaceholderColor("Ghi chú", false)
        textfield_date.text = Utils.getCurrentDateString()

        _ = textview_note.rx.text.map { $0 ?? "" }.bind(to: viewModel.noteText)
        _ = textfield_date.rx.text.map { $0 ?? "" }.bind(to: viewModel.dateText)
        _ = textfield_reason.rx.text.map { $0 ?? "" }.bind(to: viewModel.titleText)
        _ = textfield_amount.rx.text.map { $0 ?? "" }.bind(to: viewModel.amountText)
        
//        _ = viewModel.isValid.subscribe({ [weak self] isValid in
//            dLog(isValid)
//            guard let strongSelf = self, let isValid = isValid.element else { return }
//            strongSelf.btnSave.isEnabled = isValid
//            strongSelf.btnSave.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
//            strongSelf.btnSave.tintColor = ColorUtils.white()
//        })
        
//
//        // Register for keyboard notifications
//                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
                              self!.viewModel.addition_fee_reason_type_id.accept(16)// Chi phí NVL
                              self!.createFee()
                          }).disposed(by: rxbag)
        
        
        
    }

//    @objc func keyboardWillHide(_ notification: Notification) {
//        root_view.frame.origin.y = 0
//        }
//
//    @objc func keyboardWillShow(_ notification: Notification) {
//            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//                let adjustedKeyboardFrame = root_view.convert(keyboardFrame, from: nil)
//                let intersection = root_view.frame.intersection(adjustedKeyboardFrame)
//
//                // Adjust the view's frame by subtracting the height of the keyboard
//                let keyboardHeight = intersection.size.height
//                root_view.frame.origin.y -= keyboardHeight
//
//
//            }
//        }
//
}
