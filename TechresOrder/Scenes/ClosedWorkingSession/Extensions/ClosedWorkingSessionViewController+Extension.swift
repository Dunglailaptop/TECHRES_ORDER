//
//  ClosedWorkingSessionViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 22/02/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert

extension ClosedWorkingSessionViewController {
    func workingSessionValue(){
            viewModel.workingSessionValue().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    if let workingSessionValue = Mapper<WorkingSessionValue>().map(JSONObject: response.data) {
                        dLog(workingSessionValue.toJSON())
                        self.setupData(workingSessionValue: workingSessionValue)
                    }
                }else{
                    dLog(response.message ?? "")
//                    Toast.show(message: response.message ?? "Có lỗi trong quá trình thêm món", controller: self)
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình thêm món.", duration: 2.0)
                }
             
            }).disposed(by: rxbag)
        }
    
    func closeWorkingSession(){
            viewModel.closeWorkingSession().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
//                    Toast.show(message: "Ca làm việc đã được đóng. Bắt đầu mở ca mới...", controller: self)
                    JonAlert.showSuccess(message: "Ca làm việc đã được đóng. Bắt đầu mở ca mới...", duration: 2.0)
                    self.viewModel.makePopViewController()
                    self.delegate?.callBackReload()
                   
                }else{
                    dLog(response.message ?? "")
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình thêm món.", duration: 2.0)
//                    Toast.show(message: response.message ?? "Có lỗi trong quá trình thêm món", controller: self)
                }
             
            }).disposed(by: rxbag)
        }
}

extension ClosedWorkingSessionViewController {
    func setupData(workingSessionValue:WorkingSessionValue){
        //Tiền cọc
//        txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_amount!)
        txtDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_cash_amount!)
        txtDepositBankAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_bank_amount!)
        txtDepositTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_transfer_amount!)
        txtTotalReturnDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.return_deposit_amount!)
        txtReturnDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.return_deposit_cash_amount!)
        txtReturnDepositTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.return_deposit_transfer_amount!)
        
        //Nạp thẻ
        txtTotalCharge.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_amount!)
        txtTotalTopUpCardCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_cash_amount!)
        txtTotalTopUpCardBankAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_bank_amount!)
        txtTotalTopUpCardTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_transfer_amount!)
        
        //Phiếu thu
        txtTotalReceipt.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_total_amount_by_addition_fee!)
        txtInCashAmountByAdditionFee.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_cash_amount_by_addition_fee!)
        txtInBankAmountByAdditionFee.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_bank_amount_by_addition_fee!)
        txtInTransferAmountByAdditionFee.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_transfer_amount_by_addition_fee!)
        
        //Phiếu chi
        txtTotalFee.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.out_total_amount_by_addition_fee!)
        txtOutCashAmountByAdditionFee.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.out_cash_amount_by_addition_fee!)
        txtTipAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.tip_amount!)
        txtOutTransferAmountByAdditionFee.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.out_transfer_amount_by_addition_fee!)
        
        //Bán hàng
        txtMoneyCashFirst.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.before_cash!)
        txtMoneyFinalCash.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.cash_amount!)
        txtReceipts.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_cash_amount_by_addition_fee!)
        txtDepositMoney.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_amount!)
        txtMoneyRecharge.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_amount!)
        txtTotalAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_amount_final!)
//        txtMoneyLeftOver.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.before_cash!)
        txtTipAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.tip_amount!)
        txtSpendingMoney.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_cost_final!)
        txtTotalReceipt.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_receipt_amount_final!)
        txtReturnDeposit.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.return_deposit_cash_amount!)
        txtPayment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.out_cash_amount_by_addition_fee!)
        
        //
        txtDifference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - workingSessionValue.return_deposit_transfer_amount!)
        lbl_deposit_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_amount!)
        
        txtInTotalReceipt.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_total_amount_by_addition_fee!)
        txtTotalSell.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_amount!)
        txtMoneyCashReturn.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.cash_amount!)
        txtMoneyTransfer.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.transfer_amount!)
        txtMoneyBank.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.bank_amount!)
        
        txtMoneyDebt.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.debt_amount!)
        txtTip.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.tip_amount!)
        
    }
}
