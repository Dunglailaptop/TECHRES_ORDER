//
//  DialogConfirmViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 30/01/2023.
//

import UIKit
import RxSwift


class DialogConfirmViewController: BaseViewController {
    var viewModel = DialogConfirmViewModel()
    var router = DialogConfirmRouter()
    @IBOutlet weak var root_view: UIView!
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lbl_content: UILabel!
    
    var dialog_type = 0 // login = 0, other = 1 
    var dialog_title = ""
    var content = ""
    var delegate: DialogConfirmDelegate?
    var title_button_ok = ""
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
                           self?.delegate?.accept()
                       }).disposed(by: rxbag)
        
        
        btnCancel.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.viewModel.makePopViewController()
                           self?.delegate?.cancel()
                       }).disposed(by: rxbag)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCancel.isHidden = isHideCancelButton
        lbl_title.text = dialog_title
        lbl_content.text = content
        
        if(!title_button_ok.isEmpty){
            btnOK.setTitle(title_button_ok, for: .normal)
        }
    }
  

}
