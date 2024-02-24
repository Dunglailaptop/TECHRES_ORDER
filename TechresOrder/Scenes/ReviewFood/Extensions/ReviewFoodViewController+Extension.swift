//
//  ReviewFoodViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 22/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert
//MARK: -- CALL API
extension ReviewFoodViewController {
    func getFoodsNeedReview(){
        viewModel.getFoodsNeedReview().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let reviews = Mapper<OrderDetail>().mapArray(JSONObject: response.data) {
                    if(reviews.count > 0){
                        dLog(reviews.toJSONString(prettyPrint: true) as Any)
                        self.viewModel.dataArray.accept(reviews)
                        Utils.isHideAllView(isHide: true, view: self.view_nodata)
                    }else{
                        self.viewModel.dataArray.accept([])
                        Utils.isHideAllView(isHide: false, view: self.view_nodata)
                    }
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    func reviewFood(){
        viewModel.reviewFood().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Đánh giá món ăn thành công...", duration: 2.0)
                self.delegate?.callBackReload()
                self.viewModel.makePopViewController()
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình đánh giá món ăn", duration: 3.0)
            }
         
        }).disposed(by: rxbag)
    }
    
}
