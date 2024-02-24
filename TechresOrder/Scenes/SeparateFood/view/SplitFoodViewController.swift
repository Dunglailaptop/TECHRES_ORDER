//
//  SplitFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import ObjectMapper
import JonAlert
class SplitFoodViewController: BaseViewController {
    var viewModel = SplitFoodViewModel()
    var router = SplitFoodRouter()
    var order_details = [OrderDetail]()

    @IBOutlet weak var root_view: UIView!
    
    var branch_id = 0
    var order_id = 0
    var destination_table_id = 0
    var destination_table_name = ""
    var target_table_name = ""

    var target_table_id = 0
    var target_order_id = 0
    var delegate:TechresDelegate?
    var only_one = 0
    @IBOutlet weak var lbl_title_move_food: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //root_view.round(with: .both, radius: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissController(_:)), name: NSNotification.Name(rawValue: "DISMISS_CONTROLLER"), object: nil)
        
        viewModel.bind(view: self, router: router)
       
      let food_status =  String(format: "%d,%d,%d", PENDING, COOKING, DONE)
        viewModel.food_status.accept(food_status)
        
        registerCell()
        bindTableViewData()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        dLog(order_id)
        dLog(branch_id)
        
        lbl_title_move_food.text = String(format: "TÁCH MÓN TỪ %@ SANG %@", destination_table_name, target_table_name)

        
        viewModel.order_id.accept(order_id)
        viewModel.branch_id.accept(branch_id)
        
        dLog(only_one)
        if(only_one == ACTIVE){
            self.viewModel.dataArray.accept(self.order_details)
        }else{
            getOrdersNeedMove()
        }
        
    }
//    override func viewDidAppear(_ animated: Bool) {
//        dLog(order_id)
//        dLog(branch_id)
//        viewModel.order_id.accept(order_id)
//        viewModel.branch_id.accept(branch_id)
//        getOrdersNeedMove()
//    }
    @objc func  dismissController(_ notification: Notification) {
//        Toast.show(message: "Món tặng không được phép thay đổi số lượng", controller: self)
        JonAlert.showError(message: "Món tặng không được phép thay đổi số lượng", duration: 2.0)
        self.navigationController?.dismiss(animated: true)
    }
    

    @IBAction func actionSave(_ sender: Any) {
        viewModel.destination_table_id.accept(self.destination_table_id)
        viewModel.target_table_id.accept(self.target_table_id)
        
        self.repairSplitFoods()
        
        if(self.viewModel.foods_move.value.count > 0 || self.viewModel.foods_extra_move.value.count > 0){
            if(self.viewModel.foods_move.value.count > 0){
                self.moveFoods()
            }
            if(self.viewModel.foods_extra_move.value.count > 0){
                viewModel.target_order_id.accept(self.target_order_id)
                self.moveExtraFoods()
            }
            self.navigationController?.dismiss(animated: true)
        }else{
//            Toast.show(message: "Hãy chọn món cần tách trước khi lưu lại.", controller: self)
            JonAlert.showError(message: "Hãy chọn món cần tách trước khi lưu lại!", duration: 2.0)
        }
        
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
  

}

//MARK : CALL API
extension SplitFoodViewController{
    func getOrdersNeedMove(){
        dLog(self.viewModel.order_id.value)
        viewModel.getOrdersNeedMove().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get order need move Success...")
                if let orderDetailData  = Mapper<OrderDetailData>().map(JSONObject: response.data){
                    dLog(orderDetailData.toJSON())
                    self.viewModel.dataArray.accept(orderDetailData.order_details)
                }

            }
        }).disposed(by: rxbag)
        
    }
    
    func moveFoods(){
        viewModel.moveFoods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Move Success...")
                self.delegate?.callBackReload()
                self.navigationController?.dismiss(animated: true)
                JonAlert.showSuccess(message: "Tách món thành công.", duration: 2.0)
            }else{
                JonAlert.showError(message: "Bàn ở trạng thái setup, vui lòng không thao tác.", duration: 2.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    func moveExtraFoods(){
        viewModel.moveExtraFoods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Move Success...")
                self.delegate?.callBackReload()
                self.navigationController?.dismiss(animated: true)
                JonAlert.showSuccess(message: "Tách món thành công.", duration: 2.0)
            }else{
                JonAlert.showError(message: "Phụ thu không được chuyển sang bàn chưa có hóa đơn.", duration: 2.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    
}
