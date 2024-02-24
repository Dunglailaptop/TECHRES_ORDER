//
//  SplitFoodTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import RxSwift

class SplitFoodTableViewCell: UITableViewCell {
    @IBOutlet weak var quantity_txt: UITextField!
    @IBOutlet weak var quantity_lbl: UILabel!
    @IBOutlet weak var food_name_lbl: UILabel!
    @IBOutlet weak var btnSub: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnQuantity: UIButton!
    
    @IBOutlet weak var gift_icon: UIImageView!
    
    @IBOutlet weak var lbl_food_additions: UILabel!
    
    @IBOutlet weak var lbl_title_food_additions: UILabel!
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    var viewModel: SplitFoodViewModel? {
           didSet {
               bindViewModel()
           }
    }
    
    // MARK: - Variable -
       public var data: OrderDetail? = nil {
           didSet {
               
           }
       }
    
    
}
extension SplitFoodTableViewCell{

    private func bindViewModel() {
           if let viewModel = viewModel {

               let isChange = data?.isChange ?? 0
               let quantity = data?.quantity ?? 0
               let font = UIFont(name: "Helvetica", size: 10)
               gift_icon.isHidden = data!.is_gift == 1 ? false : true
               if(data!.is_sell_by_weight == ACTIVE){
                  
                   if(quantity - isChange > 0){
                       quantity_lbl.text = String(format: "%.2f", quantity - isChange)
                   }else{
                       quantity_lbl.text = String(format: "%.0f", quantity - isChange)
                   }
                  
                   if(data!.isChange > 0){
                       quantity_txt.text = String(format: "%.2f", data!.isChange)
                   }else{
                       quantity_txt.text = String(format: "%.0f", data!.isChange)
                   }
               }else{
                   quantity_lbl.text = String(format: "%.0f", quantity - isChange)
                   quantity_txt.text = String(format: "%.0f", data!.isChange)
               }
               lbl_title_food_additions.isHidden = true
               food_name_lbl.text = data?.name
               if((self.data?.order_detail_additions.count)! > 0){
                   lbl_title_food_additions.isHidden = false
//                   var string = "[Món bán kèm]\n"
                   var string = ""
                   for i in 0..<(self.data?.order_detail_additions.count)! - 1 {
                       let item = self.data?.order_detail_additions[i]
                       string = string + "+ " + item!.name + " x" + "\(Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(item?.quantity ?? 0)))" + " = " + "\(Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(item?.price ?? 0)))" + "\n"
                   }
                   
                   let item = self.data?.order_detail_additions.last
                   string = string + "+ " + item!.name +  " x" + "\(Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(item?.quantity ?? 0)))" +  " = " + "\(Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(item?.price ?? 0)))"
                   lbl_food_additions.text = string
                   
               }else if((self.data?.order_detail_combo.count)! > 0){// món combo
                   var string = ""
                   for i in 0..<(self.data?.order_detail_combo.count)! - 1 {
                       let item = self.data?.order_detail_combo[i]
                       string = string + "+ " + item!.name + " x" + "\(Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(item?.quantity ?? 0)))" + " Phần" + "\n"//+ " = " +
                   }

                   let item = self.data?.order_detail_combo.last
                   string = string + "+ " + item!.name +  " x" + "\(Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(item?.quantity ?? 0)))" + " Phần"
                   lbl_food_additions.text = string

               }else{
                   lbl_food_additions.text = ""
               }
               
               if(data!.isChange != 0){
                   food_name_lbl.textColor = ColorUtils.blue()
               }else{
                   food_name_lbl.textColor = ColorUtils.black()
               }
               
               
               btnSub.rx.tap.asDriver()
                              .drive(onNext: { [weak self] in
                                  var quantity = self!.data?.quantity
                                  var quantity_change = self!.data?.isChange
                                  var food_quantity = self!.data?.food_quantity
                                  
                                  if(self!.data?.is_sell_by_weight == 1){// nếu là hải sản bán theo kg thì chuyển hết số lượng 1 lần
                                      if(quantity_change! > 0){
                                          quantity_change = Float(quantity_change!) - Float(quantity!)
                                          quantity = 0
                                      }
                                  }else{
                                      if(quantity_change! > 0){
                                          quantity_change = Float(quantity_change!) - 1
                                          food_quantity = Float(quantity!) - Float(quantity_change!)
                                      }
                                  }
                                  var foods = self?.viewModel!.dataArray.value
                                  foods!.enumerated().forEach { (index, value) in
                                      if(self!.data?.id == value.id){
                                          foods![index].isChange = quantity_change!
                                          foods![index].food_quantity = food_quantity!
                                      }
                                  }
                                  viewModel.dataArray.accept(foods!)
                                 
                                  
                              }).disposed(by: disposeBag)
               
               
               btnAdd.rx.tap.asDriver()
                              .drive(onNext: { [weak self] in
                                  var quantity = self!.data?.quantity
                                  var quantity_change = self!.data?.isChange
                                  var food_quantity = self!.data?.food_quantity
                                  
                                  if(self!.data?.is_sell_by_weight == ACTIVE){// nếu là hải sản bán theo kg thì chuyển hết số lượng 1 lần
                                      if(quantity_change! < quantity!){
                                          quantity_change = Float(quantity_change!) + Float(quantity!)
                                      }
                                  }else{
                                      if(quantity_change! < quantity!){
                                          quantity_change = Float(quantity_change!) + 1
                                          food_quantity = Float(quantity!) - Float(quantity_change!)
                                      }
                                  }
                                  var foods = self?.viewModel!.dataArray.value
                                  foods!.enumerated().forEach { (index, value) in
                                      if(self!.data?.id == value.id){
                                          foods![index].isChange = quantity_change!
                                          foods![index].food_quantity = food_quantity!
                                      }
                                  }
                                  dLog(foods!.toJSON())
                                  viewModel.dataArray.accept(foods!)
                                 
                                  
                              }).disposed(by: disposeBag)
               
           }
    }
}
