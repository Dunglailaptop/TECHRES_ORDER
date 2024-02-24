//
//  DialogConfirmWorkingSessionViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 30/01/2023.
//

import UIKit
import RxSwift


class DialogConfirmWorkingSessionViewController: BaseViewController {
    var viewModel = DialogConfirmWorkingSessionViewModel()
    var router = DialogConfirmWorkingSessionRouter()
    @IBOutlet weak var root_view: UIView!
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lbl_content: UILabel!
    var order_working_session_id = 0
    var dialog_type = 0 // login = 0, other = 1 
    var dialog_title = ""
    var content = ""
    var title_btn_ok = ""
    var title_btn_cancel = ""
    
    var delegate: DialogConfirmWorkingSessionDelegate?
    
    var isHideCancelButton = false
    var assignWorkingSession = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        root_view.round(with: .both, radius: 8)
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
       

        btnOK.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.viewModel.makePopViewController()
                           self?.delegate?.accept(id:self!.order_working_session_id)
                       }).disposed(by: rxbag)
        
        
        btnCancel.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.viewModel.makePopViewController()
                           self?.delegate?.close()
                       }).disposed(by: rxbag)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCancel.isHidden = isHideCancelButton
        lbl_title.text = dialog_title
        lbl_content.text = content
        
        if(title_btn_ok.count > 0){
            btnOK.setTitle(title_btn_ok, for: .normal)
        }
        if(title_btn_cancel.count > 0){
            btnCancel.setTitle(title_btn_cancel, for: .normal)
        }
        
    }
  

}
