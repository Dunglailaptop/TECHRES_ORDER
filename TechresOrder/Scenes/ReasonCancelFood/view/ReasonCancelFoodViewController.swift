//
//  ReasonCancelFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import ObjectMapper
import JonAlert
class ReasonCancelFoodViewController: BaseViewController {
    var viewModel = ReasonCancelFoodViewModel()
    var router = ReasonCancelFoodRouter()
    @IBOutlet weak var tableView: UITableView!
    var delegate:ReasonCancelFoodDelegate?
    var branch_id = 0
    var order_detail_id = 0
    var reason = ReasonCancel.init()
    var is_extra_charge = 0
    var quantity = 0
    
    @IBOutlet weak var root_view: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        root_view.round(with: .both, radius: 8)
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        viewModel.branch_id.accept(self.branch_id)
        registerCell()
        binđDataTableView()
        
        //CALL API GET DATA
        reasonCancelFoods()
        
    }
    
    //MARK: Register Cells as you want
    func registerCell(){
      
        let reasonCancelFoodTableViewCell = UINib(nibName: "ReasonCancelFoodTableViewCell", bundle: .main)
        tableView.register(reasonCancelFoodTableViewCell, forCellReuseIdentifier: "ReasonCancelFoodTableViewCell")
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: rxbag)
        
       
        tableView.rx.modelSelected(ReasonCancel.self) .subscribe(onNext: { element in
            print("Selected \(element)")
            self.resetSelectedReasonCancelFood()
            self.reason = element
            var reasons = self.viewModel.dataArray.value
            reasons.enumerated().forEach { (index, value) in
                if(element.id == value.id){
                    reasons[index].is_select = ACTIVE
                }else{
                    reasons[index].is_select = DEACTIVE
                }
            }
            self.viewModel.dataArray.accept(reasons)
        })
        .disposed(by: rxbag)
        
    }
    func resetSelectedReasonCancelFood(){
        var reasons = self.viewModel.dataArray.value
        reasons.enumerated().forEach { (index, value) in
                reasons[index].is_select = 0
            
        }
        self.viewModel.dataArray.accept(reasons)
    }
    func reasonCancelFoodSelected(){
        let reasons = self.viewModel.dataArray.value
        reasons.enumerated().forEach { (index, value) in
            if(value.is_select == 1){
                reason = value
            }
        }
    }
    
    func binđDataTableView(){
     
        viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "ReasonCancelFoodTableViewCell", cellType: ReasonCancelFoodTableViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }
    
    

    @IBAction func actionApprovedCancelFood(_ sender: Any) {
        reasonCancelFoods()
        if(self.reason!.content.count > 0){
            delegate?.callBackReasonCancelFood(order_detail_id: order_detail_id, is_extra_charge:is_extra_charge, reason:self.reason!, quantity: self.quantity)
            self.navigationController?.dismiss(animated: true)
        }else{
//            Toast.show(message: "Vui lòng chọn lý do hủy món", controller: self)
            JonAlert.showError(message: "Vui lòng chọn lý do hủy món", duration: 2.0)
        }
       
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
}
extension ReasonCancelFoodViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ReasonCancelFoodViewController{
    func reasonCancelFoods(){
        viewModel.reasonCancelFoods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Reason Cancel Foods Success...")
                if let reasonCancel  = Mapper<ReasonCancel>().mapArray(JSONObject: response.data){
                    dLog(reasonCancel.toJSON())
                    self.viewModel.dataArray.accept(reasonCancel)
                }
            }
        }).disposed(by: rxbag)
        
    }
}
