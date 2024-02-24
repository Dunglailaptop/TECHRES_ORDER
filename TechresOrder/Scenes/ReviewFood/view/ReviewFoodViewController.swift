//
//  ReviewFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 22/01/2023.
//

import UIKit
import RxSwift
import JonAlert

class ReviewFoodViewController: BaseViewController {
    var viewModel = ReviewFoodViewModel()
    var router = ReviewFoodRouter()
    var order_id = 0
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var view_nodata: UIView!
    @IBOutlet weak var root_view: UIView!
    
    @IBOutlet weak var constraint_height_root_view: NSLayoutConstraint!
    
    var delegate:TechresDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        root_view.roundCorners(corners: .allCorners, radius: 20)
        
        viewModel.bind(view: self, router: router)
        registerCell()
        bindTableViewData()
        Utils.isHideAllView(isHide: true, view: self.view_nodata)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        dLog(order_id)
        viewModel.order_id.accept(self.order_id)
        getFoodsNeedReview()

    }

    @IBAction func actionReview(_ sender: Any) {
        var data_reviews = [Review]()
        
        for food in viewModel.dataArray.value {
            if(food.review_score != 0){
                var reviewData = Review.init()
                reviewData?.note = food.note
                reviewData?.score = food.review_score
                reviewData?.order_detail_id = food.id
                data_reviews.append(reviewData!)
                
            }
        }
        viewModel.review_data.accept(data_reviews)
        
        if(data_reviews.count > 0){
            self.reviewFood()
        }else{
            JonAlert.showError(message: "Bạn hãy chọn mức độ hài lòng của món ăn trước khi thực hiện việc đánh giá", duration: 3.0)
        }
        
        
       
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let adjustedKeyboardFrame = view.convert(keyboardFrame, from: nil)
            let intersection = view.frame.intersection(adjustedKeyboardFrame)
            let keyboardHeight = intersection.size.height

            // Thay đổi vị trí của root_view để nó di chuyển lên trên bàn phím
            root_view.frame.origin.y = view.frame.height - keyboardHeight * 0.85 - root_view.frame.height
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        // Đặt lại vị trí ban đầu của root_view khi bàn phím ẩn đi
        root_view.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
}
extension ReviewFoodViewController{
        func registerCell() {
            let reviewFoodTableViewCell = UINib(nibName: "ReviewFoodTableViewCell", bundle: .main)
            tableView.register(reviewFoodTableViewCell, forCellReuseIdentifier: "ReviewFoodTableViewCell")
            
            self.tableView.estimatedRowHeight = 170
            self.tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            tableView
                .rx.setDelegate(self)
                .disposed(by: rxbag)
          
            
        }
}

extension ReviewFoodViewController{
    
    private func bindTableViewData() {
        viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "ReviewFoodTableViewCell", cellType: ReviewFoodTableViewCell.self))
        { [self]  (row, orderDetail, cell) in
            cell.data = orderDetail
            cell.viewModel = self.viewModel
            
            cell.textfield_comment.rx.controlEvent(.editingDidEnd)
                .throttle(.milliseconds(2000), scheduler: MainScheduler.instance)
                .withLatestFrom(cell.textfield_comment.rx.text)
                .subscribe(onNext:{ query in
                    var orderDetails = self.viewModel.dataArray.value
                    orderDetails.enumerated().forEach { (index, value) in
                        if(orderDetail.id == value.id){
                            orderDetails[index].note = cell.textfield_comment.text ?? ""
                        }
                    }
                    self.viewModel.dataArray.accept(orderDetails)
                    
                }).disposed(by: cell.disposeBag)
            /*
             
             cell.textfield_comment.rx.controlEvent([.editingChanged])
             .asObservable().subscribe({ [unowned self] _ in
             print("My text : \(cell.textfield_comment.text ?? "")")
             
             var orderDetails = self.viewModel.dataArray.value
             orderDetails.enumerated().forEach { (index, value) in
             if(orderDetail.id == value.id){
             orderDetails[index].note = cell.textfield_comment.text ?? ""
             }
             }
             self.viewModel.dataArray.accept(orderDetails)
             
             }).disposed(by: cell.disposeBag)
             */
            var score = 0
            cell.btn_very_good.rx.tap.asDriver()
                .drive(onNext: { [weak self] in
                    score = 3
                    
                    var order_details = self!.viewModel.dataArray.value
                    order_details.enumerated().forEach { (index, value) in
                        if(orderDetail.id == value.id){
                            order_details[index].review_score = score
                        }
                    }
                    self!.viewModel.dataArray.accept(order_details)
                    dLog(score)
                }).disposed(by: cell.disposeBag)
            
            cell.btn_good.rx.tap.asDriver()
                .drive(onNext: { [weak self] in
                    score = 2
                    
                    var order_details = self!.viewModel.dataArray.value
                    order_details.enumerated().forEach { (index, value) in
                        if(orderDetail.id == value.id){
                            order_details[index].review_score = score
                        }
                    }
                    self!.viewModel.dataArray.accept(order_details)
                    dLog(score)
                }).disposed(by: cell.disposeBag)
            
            cell.btn_normal.rx.tap.asDriver()
                .drive(onNext: { [weak self] in
                    score = 1
                    
                    var order_details = self!.viewModel.dataArray.value
                    order_details.enumerated().forEach { (index, value) in
                        if(orderDetail.id == value.id){
                            order_details[index].review_score = score
                        }
                    }
                    self!.viewModel.dataArray.accept(order_details)
                    dLog(score)
                }).disposed(by: cell.disposeBag)
            
            cell.btn_bad.rx.tap.asDriver()
                .drive(onNext: { [weak self] in
                    score = -2
                    
                    var order_details = self!.viewModel.dataArray.value
                    order_details.enumerated().forEach { (index, value) in
                        if(orderDetail.id == value.id){
                            order_details[index].review_score = score
                        }
                    }
                    self!.viewModel.dataArray.accept(order_details)
                    dLog(score)
                }).disposed(by: cell.disposeBag)
            
            cell.btn_very_bad.rx.tap.asDriver()
                .drive(onNext: { [weak self] in
                    score = -3
                    
                    var order_details = self!.viewModel.dataArray.value
                    order_details.enumerated().forEach { (index, value) in
                        if(orderDetail.id == value.id){
                            order_details[index].review_score = score
                        }
                    }
                    self!.viewModel.dataArray.accept(order_details)
                    dLog(score)
                }).disposed(by: cell.disposeBag)
            
            
        }.disposed(by: rxbag)
    }
}
extension ReviewFoodViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(viewModel.dataArray.value[indexPath.row].review_score < 0){
            return 100
        }else{
            return 100
        }
       
    }
}
