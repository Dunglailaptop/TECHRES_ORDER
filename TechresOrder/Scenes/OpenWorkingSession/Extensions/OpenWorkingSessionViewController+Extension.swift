//
//  OpenWorkingSessionViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 26/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper
import JonAlert
//MARK: -- CALL API 
extension OpenWorkingSessionViewController {

    func openSession(){
            viewModel.openSession().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
//                    dLog(response.message)
//                    Toast.show(message: "Mở ca thành công...", controller: self)
                    JonAlert.showSuccess(message: "Mở ca thành công...",duration: 2.0)
//                    showMessage(title: "MỞ CA", message: "Mở ca thành công...", stype: APIEndPoint.MESSAGE_STYPE_ENUM.SUCCESS)
                    self.viewModel.makePopViewController()
                }else{
                    dLog(response.message ?? "")
//                    Toast.show(message: response.message ?? "Có lỗi trong quá trình thêm món", controller: self)
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                }
             
            }).disposed(by: rxbag)
        }
    
    func workingSessions(){
            viewModel.workingSessions().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    if let workingSessions = Mapper<WorkingSession>().mapArray(JSONObject: response.data) {
                        dLog(workingSessions.toJSON())
                        self.lbl_session_name.text = workingSessions[0].name
                        self.lbl_session_from_time.text = workingSessions[0].from_hour
                        self.lbl_session_to_time.text = workingSessions[0].to_hour
                    }
                }else{
                    dLog(response.message ?? "")
//                    Toast.show(message: response.message ?? "Có lỗi trong quá trình thêm món", controller: self)
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                }
             
            }).disposed(by: rxbag)
        }
    
    func checkWorkingSessions(){
            viewModel.checkWorkingSessions().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    if let checkWorkingSession = Mapper<CheckWorkingSession>().map(JSONObject: response.data) {
                        dLog(checkWorkingSession.toJSON())
                    }
                }else{
                    dLog(response.message ?? "")
//                    Toast.show(message: response.message ?? "Có lỗi trong quá trình thêm món", controller: self)
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                }
             
            }).disposed(by: rxbag)
        }
    
}
extension OpenWorkingSessionViewController:CalculatorMoneyDelegate {
    func presentModalCaculatorInputMoneyViewController() {
            let caculatorInputMoneyViewController = CaculatorInputMoneyViewController()
            caculatorInputMoneyViewController.checkMoneyFee = 1000
            caculatorInputMoneyViewController.limitMoneyFee = 99999999
            caculatorInputMoneyViewController.total_amount = self.viewModel.before_cash.value
            caculatorInputMoneyViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: caculatorInputMoneyViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
            caculatorInputMoneyViewController.delegate = self
            present(nav, animated: true, completion: nil)

        }
    
    func callBackCalculatorMoney(amount: Int, position: Int) {
        dLog(amount)
        viewModel.before_cash.accept(amount)
        btnInputMoney.setTitle(Utils.stringVietnameseMoneyFormatWithNumber(amount: Float( String(format: "%d", amount))!), for: .normal)
        
       
    }
}
