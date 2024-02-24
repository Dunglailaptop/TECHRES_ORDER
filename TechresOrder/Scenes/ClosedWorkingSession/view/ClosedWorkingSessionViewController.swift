//
//  ClosedWorkingSessionViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 22/02/2023.
//

import UIKit

class ClosedWorkingSessionViewController: BaseViewController {
    var viewModel = ClosedWorkingSessionViewModel()
    var router = ClosedWorkingSessionRouter()
    var delegate: TechresDelegate?
    @IBOutlet weak var textfield_money_500: UITextField!
    @IBOutlet weak var textfield_money_200: UITextField!
    @IBOutlet weak var textfield_money_100: UITextField!
    @IBOutlet weak var textfield_money_50: UITextField!
    @IBOutlet weak var textfield_money_20: UITextField!
    @IBOutlet weak var textfield_money_10: UITextField!
    @IBOutlet weak var textfield_money_5: UITextField!
    @IBOutlet weak var textfield_money_2: UITextField!
    @IBOutlet weak var textfield_money_1: UITextField!
    
    
    @IBOutlet weak var lbl_amout_500: UILabel!
    @IBOutlet weak var lbl_amout_200: UILabel!
    @IBOutlet weak var lbl_amout_100: UILabel!
    @IBOutlet weak var lbl_amout_50: UILabel!
    @IBOutlet weak var lbl_amout_20: UILabel!
    @IBOutlet weak var lbl_amout_10: UILabel!
    @IBOutlet weak var lbl_amout_5: UILabel!
    @IBOutlet weak var lbl_amout_2: UILabel!
    @IBOutlet weak var lbl_amout_1: UILabel!
    
    //Tiền cọc
    @IBOutlet weak var txtTotalDepositCashAmount: UILabel!
    @IBOutlet weak var txtDepositCashAmount: UILabel!
    @IBOutlet weak var txtDepositBankAmount: UILabel!
    @IBOutlet weak var txtDepositTransferAmount: UILabel!
    @IBOutlet weak var txtTotalReturnDepositCashAmount: UILabel!
    @IBOutlet weak var txtReturnDepositCashAmount: UILabel!
    @IBOutlet weak var txtReturnDepositTransferAmount: UILabel!
    
    //Nạp thẻ
    @IBOutlet weak var txtTotalCharge: UILabel!
    @IBOutlet weak var txtTotalTopUpCardCashAmount: UILabel!
    @IBOutlet weak var txtTotalTopUpCardBankAmount: UILabel!
    @IBOutlet weak var txtTotalTopUpCardTransferAmount: UILabel!
    
    //Phiếu thu
    @IBOutlet weak var txtInTotalReceipt: UILabel!
    @IBOutlet weak var txtInCashAmountByAdditionFee: UILabel!
    @IBOutlet weak var txtInBankAmountByAdditionFee: UILabel!
    @IBOutlet weak var txtInTransferAmountByAdditionFee: UILabel!
    
    //Phiếu chi
    @IBOutlet weak var txtTotalFee: UILabel!
    @IBOutlet weak var txtOutCashAmountByAdditionFee: UILabel!
    @IBOutlet weak var txtTipAmounts: UILabel!
    @IBOutlet weak var txtOutTransferAmountByAdditionFee: UILabel!
    
    //Bán hàng
    @IBOutlet weak var txtTotalSell: UILabel!
    @IBOutlet weak var txtMoneyBank: UILabel!
    @IBOutlet weak var txtMoneyTransfer: UILabel!
    @IBOutlet weak var txtTip: UILabel!
    @IBOutlet weak var txtMoneyDebt: UILabel!
    @IBOutlet weak var txtMoneyCashReturn: UILabel!
    
    //Tổng hợp
    @IBOutlet weak var txtMoneyCashFirst: UILabel!
    @IBOutlet weak var txtMoneyFinalCash: UILabel!
    @IBOutlet weak var txtReceipts: UILabel!
    @IBOutlet weak var txtDepositMoney: UILabel!
    @IBOutlet weak var txtMoneyRecharge: UILabel!
    @IBOutlet weak var txtTotalAmount: UILabel!
    @IBOutlet weak var lbl_deposit_amount: UILabel!
    @IBOutlet weak var txtTipAmount: UILabel!
    @IBOutlet weak var txtSpendingMoney: UILabel!
    @IBOutlet weak var txtTotalReceipt: UILabel!
    @IBOutlet weak var txtReturnDeposit: UILabel!
    @IBOutlet weak var txtPayment: UILabel!
    @IBOutlet weak var txtDifference: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
//        lbl_branch_name.text = ManageCacheObject.getCurrentUser().branch_name
        
        _ = textfield_money_500.rx.text.map { $0 ?? "" }.bind(to: viewModel.money_500)
//        _ = viewModel.money_500.subscribe({ [weak self] money_500 in
////            dLog(Int(money_500))
////            self?.lbl_amout_500.text = money_500//String(format: "%d", 500000 *  money_500)
//
//        })
        // 500.000
        textfield_money_500.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_500.text{
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_500.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((500000 * Int(money)!)))//String(format: "%d", (500000 * Int(money)!))
                        }else{
                            self.lbl_amout_500.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (500000 * 1000))
                            self.textfield_money_500.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_500.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_500.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                }else{
                    self.lbl_amout_500.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.txtDifference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)

             }).disposed(by: rxbag)
        
        // 200.000
        textfield_money_200.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_200.text{
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_200.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((200000 * Int(money)!)))//String(format: "%d", (500000 * Int(money)!))
                        }else{
                            self.lbl_amout_200.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (200000 * 1000))
                            self.textfield_money_200.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_200.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_200.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                }else{
                    self.lbl_amout_200.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.txtDifference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
             }).disposed(by: rxbag)
        
        // 100.000
        textfield_money_100.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_100.text{
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_100.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((100000 * Int(money)!)))
                        }else{
                            self.lbl_amout_100.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (100000 * 1000))
                            self.textfield_money_100.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_100.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_100.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                    
                    
                }else{
                    self.lbl_amout_100.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.txtDifference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
             }).disposed(by: rxbag)
        
        // 50.000
        textfield_money_50.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_50.text{
                    if(money.count > 0){
                        if(Int(money.trim())! <= 1000){
                            self.lbl_amout_50.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((50000 * Int(money.trim() )!)))
                        }else{
                            self.lbl_amout_50.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (50000 * 1000))
                            self.textfield_money_50.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_50.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_50.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                }else{
                    self.lbl_amout_50.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.txtDifference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
                
            }).disposed(by: rxbag)
        
        // 20.000
        textfield_money_20.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_20.text?.trim().replacingOccurrences(of: ",", with: ""){
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_20.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((20000 * Int(money)!)))
                        }else{
                            self.lbl_amout_20.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (20000 * 1000))
                            self.textfield_money_20.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_20.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_20.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                }else{
                    self.lbl_amout_20.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.txtDifference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
                
            }).disposed(by: rxbag)
        
        // 10.000
        textfield_money_10.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_10.text?.trim().replacingOccurrences(of: ",", with: ""){
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_10.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((10000 * Int(money)!)))
                        }else{
                            self.lbl_amout_10.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (10000 * 1000))
                            self.textfield_money_10.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_10.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_10.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                }else{
                    self.lbl_amout_10.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.txtDifference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
                
            }).disposed(by: rxbag)
        
        // 5.000
        textfield_money_5.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_5.text?.trim().replacingOccurrences(of: ",", with: ""){
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_5.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((5000 * Int(money)!)))
                        }else{
                            self.lbl_amout_5.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (5000 * 1000))
                            self.textfield_money_5.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_5.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_5.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                    
                }else{
                    self.lbl_amout_5.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.txtDifference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
                
            }).disposed(by: rxbag)
        
        // 2.000
        textfield_money_2.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_2.text?.trim().replacingOccurrences(of: ",", with: ""){
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_2.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((2000 * Int(money)!)))
                        }else{
                            self.lbl_amout_2.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (2000 * 1000))
                            self.textfield_money_2.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_2.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_2.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                }else{
                    self.lbl_amout_2.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.txtDifference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
                
            }).disposed(by: rxbag)
        
        // 1.000
        textfield_money_1.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_1.text?.trim().replacingOccurrences(of: ",", with: ""){
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_1.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((1000 * Int(money)!)))
                            
                        }else{
                            self.lbl_amout_1.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (1000 * 1000))
                            self.textfield_money_1.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_1.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_1.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                    
                }else{
                    self.lbl_amout_1.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.txtDifference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
                
            }).disposed(by: rxbag)
        self.workingSessionValue()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        lbl_branch_name.text = ManageCacheObject.getCurrentUser().branch_name

    }

    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
   
    @IBAction func actionCloseWorkingSession(_ sender: Any) {
        //CALL API CLOSED WORKING SESSION....
        var closeWorkingSessionRequest = CloseWorkingSessionRequest.init()
        closeWorkingSessionRequest.cash_value = setupRealAmount()
        closeWorkingSessionRequest.real_amount = getRealAmount()
        viewModel.closeWorkingSessionRequest.accept(closeWorkingSessionRequest)
        self.closeWorkingSession()
    }
    
    
    func setupRealAmount() -> [CashValue]{
        var cash_values = [CashValue]()
        //500
        if(textfield_money_500.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 500000
            cashValue.quantity = Int(textfield_money_500.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 500000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        //200
        if(textfield_money_200.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 200000
            cashValue.quantity = Int(textfield_money_200.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 200000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        //100
        if(textfield_money_100.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 100000
            cashValue.quantity = Int(textfield_money_100.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 100000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        //50
        if(textfield_money_50.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 50000
            cashValue.quantity = Int(textfield_money_50.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 50000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        
        //20
        if(textfield_money_20.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 20000
            cashValue.quantity = Int(textfield_money_20.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 20000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        
        //10
        if(textfield_money_10.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 10000
            cashValue.quantity = Int(textfield_money_10.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 10000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        //5
        if(textfield_money_5.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 5000
            cashValue.quantity = Int(textfield_money_5.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 5000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        
        //2
        if(textfield_money_2.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 2000
            cashValue.quantity = Int(textfield_money_2.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 2000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        
        //1
        if(textfield_money_1.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 1000
            cashValue.quantity = Int(textfield_money_1.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 1000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
       return cash_values
    }
    func getRealAmount()->Int{
        return Int(lbl_amout_500.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_200.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_100.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_50.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_20.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_10.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_5.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_2.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_1.text!.trim().replacingOccurrences(of: ",", with: ""))!
    }
    
}
