//
//  MaterialsFeeViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit
import RxSwift
import JonAlert
extension MaterialsFeeViewController {
    

}
extension MaterialsFeeViewController{
    func presentModalCaculatorInputMoneyViewController() {
            let caculatorInputMoneyViewController = CaculatorInputMoneyViewController()
            caculatorInputMoneyViewController.checkMoneyFee = 1000
            caculatorInputMoneyViewController.limitMoneyFee = 1000000000
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
    //        newFeedBottomSheetActionViewController.newFeed = newFeed
    //        newFeedBottomSheetActionViewController.index = position
            present(nav, animated: true, completion: nil)

        }
      
    func chooseDate(){
            let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
                let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
                let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        //        picker.timeInterval = DateTimePicker.MinuteInterval.thirty
                picker.highlightColor = UIColor(red: 255.0/255.0, green: 162.0/255.0, blue: 51.0/255.0, alpha: 1)
                picker.darkColor = UIColor.darkGray
                picker.doneButtonTitle = "CHỌN"
                picker.doneBackgroundColor = UIColor(red: 0.0/255.0, green: 114.0/255.0, blue: 188.0/255.0, alpha: 1)
                picker.locale = Locale(identifier: "vi")
                
                picker.todayButtonTitle = "Hôm nay"
                picker.is12HourFormat = true
                picker.dateFormat = "dd/MM/YYYY hh:mm"
                picker.isTimePickerOnly = false
                picker.isDatePickerOnly = false
                picker.includeMonth = false // if true the month shows at top
                picker.completionHandler = { date in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/YYYY hh:mm"
                    self.title = formatter.string(from: date)
                }
                picker.delegate = self
                self.picker = picker
    }
}
extension MaterialsFeeViewController: CalculatorMoneyDelegate, DateTimePickerDelegate{
    func callBackCalculatorMoney(amount: Int, position: Int) {
        self.textfield_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(amount))
        self.viewModel.amount.accept(amount)
//        self.viewModel.quantity.accept(1)
        
    }
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        dLog(picker.selectedDateString)
        textfield_date.text = picker.selectedDateString
        self.viewModel.dateText.accept(picker.selectedDateString)
    }
}


extension MaterialsFeeViewController{
    func createFee(){
        viewModel.createFee().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Create fee Success...")
//                Toast.show(message: "Create fee Success...", controller: self)
                JonAlert.showSuccess(message: "Thêm chi phí mới thành công...",duration: 2.0)
                self.navigationController?.popViewController(animated: true)
            }else{
//                Toast.show(message: response.message ?? "Create fee có lỗi xảy ra", controller: self)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message)
            }
        }).disposed(by: rxbag)
}
    
}
