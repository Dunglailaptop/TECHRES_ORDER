//
//  ReviewFoodViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 22/01/2023.
//

import UIKit
import RxSwift
import RxRelay
import ObjectMapper

class ReviewFoodViewModel: BaseViewModel {
    private(set) weak var view: ReviewFoodViewController?
    private var router: ReviewFoodRouter?
       
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : BehaviorRelay<[OrderDetail]> = BehaviorRelay(value: [])
    public var review_data : BehaviorRelay<[Review]> = BehaviorRelay(value: [])
    public var order_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var branch_id : BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    func bind(view: ReviewFoodViewController, router: ReviewFoodRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
    
}
extension ReviewFoodViewModel{
    func reviewFood() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.reviewFood(order_id: order_id.value, review_data: review_data.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    func getFoodsNeedReview() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getFoodsNeedReview(branch_id:branch_id.value,order_id: order_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
