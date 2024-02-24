//
//  VerifyOTPViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 30/01/2023.
//

import UIKit
import OTPFieldView
import JonAlert
class VerifyOTPViewController: BaseViewController {
    var viewModel = VerifyOTPViewModel()
    var router = VerifyOTPRouter()
    var restaurant_name_identify = ""
    var username = ""
    var OTPCode: String = ""
    var temp = 0
    var time_await = 0
    @IBOutlet weak var view_otp: OTPFieldView!
    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var lbl_wait_time_otp: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        setupOtpView()
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(counterTime), userInfo: nil, repeats: true)
//
//        heightViewSendAgain.constant = 30
        //view_send_again_otp.isHidden = true
        lbl_wait_time_otp.isHidden = true

        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupOtpView(){
        self.view_otp.fieldsCount = 4
        self.view_otp.fieldBorderWidth = 2
        self.view_otp.defaultBorderColor = UIColor.gray
        self.view_otp.filledBorderColor = ColorUtils.main_color()
        self.view_otp.cursorColor = ColorUtils.main_color()
        self.view_otp.displayType = .roundedCorner
        self.view_otp.fieldSize = 40
//        self.view_otp.fieldFont =  UIFont.init(name: (Font.FontName.RobotoRegular).rawValue, size: 24.0)!
        self.view_otp.separatorSpace = 8
        self.view_otp.shouldAllowIntermediateEditing = false
        self.view_otp.delegate = self
        
       
       
        self.view_otp.initializeUI()
    }
    
    
    @objc func counterTime() {
        //example functionality
        if self.time_await > 0 {
//            self.view_otp.initializeOTPFields()
            self.time_await -= 1
            self.lbl_wait_time_otp.isHidden = false
            self.lbl_wait_time_otp.text = String( self.time_await) + "s"
            self.view_otp.isUserInteractionEnabled = false
           
            
        }else{
            self.view_otp.isUserInteractionEnabled = true
            self.lbl_wait_time_otp.isHidden = true
            
            self.view_otp.becomeFirstResponder()
           
        }
    }

}
extension VerifyOTPViewController{
    func verifyOTP(){
            viewModel.verifyOTP().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                   // Verify OTP Success . Call api
                    self.viewModel.makeVerifyPasswordViewController()
                }else{
                    dLog(response.message ?? "")
//                    Toast.show(message: response.message ?? "Có lỗi trong quá trình thêm món", controller: self)
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                }
             
            }).disposed(by: rxbag)
        }
}
