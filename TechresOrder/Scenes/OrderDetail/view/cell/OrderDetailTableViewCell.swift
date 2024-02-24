//
//  OrderDetailTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit
import RxSwift
import JonAlert
class OrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var view_cell: UIView!
    @IBOutlet weak var avatar_food: UIImageView!
    
    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var lbl_addition_food: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    
    @IBOutlet weak var btnQuantity: UIButton!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_note: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var lbl_quantity_status_completed: UILabel!
    
    @IBOutlet weak var lbl_status_confirm: UILabel!
    @IBOutlet weak var btnSub: UIButton!
    
    @IBOutlet weak var lbl_gift_amount: UILabel!
    @IBOutlet weak var root_view_note: UIView!
    @IBOutlet weak var root_view_action_quantity: UIView!
    @IBOutlet weak var root_view_quantity_completed_status: UIView!
    
    @IBOutlet weak var constraint_status_lable: NSLayoutConstraint!
    
    @IBOutlet weak var constraint_food_name_label: NSLayoutConstraint!
    @IBOutlet weak var constraint_gift_view_lable: NSLayoutConstraint!
    
    @IBOutlet weak var constraint_height_note_view: NSLayoutConstraint!
    @IBOutlet weak var root_view_gift: UIView!
    
    @IBOutlet weak var view_color_trailing_scroll: UIView!
    
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero

//        view_color_trailing_scroll.round(with: .both, radius: CGFloat(8))
        view_color_trailing_scroll.roundCorners(corners: [.bottomLeft,.topLeft], radius: CGFloat(6))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel: OrderDetailViewModel? {
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
extension OrderDetailTableViewCell{
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
   
    
    private func bindViewModel() {
           if let viewModel = viewModel {
               
               let font = UIFont(name: "Helvetica", size: 11.5)
               lbl_status_confirm.isHidden = true
               
               if(data?.status == DONE ){
                   if(data!.category_type == TYPE_BEER || data!.category_type == TYPE_OTHER){
                       if(data?.enable_return_beer == DEACTIVE){
                           lbl_status_confirm.isHidden = false
                       }else{
                           lbl_status_confirm.isHidden = true
                       }
                   }
                 
               }
               lbl_food_name.text = data?.name
               if(data?.is_gift == 1){
                   lbl_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: 0)
                   lbl_gift_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data!.price) * data!.quantity)
               }else{
                   if((self.data?.order_detail_additions.count)! > 0){
                       lbl_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount:  data!.total_price_include_addition_foods)
                   }else{
                       lbl_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: data!.total_price)
                   }
               }
               
               if(data?.is_sell_by_weight == ACTIVE){
                   lbl_quantity.text = String(format:"%.2f", data!.quantity)
                   lbl_quantity_status_completed.text = String(format: "%.2f", data?.quantity ?? 0)
               }else{
                   lbl_quantity_status_completed.text = String(format: "%.f", data?.quantity ?? 0)
                   if(data?.category_type == TYPE_BEER || data?.category_type == TYPE_OTHER){
                       lbl_quantity.text = String(format:"%.0f", data!.quantity)
//                       lbl_quantity.text = String(format:"%.0f/%.0f",data!.return_quantity_for_drink,  data!.quantity)
                   }else{
                       lbl_quantity.text = String(format:"%.0f", data!.quantity)
                   }
                   
               }
               
//               lbl_quantity.text = String(format: "%.0f", data?.quantity ?? 0)
               
             
               
               dLog(String(format: "%.f", data?.quantity ?? 0))
              // btnQuantity.setTitle(String(format: "%.f", data?.quantity ?? 0), for: .normal)
              
               let link_image = Utils.getFullMediaLink(string: data?.food_avatar ?? "")
               avatar_food.kf.setImage(with: URL(string: link_image), placeholder: UIImage(named: "image_defauft_medium"))
               root_view_quantity_completed_status.isHidden = false
               if(data?.status == DONE){
                   lbl_status.text = "HOÀN THÀNH".uppercased()
                   lbl_status.textColor = ColorUtils.green_online()
                   Utils.isHideView(isHide: true, view: root_view_action_quantity)
                   Utils.isHideView(isHide: false, view: root_view_quantity_completed_status)
                   self.view_cell.backgroundColor = ColorUtils.white()
                   dLog(data?.category_type)
                   if(data?.category_type == TYPE_BEER || data?.category_type == TYPE_OTHER){
                       dLog(data?.quantity)
                   }
                   
               }else if(data?.status == COOKING){
                   lbl_status.text = "ĐANG CHẾ BIẾN".uppercased()
                   lbl_status.textColor = ColorUtils.blue_color()
                   
                   Utils.isHideView(isHide: true, view: root_view_action_quantity)
                   Utils.isHideView(isHide: false, view: root_view_quantity_completed_status)
                   self.view_cell.backgroundColor = ColorUtils.white()
                   

               }else if(data?.status == PENDING){// món mới đang chờ
                   lbl_status.text = "CHỜ CHẾ BIẾN".uppercased()
                   lbl_status.textColor = ColorUtils.main_color()
                   Utils.isHideView(isHide: false, view: root_view_action_quantity)
                   Utils.isHideView(isHide: true, view: root_view_quantity_completed_status)
                   self.view_cell.backgroundColor = ColorUtils.white()
               }else{
                   lbl_status.text = "ĐÃ HỦY".uppercased()
                   lbl_status.textColor = ColorUtils.red_color()
                   Utils.isHideView(isHide: true, view: root_view_action_quantity)
                   Utils.isHideView(isHide: false, view: root_view_quantity_completed_status)
                   self.view_cell.backgroundColor = ColorUtils.red_spin_color()
               }
               
               if(data?.note.count == 0){
//                   root_view_note.removeAllSubViews()
                   Utils.isHideView(isHide: true, view:root_view_note)
                   constraint_status_lable.constant = 20
               }else{
                   constraint_status_lable.constant = 30
                   Utils.isHideView(isHide: false, view:root_view_note)
                   lbl_note.text = data?.note

               }
               
               if(data?.is_gift == 0){
                   constraint_gift_view_lable.constant = 1
                   Utils.isHideView(isHide: true, view:root_view_gift)
                   
               }else{
                   if(data?.note.count == 0){
                       constraint_gift_view_lable.constant = 10
                       constraint_status_lable.constant = 30
                   }else{
                       constraint_gift_view_lable.constant = 25
                       constraint_status_lable.constant = 60
                   }
                   Utils.isHideView(isHide: false, view:root_view_gift)
                   
               }
               if((self.data?.order_detail_additions.count)! > 0){
                   var string = "[Món bán kèm]\n"
                   for i in 0..<(self.data?.order_detail_additions.count)! - 1 {
                       let item = self.data?.order_detail_additions[i]
                       string = string + "+ " + item!.name + " x " + String(item!.quantity) + " = " + String(item!.price) + "\n"
                   }
                   
                   let item = self.data?.order_detail_additions.last
                   string = string + "+ " + item!.name +  " x " + String(item!.quantity) +  " = " + String(item!.price)
                   lbl_addition_food.text = string
                   
                   if(self.data?.note == ""){
                       if(data?.is_gift == ACTIVE){
                        
                           constraint_gift_view_lable.constant = heightForLabel(text: String.init(format: "%@",string), font: font!, width: 250)
                           constraint_status_lable.constant = 35 + heightForLabel(text: String.init(format: "%@",string), font: font!, width: 250)
                       }else{
                           constraint_gift_view_lable.constant = heightForLabel(text: String.init(format: "%@",string), font: font!, width: 250)
                           constraint_status_lable.constant = 5 + heightForLabel(text: String.init(format: "%@",string), font: font!, width: 250)
                       }
                       constraint_height_note_view.constant =  0
                   }else{
                       constraint_height_note_view.constant =  heightForLabel(text: String.init(format: "%@",string), font: font!, width: 250)
                       
                       if(data?.is_gift == ACTIVE){
                          
                           constraint_gift_view_lable.constant = 20 + heightForLabel(text: String.init(format: "%@",data?.note ?? ""), font: font!, width: 250) + heightForLabel(text: String.init(format: "%@",string), font: font!, width: 250)
                           constraint_status_lable.constant = 50 + heightForLabel(text: String.init(format: "%@",data?.note ?? ""), font: font!, width: 250) + heightForLabel(text: String.init(format: "%@",string), font: font!, width: 250)
                       }else{
                           constraint_gift_view_lable.constant = heightForLabel(text: String.init(format: "%@",data?.note ?? ""), font: font!, width: 250) + heightForLabel(text: String.init(format: "%@",string), font: font!, width: 250)
                           constraint_status_lable.constant = 5 + heightForLabel(text: String.init(format: "%@",data?.note ?? ""), font: font!, width: 250) + heightForLabel(text: String.init(format: "%@",string), font: font!, width: 250)
                       }
                   }

                   
               }else if((self.data?.order_detail_combo.count)! > 0){// món combo
                   var string = ""
                   for i in 0..<(self.data?.order_detail_combo.count)! - 1 {
                       let item = self.data?.order_detail_combo[i]
                       string = string + "+ " + item!.name + " x " + String(item!.quantity) + "\n"//+ " = " +
                   }
                   
               
                   
                   let item = self.data?.order_detail_combo.last
                   string = string + "+ " + item!.name +  " x " + String(item!.quantity)
                   lbl_addition_food.text = string
                   
                   constraint_height_note_view.constant =  heightForLabel(text: String.init(format: "%@",string), font: font!, width: 200)
                   
                   
                   if(data?.note.count == 0){
                       if(data?.is_gift == ACTIVE){
                           constraint_gift_view_lable.constant = heightForLabel(text: String.init(format: "%@",string), font: font!, width: 200) + heightForLabel(text: String.init(format: "%@",lbl_gift_amount.text!), font: font!, width: 200) - 20
                           constraint_status_lable.constant = 12 + heightForLabel(text: String.init(format: "%@",string), font: font!, width: 200)
                           constraint_food_name_label.constant = 5
                       }else{
                           constraint_gift_view_lable.constant = 0
                           constraint_status_lable.constant = 8 + heightForLabel(text: String.init(format: "%@",string), font: font!, width: 200)
                       }
                       
                   }else{
                       if(data?.is_gift == ACTIVE){
                           constraint_gift_view_lable.constant = heightForLabel(text: String.init(format: "%@",string), font: font!, width: 200) + heightForLabel(text: String.init(format: "%@",lbl_gift_amount.text!), font: font!, width: 200) + 15
                           constraint_status_lable.constant = 55 + heightForLabel(text: String.init(format: "%@",string), font: font!, width: 200)
                       }else{
                           constraint_gift_view_lable.constant = 0
                           constraint_status_lable.constant = 35 + heightForLabel(text: String.init(format: "%@",string), font: font!, width: 200)
                       }
                   }
                   
                   
                 
                   
               }else{
                   lbl_addition_food.text = ""
                   if(data?.note.count == 0){
                       if(data?.is_gift == ACTIVE){
                           constraint_gift_view_lable.constant = 0
                           constraint_status_lable.constant = 25
                           constraint_food_name_label.constant = 20
                       }else{
                           constraint_gift_view_lable.constant = 0
                           constraint_status_lable.constant = 15
                       }
                   }else{
                       if(data?.is_gift == ACTIVE){
                           constraint_height_note_view.constant = 0
                           constraint_gift_view_lable.constant = 20 + heightForLabel(text: String.init(format: "%@",data?.note ?? ""), font: font!, width: 250)
                           constraint_status_lable.constant = 50 +  heightForLabel(text: String.init(format: "%@",data?.note ?? ""), font: font!, width: 250)
                       }else{
                           constraint_height_note_view.constant = 0
                           constraint_gift_view_lable.constant = 0
                           constraint_status_lable.constant =  25 +  heightForLabel(text: String.init(format: "%@",data?.note ?? ""), font: font!, width: 250)
                       }
                   }
               }
               
               
               btnAdd.rx.tap.asDriver()
                              .drive(onNext: { [weak self] in
                                  if(self!.data?.is_gift != 1 && self!.data?.is_combo != 1){// món tặng & combo không được phép chỉnh sửa số lượng
                                      var foods = self?.viewModel!.dataArray.value
                                      var is_selected = 0
                                      var quantity = self!.data?.quantity
                                    
                                      if(self!.data?.is_sell_by_weight == ACTIVE){
                                          quantity = quantity! + 0.01
                                      }else{
                                          quantity! += 1
                                      }
                                      quantity = quantity! >= 1000 ? 1000 : quantity
                                      
                                      
                                      foods!.enumerated().forEach { (index, value) in
                                          if(self!.data?.id == value.id){
                                              foods![index].quantity = quantity!
                                              foods![index].isChange = 1
                        
                                          }
                                      }
                                      viewModel.dataArray.accept(foods!)
                                      
                                      viewModel.isChange.accept(1)
                                  }else{
                                      
                                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GIFT_FOOD_NOTE_UPDATE_QUANTITY"), object: nil)
                                      
                                  }
                                  
                              }).disposed(by: disposeBag)
//               
             
               
               btnSub.rx.tap.asDriver()
                              .drive(onNext: { [weak self] in
                                  if(self!.data?.is_gift != 1 && self!.data?.is_combo != 1){// món tặng & combo không được phép chỉnh sửa số lượng
                                      var foods = self?.viewModel!.dataArray.value
                                      var quantity = self!.data?.quantity
                                    
//                                      var quantity = self!.data?.quantity
                                    
                                      if(self!.data?.is_sell_by_weight == ACTIVE){
                                          quantity = quantity! - 0.01
                                      }else{
                                          quantity! -= 1
                                      }
                                      
                                      foods!.enumerated().forEach { (index, value) in
                                          if(self!.data?.id == value.id){
                                              
                                              if(quantity! > 0){
                                                  foods![index].quantity = quantity!
                                                  foods![index].isChange = 1
                                              }else{
                                                  foods![index].quantity = 1
                                              }
                                            
                                          }
                                      }
                                      if(quantity! <= 0){
                                          let orderDetailIdDataDict:[String: Int] = ["order_detail_id": self!.data?.id ?? 0, "is_extra_charge": self!.data?.is_extra_Charge ?? 0, "quantity": Int(self!.data!.quantity)]

//                                          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CANCEL_FOOD"), object: nil, userInfo: orderDetailIdDataDict)
                                          JonAlert.showError(message: "Số lượng tối thiểu là 1", duration: 2.0)

                                      }
                                      
                                     viewModel.dataArray.accept(foods!)
                                     viewModel.isChange.accept(1)
                                      
                                  }else{
                                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GIFT_FOOD_NOTE_UPDATE_QUANTITY"), object: nil)
                                  }
                                  
                              }).disposed(by: disposeBag)
           }
       }
}
