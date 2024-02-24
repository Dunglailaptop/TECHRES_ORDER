//
//  FoodTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 16/01/2023.
//

import UIKit
import RxSwift
import JonAlert
class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_unit_name: UILabel!
    
    @IBOutlet weak var lbl_temporary_price: UILabel!
    @IBOutlet weak var lbl_temporary_unit_name: UILabel!
    
    
    @IBOutlet weak var image_avatar: UIImageView!
    @IBOutlet weak var radioButtonChecked: UIButton!
    @IBOutlet weak var lbl_food_loss: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    
    @IBOutlet weak var btnSub: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var root_action_add_sub_food: UIView!
    
    @IBOutlet weak var root_view_note: UIView!
    @IBOutlet weak var lbl_note: UILabel!
    
//    @IBOutlet weak var constraint_top_image: NSLayoutConstraint!
    
    @IBOutlet weak var img_icon_scale: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnQuantity: UIButton!

    @IBOutlet weak var constraint_height_table_addition_food: NSLayoutConstraint!
    @IBOutlet weak var function_hint_view: UIView!
 
    @IBOutlet weak var constraint_height_of_info_view: NSLayoutConstraint!
    
    
    
    var isFirstime = 0
    var food_addtions = [FoodInCombo]()
    var row = 0
    var addition_food_type = 0 // 0: addtion_food, 1: | combo food| 2: gift food
    var delegate:AdditionDelegate?

    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
//    override func awakeAfter(using coder: NSCoder) -> Any? {
//        dLog("as")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        function_hint_view.roundCorners(corners: [.bottomLeft,.topLeft], radius: CGFloat(6))
        
        //giới hạn chiều rộng cho tên món ăn
        lbl_food_name.translatesAutoresizingMaskIntoConstraints = false
        lbl_food_name.widthAnchor.constraint(lessThanOrEqualToConstant: 160).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func actionSelectedFood(_ sender: Any) {
        
    }
    
  
    var viewModel: AddFoodViewModel? {
       didSet {
          bindViewModel()
           
       }
    }
    
    func bindViewModel(){
        if let viewModel = viewModel{
            registerCell()

        }
    }
   
    
}
extension FoodTableViewCell{
    func registerCell() {
        let extraFoodTableViewCell = UINib(nibName: "ExtraFoodTableViewCell", bundle: .main)
        tableView.register(extraFoodTableViewCell, forCellReuseIdentifier: "ExtraFoodTableViewCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }
}


extension FoodTableViewCell: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.food_addtions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExtraFoodTableViewCell") as! ExtraFoodTableViewCell
        let food_addtion  = self.food_addtions[indexPath.row]
        cell.lbl_food_name.text = food_addtion.name
        cell.lbl_food_price.text =  Utils.stringVietnameseMoneyFormatWithNumber(amount: food_addtion.price)
        if(addition_food_type == FOOD_COMBO){
            cell.btnQuantity.setTitle(String(format: "%d", food_addtion.combo_quantity), for: .normal)
        }else{
            cell.btnQuantity.setTitle(String(format: "%d", food_addtion.quantity), for: .normal)
        }
        
        cell.btnAdd.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                        var value:Float = 0
                           value = Float(cell.btnQuantity.titleLabel!.text!)!
                         if value >= 1000 {
                               return
                           }
                           value = value + 1
                           self?.food_addtions[indexPath.row].quantity = Int(value)
                           self?.food_addtions[indexPath.row].is_selected = ACTIVE
                           self!.tableView.reloadRows(at: [indexPath], with: .none)
                           self?.delegate?.additionQuantity(quantity: Int(value), row: self!.row, itemIndex: indexPath.row, countGift: 0, food_addition_type:self!.addition_food_type)
                       }).disposed(by: cell.disposeBag)
        
        cell.btnSub.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                        var value:Float = 0
                        value = Float(cell.btnQuantity.titleLabel!.text!)!
                        if value > 1{
                            value = value - 1
                        }else{
                            value = 0
                        }
                        self?.food_addtions[indexPath.row].quantity = Int(value)
                        self?.food_addtions[indexPath.row].is_selected = ACTIVE
                        self!.tableView.reloadRows(at: [indexPath], with: .none)
                        self?.delegate?.additionQuantity(quantity: Int(value), row: self!.row, itemIndex: indexPath.row, countGift: 0, food_addition_type:self!.addition_food_type)
                       }).disposed(by: cell.disposeBag)
        
        
        cell.btnCheck.rx.tap.asDriver().drive(onNext: { [weak self] in
            if food_addtion.is_out_stock == ACTIVE {// MÓN ĐÃ HẾT KHÔNG ĐC ORDER
                JonAlert.showError(message: String(format: "Món %@ đã hết bạn không thể order", food_addtion.name))
                return
            }
           var value = 0
           self?.food_addtions[indexPath.row].is_selected = food_addtion.is_selected == ACTIVE ? DEACTIVE : ACTIVE
           if(food_addtion.is_selected == DEACTIVE){
               value = food_addtion.quantity > 0 ? food_addtion.quantity : 1
               self?.food_addtions[indexPath.row].quantity = food_addtion.quantity > 0 ? food_addtion.quantity : 1
               self?.food_addtions[indexPath.row].is_selected = ACTIVE
           }
           self!.tableView.reloadRows(at: [indexPath], with: .none)
           self?.delegate?.additionQuantity(quantity: value, row: self!.row, itemIndex: indexPath.row, countGift: 0, food_addition_type:self!.addition_food_type)
       }).disposed(by: cell.disposeBag)
        
        
        
        if(food_addtion.is_selected == 0){
            cell.btnCheck.setImage(UIImage(named: "un_check_2"), for: .normal)
            if (food_addtion.is_out_stock == ACTIVE){
                cell.btnCheck.setImage(UIImage(named: "icon-check-disable"), for: .normal)
            }
        }else{
            cell.btnCheck.setImage(UIImage(named: "check_2"), for: .normal)
        }
        
        if(self.addition_food_type == FOOD_COMBO){
            cell.btnCheck.isHidden = true
            cell.btnSub.isHidden = true
            cell.btnAdd.isHidden = true
            cell.btnQuantity.isEnabled = false
        }else{
            cell.btnCheck.isHidden = false
            cell.btnSub.isHidden = false
            cell.btnAdd.isHidden = false
            cell.btnQuantity.isEnabled = true
        }
        // kiểm tra món bán kèm hiện có đang hết hay không
        if(food_addtion.is_out_stock == ACTIVE){
            cell.lbl_food_loss.isHidden = false
            cell.btnQuantity.isHidden = true
            cell.lbl_food_loss.text = "hết món".uppercased()
            cell.btnSub.isHidden = true
            cell.btnAdd.isHidden = true
        }else{
            cell.lbl_food_loss.isHidden = true
            cell.lbl_food_loss.text = ""
            cell.btnQuantity.isHidden = false
            cell.btnSub.isHidden = false
            cell.btnAdd.isHidden = false
            if(self.addition_food_type == FOOD_COMBO){
                cell.btnSub.isHidden = true
                cell.btnAdd.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 60
    }
    
}
