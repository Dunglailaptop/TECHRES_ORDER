//
//  FeeViewController+Extension+CallAPI.swift
//  ORDER
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 16/06/2023.
//

import UIKit
import RxSwift
import ObjectMapper

//MARK: CALL API
extension FeeViewController{
    
    func fees(){
        self.other_fees.removeAll()
        self.other_fees = [Fee]()
        self.material_fees.removeAll()
        self.material_fees = [Fee]()
        
        viewModel.fees().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let feeResponse = Mapper<FeeData>().map(JSONObject: response.data) {
                    if(feeResponse.fees!.count > 0){
                        
                        if let fees = feeResponse.fees?.filter({(element) in element.addition_fee_status == 2}), fees != nil{
                            var total_material_fee:Float = 0.0
                            var total_other_fee:Float = 0.0
                            
                            for fee in fees {
                                if(fee.addition_fee_reason_type_id == 16){// Chi phí NVL
                                    self.material_fees.append(fee)
                                    total_material_fee += Float(fee.amount)
                                }else {// Chi phí khác
                                    self.other_fees.append(fee)
                                    total_other_fee += Float(fee.amount)
                                }
                            }
                            self.viewModel.material_fee_total_amount.accept(Float(total_material_fee))
                            self.viewModel.other_fee_total_amount.accept(Float(total_other_fee))
                            self.viewModel.fee_total_amount.accept(Float(total_other_fee + total_material_fee))
                            self.viewModel.materialFees.accept(self.material_fees)
                            self.viewModel.otherFees.accept(self.other_fees)
                        }
                        
                    }else{
                        self.viewModel.material_fee_total_amount.accept(Float(0))
                        self.viewModel.other_fee_total_amount.accept(Float(0))
                        self.viewModel.fee_total_amount.accept(Float(0))
                        self.viewModel.materialFees.accept([])
                        self.viewModel.otherFees.accept([])
                    }
                    self.viewModel.dataSectionArray.accept([0,1,2])
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
}
