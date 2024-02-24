//
//  AddFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 16/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper
import JonAlert
import RSRealmHelper
import RxSwift
import RxRelay
import RxSwiftExt

class AddFoodViewController: BaseViewController {
    var viewModel = AddFoodViewModel()
    var router = AddFoodRouter()
    var foods = [Food]()
    var key_word = ""
    var order_id = 0
    var booking_status = 0
    var branch_id = ManageCacheObject.getCurrentBranch().id
    var area_id = 0
    var category_id = -1
    var category_type = 1
    var is_sell_by_weight = 0
    var is_out_stock = 0
    var food_type = 1
    var table_name = ""
    var is_gift = 0 // 0 = gọi món bình thường | 1 = Tặng món vào hoá đơn| -1 Cả hai
    var table_id = 0
    var is_order = 0
    var cellHavingTwoTextLine = -1
    
    weak var timer: Timer?
    var isMessageShowing = false
    let refreshControl = UIRefreshControl()
   
    
    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var view_nodata_order: UIView! // hiển thị icon không có dữ liệu
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var child_view_btn_filter_food: UIView!
    @IBOutlet weak var child_view_btn_filter_drink: UIView!
    @IBOutlet weak var child_view_btn_filter_other: UIView!
    @IBOutlet weak var child_view_btn_filter_cancel_food: UIView!
    @IBOutlet weak var parent_view_btn_filter_cancle_food: UIView!
    @IBOutlet weak var parent_view_btn_filter_drink: UIView!
    @IBOutlet weak var parent_view_btn_filter_food: UIView!
    @IBOutlet weak var prarent_view_btn_filter_other: UIView!
    
    @IBOutlet weak var btnFilterFood: UILabel!
    @IBOutlet weak var btnFilterDrink: UILabel!
    @IBOutlet weak var btnFilterOther: UILabel!
    @IBOutlet weak var btnFilterCancelFood: UILabel!
    
    @IBOutlet weak var textfield_search: UITextField!
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var root_view_bottom_action: UIView! 
    @IBOutlet weak var constraint_height_buttom_view_action: NSLayoutConstraint!
    
    
    @IBOutlet weak var view_clear_search: UIView!
    
    let spinner = UIActivityIndicatorView(style: .medium)
    var lastPosition = false
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_header.text = String(format: is_gift == ACTIVE ? "TẶNG MÓN - %@" : "GỌI MÓN - %@" , table_name)
        view_clear_search.isHidden = true
        view_nodata_order.isHidden = true
 

        viewModel.bind(view: self, router: router)
        viewModel.is_sell_by_weight.accept(-1)
        viewModel.category_type.accept(-1)
        // ktra nếu không phải  GPBH03 thì ẩn tab hết món đi
        if(ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_THREE){
            Utils.isHideAllView(isHide: true, view: parent_view_btn_filter_cancle_food)
        }
        if(ManageCacheObject.getSetting().branch_type != BRANCH_TYPE_LEVEL_ONE){
            viewModel.is_allow_employee_gift.accept(is_gift == ACTIVE ? is_gift : ALL)
        }
        
        
        
        is_order = order_id > 0 ? ACTIVE : DEACTIVE
        registerCell()
        bindTableViewData()
        bindData()
      
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UItableViewController
        /*
            Chỉ duy nhất 1 trường hợp là bàn booking mà ở trạng thái đã set up thì chỉ được order món nước và khác, các trường hợp còn lại thì thực hiện actionFilterFood
         */
        if booking_status == STATUS_BOOKING_SET_UP {
            actionFilterDrink(1)
            parent_view_btn_filter_food.isHidden = true
            prarent_view_btn_filter_other.isHidden = false
        }else{
            self.viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
            self.viewModel.restaurant_brand_id.accept(ManageCacheObject.getCurrentBrand().id)
            self.healthCheckDataChangeFromServer()
//            fetFoods()
        }
        
   
        textfield_search.rx.controlEvent([.editingChanged])
                .asObservable().subscribe({ [unowned self] _ in
                    print("My text : \(self.textfield_search.text ?? "")")
//                    let foods = self.viewModel.allFoods.value
                   
                    if !self.textfield_search.text!.isEmpty{
                        view_clear_search.isHidden = false
                        self.viewModel.category_type.accept(ALL)
                        let foods_filter  = ManagerRealmHelper.shareInstance().getFoodLimit(category_type: ALL, is_allow_employee_gift:ALL,is_out_stock: ALL, keyword: key_word, area_id: self.area_id, offset: self.page, limit: self.viewModel.limit.value).filter({ $0.normalize_name.lowercased().range(of: self.textfield_search.text!, options: .caseInsensitive) != nil || $0.prefix.lowercased().range(of: self.textfield_search.text!, options: .caseInsensitive) != nil || $0.name.lowercased().range(of: self.textfield_search.text!, options: .caseInsensitive) != nil
                            
                        })
                           
                        
//                        let foods_filter = ManagerRealmHelper.shareInstance().getFoodsByKeywords(keyword: self.textfield_search.text!, area_id: self.area_id).filter({ $0.normalize_name.lowercased().range(of: self.textfield_search.text!, options: .caseInsensitive) != nil || $0.prefix.lowercased().range(of: self.textfield_search.text!, options: .caseInsensitive) != nil || $0.name.lowercased().range(of: self.textfield_search.text!, options: .caseInsensitive) != nil
//
//                        })
                        
//                        let foods_filter = foods.filter({ $0.normalize_name.lowercased().range(of: self.textfield_search.text!, options: .caseInsensitive) != nil || $0.prefix.lowercased().range(of: self.textfield_search.text!, options: .caseInsensitive) != nil || $0.name.lowercased().range(of: self.textfield_search.text!, options: .caseInsensitive) != nil})
//                        self.viewModel.dataArray.accept(foods_filter)
                        
                        
                        self.foods = foods_filter
                        self.tableView.reloadData()
                        dLog(foods_filter)
                    }else{
                        dLog(foods.toJSON())
                        let foodAll  = ManagerRealmHelper.shareInstance().getFoodLimit(category_type: ALL, is_allow_employee_gift:ALL,is_out_stock: ALL, keyword: key_word, area_id: self.area_id, offset: self.page, limit: self.viewModel.limit.value)

                        self.foods = foodAll
                        self.viewModel.dataArray.accept(foods)
                        
                        self.tableView.reloadData()
                    }
                }).disposed(by: rxbag)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { [weak self] _ in
            self!.isMessageShowing = false
        }
        
        NotificationCenter.default
                          .addObserver(self,
                                       selector: #selector(syncDataSuccess),
                         name: NSNotification.Name ("vn.techres.sync.food"), object: nil)


        
    }
    
    deinit{
        timer?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    @objc func refresh(_ sender: AnyObject) {
          // Code to refresh table view
        self.page = 1
        self.viewModel.dataArray.accept([])
        
        self.fetFoods()
        refreshControl.endRefreshing()
    }
    
    @objc func syncDataSuccess(_ notification: Notification) {
        self.fetFoods()
    }
    
    private func showErrorMessage(content:String){
        if(!isMessageShowing){
            JonAlert.show(message: content ,
            andIcon: UIImage(named: ""),
            duration: 3.0)
            isMessageShowing = true
        }

    }
    
    
    @IBAction func actionFilterFood(_ sender: Any) {

        viewModel.category_type.accept(FOOD)
        viewModel.is_out_stock.accept(ALL)
        viewModel.is_sell_by_weight.accept(ADD_ALL_FOOD)
//        viewModel.is_allow_employee_gift.accept(ALL)
        viewModel.is_out_stock.accept(ALL)
        checkFilterSelected(view_selected: child_view_btn_filter_food, textTitle:btnFilterFood)
        
        textfield_search.text = ""
        view_clear_search.isHidden = true
        self.page = 1
        viewModel.dataArray.accept([])
       
        self.fetFoods()
    }
    
   
    @IBAction func actionFilterDrink(_ sender: Any) {
        viewModel.category_type.accept(DRINK)
        viewModel.is_out_stock.accept(ALL)
        viewModel.is_sell_by_weight.accept(DEACTIVE)
//        viewModel.is_allow_employee_gift.accept(ALL)
        viewModel.is_out_stock.accept(ALL)
        checkFilterSelected(view_selected: child_view_btn_filter_drink, textTitle: self.btnFilterDrink)
        
        textfield_search.text = ""
        view_clear_search.isHidden = true
        self.page = 1
        viewModel.dataArray.accept([])
      
        self.fetFoods()
    }
    @IBAction func actionFilterOther(_ sender: Any) {
        viewModel.category_type.accept(OTHER)
        viewModel.is_out_stock.accept(ALL)
        viewModel.is_sell_by_weight.accept(DEACTIVE)
//        viewModel.is_allow_employee_gift.accept(ALL)
        viewModel.is_out_stock.accept(ALL)
        checkFilterSelected(view_selected: child_view_btn_filter_other, textTitle: btnFilterOther)
       
        textfield_search.text = ""
        view_clear_search.isHidden = true
        self.page = 1
        viewModel.dataArray.accept([])
        
        self.fetFoods()
    }

    
    @IBAction func actionFilterCancelFood(_ sender: Any) {
        viewModel.category_type.accept(ALL)
        viewModel.is_out_stock.accept(1)
        viewModel.is_sell_by_weight.accept(-1)
        checkFilterSelected(view_selected: child_view_btn_filter_cancel_food, textTitle: btnFilterCancelFood)
       
        
        textfield_search.text = ""
        view_clear_search.isHidden = true
        
        self.page = 1
        viewModel.dataArray.accept([])
      
        self.fetFoods()
    }
    
    @IBAction func actionSave(_ sender: Any) {
        if(self.order_id > 0){
            proccessAddFoodToOrder()
        }else{
            // Call api open table before add food to order
            viewModel.table_id.accept(self.table_id)
            self.openTable()
        }
    }
    
    func proccessAddFoodToOrder(){
        viewModel.order_id.accept(self.order_id)
        self.repairAddFoodToOrder()
        if(is_gift == ADD_GIFT){
            self.addGiftFoodsToOrder()
        }else{
            self.addFoodsToOrder()
           
        }
    }
    
    @IBAction func actionClearSearch(_ sender: Any) {
        textfield_search.text = ""
        view_clear_search.isHidden = true
        self.fetFoods()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    func checkFilterSelected(view_selected:UIView, textTitle:UILabel){
        child_view_btn_filter_food.backgroundColor = .white
        child_view_btn_filter_drink.backgroundColor = .white
        child_view_btn_filter_other.backgroundColor = .white
        child_view_btn_filter_cancel_food.backgroundColor = .white
        
        btnFilterFood.textColor = ColorUtils.main_color()
        btnFilterDrink.textColor = ColorUtils.main_color()
        btnFilterOther.textColor = ColorUtils.main_color()
        btnFilterCancelFood.textColor = ColorUtils.main_color()

        textTitle.textColor = ColorUtils.white()
        view_selected.backgroundColor = ColorUtils.main_color()
    }
    
    func checkSelectFood(){
        var food_selected = [Food]()
        foods.enumerated().forEach { (index, value) in
            if(value.is_selected == 1){
                food_selected.append(value)
            }
        }
        self.viewModel.dataFoodSelected.accept(food_selected)
    }
}
extension AddFoodViewController{
    func registerCell() {
        let foodTableViewCell = UINib(nibName: "FoodTableViewCell", bundle: .main)
        tableView.register(foodTableViewCell, forCellReuseIdentifier: "FoodTableViewCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rx.setDelegate(self).disposed(by: rxbag)
        tableView.dataSource = self
        
        tableView.rx.reachedBottom(offset: CGFloat(self.viewModel.limit.value))
                   .subscribe(onNext:  {

                       if(!self.lastPosition){
                           self.spinner.color = ColorUtils.main_color()
                           self.spinner.startAnimating()
                           self.spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tableView.bounds.width, height: CGFloat(55))
                           self.tableView.tableFooterView = self.spinner
                           self.tableView.tableFooterView?.isHidden = false

//                            query the db on a background thread
                           DispatchQueue.main.async { [self] in
                               self.page = page + 1
                               self.fetFoods()
                           }
                       }
                   }).disposed(by: rxbag)
        
    }
}

extension AddFoodViewController{
    
    private func bindTableViewData() {
        viewModel.dataArray.subscribe( // Thực hiện subscribe Observable data food
          onNext: { [weak self] revenues in
              self?.tableView.reloadData()
          }).disposed(by: rxbag)
 
    }
       
}

extension AddFoodViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTableViewCell") as! FoodTableViewCell
        let data = self.foods[indexPath.row]
        cell.viewModel = viewModel
        cell.delegate = self
        cell.row = indexPath.row
        
        
        if(data.food_in_combo.count > 0){
            cell.addition_food_type = FOOD_COMBO
        }else if(data.food_list_in_promotion_buy_one_get_one.count > 0){
            cell.addition_food_type = FOOD_GIFT
        }else{
            cell.addition_food_type = FOOD_ADDITION
        }
        
        
        if(data.is_sell_by_weight == ACTIVE){
            cell.img_icon_scale.isHidden = false
            cell.lbl_quantity.text = String(format:"%.2f", data.quantity)
        }else{
            cell.img_icon_scale.isHidden = true
            cell.lbl_quantity.text = String(format:"%.0f", data.quantity)
        }

        cell.image_avatar.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: data.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
        cell.lbl_food_name.text = data.name
        
        cell.constraint_height_of_info_view.constant = data.name.widthOfString(usingFont: UIFont.systemFont(ofSize: 14)) > 200 ? 110 : 90
        
        cell.lbl_price.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data.price))
        cell.lbl_unit_name.text = String(format: "/%@", data.unit_type )
        cell.lbl_note.text = data.note
        
        if(data.is_selected == 0){
            Utils.isHideView(isHide: true, view: cell.root_action_add_sub_food)
            cell.radioButtonChecked.setImage(UIImage(named: "un_check_2"), for: .normal)
        }else{
            Utils.isHideView(isHide: false, view: cell.root_action_add_sub_food)
            cell.radioButtonChecked.setImage(UIImage(named: "check_2"), for: .normal)
        }
        
        if(data.note.count == 0){
//            cell.constraint_top_image.constant = 20
            Utils.isHideView(isHide: true, view: cell.root_view_note)
        }else{
//            cell.constraint_top_image.constant = 8
            Utils.isHideView(isHide: false, view: cell.root_view_note)
        }

        cell.tableView.isHidden = true
        cell.constraint_height_table_addition_food.constant = 0
        
        let attributeString = NSMutableAttributedString(string: cell.lbl_price.text!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
        cell.lbl_price.attributedText = attributeString
        
        let attributeUnitString = NSMutableAttributedString(string: cell.lbl_unit_name.text!)
        attributeUnitString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeUnitString.length))
        cell.lbl_unit_name.attributedText = attributeUnitString
        
        cell.lbl_price.textColor = ColorUtils.main_color()
        cell.lbl_unit_name.textColor = ColorUtils.grayColor()
        
        if(data.temporary_price != 0 && data.price_with_temporary < data.price){
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.red, range: NSMakeRange(0, attributeString.length))
            cell.lbl_price.attributedText = attributeString
            
            attributeUnitString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, attributeUnitString.length))
            attributeUnitString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.red, range: NSMakeRange(0, attributeUnitString.length))
            cell.lbl_unit_name.attributedText = attributeUnitString
            
            cell.lbl_price.textColor = ColorUtils.red_color()
            cell.lbl_unit_name.textColor = ColorUtils.red_color()
            
            cell.lbl_temporary_price.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data.price_with_temporary))
            cell.lbl_temporary_unit_name.text = String(format: "/%@", data.unit_type )
        }else{
            
            /*NẾu giá thời vụ lớn hơn giá gốc thì thay giá gốc == giá thời vụ*/
            if(data.temporary_price != 0 && data.price_with_temporary > data.price){
                cell.lbl_price.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data.price_with_temporary))
                
            }
            cell.lbl_temporary_price.text = ""
            cell.lbl_temporary_unit_name.text = ""
        }
       
        
        
        if(data.is_selected == 1){
            cell.lbl_food_loss.isHidden = true // ẨN LABLE HẾT MÓN | CHƯA GÁN BẾP
            // KIỂM TRA XEM MÓN GỌI CÓ PHẢI LÀ COMBO, MÓN BÁN KÈM HOẶC MUA 1 TẶNG 1 HAY KHÔNG ?
            if (data.food_list_in_promotion_buy_one_get_one.count) > 0{
                cell.food_addtions = data.food_list_in_promotion_buy_one_get_one
                cell.tableView.isHidden = false
                cell.constraint_height_table_addition_food.constant = CGFloat(data.food_list_in_promotion_buy_one_get_one.count*65)
            }else if (data.addition_foods.count) > 0{
       
                cell.food_addtions = data.addition_foods
                cell.tableView.isHidden = false
                cell.constraint_height_table_addition_food.constant = CGFloat(data.addition_foods.count*65)
            }else if (data.food_in_combo.count) > 0{
                cell.food_addtions = data.food_in_combo
                cell.tableView.isHidden = false
                cell.constraint_height_table_addition_food.constant = CGFloat(data.food_in_combo.count*65)
            }else{
                cell.tableView.isHidden = true
                cell.constraint_height_table_addition_food.constant = 0
            }
        }else{
            // KIỂM TRA MÓN HẾT HOẶC MÓN CHƯA GÁN BẾP ( ĐỐI VỚI MÓN CÓ THUỘC TÍNH IN BẾP )
            if(data.restaurant_kitchen_place_id == DEACTIVE){
                cell.lbl_food_loss.isHidden = false
                cell.lbl_food_loss.text = "chưa có bếp".uppercased()
                cell.radioButtonChecked.setImage(UIImage(named: "icon-check-disable"), for: .normal)
            }else{
                if(data.is_out_stock == ACTIVE){
                    cell.lbl_food_loss.isHidden = false
                    cell.lbl_food_loss.text = "hết món".uppercased()
                    cell.radioButtonChecked.setImage(UIImage(named: "icon-check-disable"), for: .normal)
                }else{
                    cell.lbl_food_loss.isHidden = true
                    cell.lbl_food_loss.text = ""
                    cell.radioButtonChecked.setImage(UIImage(named: "un_check_2"), for: .normal)
                }
            }
            
        }
        
        
       
        
                cell.btnQuantity.rx.tap.asDriver()
                               .drive(onNext: { [weak self] in
                                   self!.presentModalInputQuantityViewController(position: indexPath.row)
                               }).disposed(by: cell.disposeBag)
                
                cell.btnAdd.rx.tap.asDriver()
                               .drive(onNext: { [weak self] in
                                  
                                   var quantity = data.quantity
                                 
                                   if(data.is_sell_by_weight == ACTIVE){
                                       quantity += 0.01
                                       quantity = quantity >= 1000 ? 1000 : quantity
                                       
                                       self!.foods[indexPath.row].quantity = quantity

                                   }else{
                                       quantity += 1
                                       quantity = quantity >= 1000 ? 1000 : quantity
                                       
                                       self!.foods[indexPath.row].quantity = quantity

                                   }
                                   self?.checkSelectFood()
                                   let _indexPath = IndexPath(item: indexPath.row, section: 0)
                                   tableView.reloadRows(at: [_indexPath], with: .none)
                                   
                               }).disposed(by: cell.disposeBag)
                
                //========== Action Sub button click =================
                cell.btnSub.rx.tap.asDriver()
                               .drive(onNext: { [weak self] in
                                   var is_selected = 1
                                   var quantity = data.quantity
                                 
                                   if(data.is_sell_by_weight == ACTIVE){
                                      
                                       if(quantity > 0.01){
                                           quantity -= 0.01
                                       }else{
                                           quantity = 0
                                           is_selected = 0
                                       }
                                       
                                       if(quantity > 0){
                                           is_selected = 1
                                           self!.foods[indexPath.row].quantity = quantity
                                       }else{
                                           is_selected = 0
                                           self!.foods[indexPath.row].quantity = 0
                                       }

                                      
                                   }else{
                                       
                                       quantity -= 1
                                       if(quantity > 0){
                                           is_selected = 1
                                           self?.foods[indexPath.row].quantity = quantity
                                       }else{
                                           is_selected = 0
                                           self?.foods[indexPath.row].quantity = 0
                                       }
            
                                   }
                                   self!.foods[indexPath.row].is_selected = is_selected
                                   self?.checkSelectFood()
                                   
                                   let _indexPath = IndexPath(item: indexPath.row, section: 0)

                                   
                                   tableView.reloadRows(at: [_indexPath], with: .none)
                                   
                               }).disposed(by: cell.disposeBag)
                
                
                cell.radioButtonChecked.rx.tap.asDriver()
                               .drive(onNext: { [weak self] in
                                   if self!.foods[indexPath.row].is_out_stock == ACTIVE ||  self!.foods[indexPath.row].restaurant_kitchen_place_id == DEACTIVE {// MÓN ĐÃ HẾT KHÔNG ĐC ORDER | MÓN CHƯA CÓ BẾP CŨNG KO ĐC ORDER
                                       if self!.foods[indexPath.row].is_out_stock == ACTIVE {
                                           self!.showErrorMessage(content: String(format: "Món %@ đã hết bạn không thể order", self!.foods[indexPath.row].name))
                                       }else{
                                           self!.showErrorMessage(content: String(format: "Món %@ đã hết bạn không thể order", self!.foods[indexPath.row].name))
                                       }
                                       return
                                   }
                                   var is_selected = 0
                                   is_selected = data.is_selected == 0 ? 1 : 0
                                   self!.foods[indexPath.row].is_selected = is_selected
                                   if(is_selected == ACTIVE){
                                       if(self!.foods[indexPath.row].is_sell_by_weight == ACTIVE){
                                           self!.foods[indexPath.row].quantity =  self!.foods[indexPath.row].quantity > 0 ? self!.foods[indexPath.row].quantity : 0.01
                                       }else{
                                           self!.foods[indexPath.row].quantity =  self!.foods[indexPath.row].quantity > 0 ? self!.foods[indexPath.row].quantity : 1
                                       }
                                   }
                                   self?.checkSelectFood()
                                   let _indexPath = IndexPath(item: indexPath.row, section: 0)
                                   tableView.reloadRows(at: [_indexPath], with: .none)
                               }).disposed(by: cell.disposeBag)
        
        cell.tableView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = self.foods[indexPath.row]
        if food.is_out_stock == ACTIVE ||  food.restaurant_kitchen_place_id == DEACTIVE {// MÓN ĐÃ HẾT KHÔNG ĐC ORDER | MÓN CHƯA CÓ BẾP CŨNG KO ĐC ORDER
            
            if food.is_out_stock == ACTIVE {
                self.showErrorMessage(content:String(format: "Món %@ đã hết bạn không thể order", food.name))
            }else{
                self.showErrorMessage(content:String(format: "Món chưa gán bếp bạn không thể order"))
            }
            return
        } else {
            if self.foods[indexPath.row].is_sell_by_weight == SELL_BY_WEIGHT {
                if self.foods[indexPath.row].quantity >= 200 {
                    return
                }
                self.foods[indexPath.row].quantity = foods[indexPath.row].quantity + 0.01
                self.foods[indexPath.row].is_selected = 1
            }
            else {
                if self.foods[indexPath.row].quantity >= 1000 {
                    return
                }
                self.foods[indexPath.row].is_selected = 1
                self.foods[indexPath.row].quantity = foods[indexPath.row].quantity + 1

            }
            
            self.checkSelectFood()
            let indexPath = IndexPath(item: indexPath.row, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let food = self.foods[indexPath.row]
            
        if(food.is_selected == ACTIVE){
            if (food.food_list_in_promotion_buy_one_get_one.count > 0) {
                dLog("1")
                return food.note == ""
                        ? CGFloat(90 + 60*food.food_list_in_promotion_buy_one_get_one.count)
                        : CGFloat(110 + 60*food.food_list_in_promotion_buy_one_get_one.count)
                  
            } else if (food.addition_foods.count > 0) {
                dLog("2")
                return food.note == ""
                ? CGFloat(90 + 65*food.addition_foods.count)
                : CGFloat(110 + 60*food.addition_foods.count)
                
            }else if (food.food_in_combo.count > 0){
                dLog("3")
                if food.note == "" {
                    return CGFloat(90 + 60*food.food_in_combo.count)
                }
                else {
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                    return CGFloat(110 + 60*food.food_in_combo.count)
                }
            }
        }else{
            /*
             Nếu độ dài tên thức ăn mà dài hơn 200 thì ta cho kích thước của cell to hơn để hiện thị đầy đủ
             CGFloat(70) kích thước chuẩn của 1 cell. Nếu tên food quá dài ta tăng chiều cao +=20. Nếu có thêm note nữa +=20
             */
            return food.note == ""
            ? food.name.widthOfString(usingFont: UIFont.systemFont(ofSize: 14)) > 200 ? CGFloat(70 + 20) : CGFloat(70)
            : food.name.widthOfString(usingFont: UIFont.systemFont(ofSize: 14)) > 200 ? CGFloat(70 + 20 + 20) : CGFloat(70 + 20)
        }
        /*
            khi is_selected == ACTIVE ta phải hiển thị luôn cả phần note nên = CGFloat(90), Nếu tên food quá dài ta tăng chiều cao +=20
         */
        return food.name.widthOfString(usingFont: UIFont.systemFont(ofSize: 14)) > 200 ? CGFloat(90 + 20) : CGFloat(90)
    }
    

    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var  configuration : UISwipeActionsConfiguration?
        
        // noteFood action
        let noteFood = UIContextualAction(style: .destructive,title: "Ghi chú ") { [weak self] (action, view, completionHandler) in
            let foods = self?.viewModel.dataArray.value
            self?.handleNoteFood(pos: indexPath.row, note:foods![indexPath.row].note)
                                            completionHandler(true)
        }
        noteFood.backgroundColor = ColorUtils.gray_600()
        noteFood.image = UIImage(named: "icon-note-food")
        
        configuration = UISwipeActionsConfiguration(actions: [noteFood])
        // HẾT MÓN KHÔNG CHO GHI CHÚ
//        if (foods![indexPath.row].is_out_stock == ACTIVE){
//            configuration = UISwipeActionsConfiguration(actions: [])
//        }
        configuration!.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension AddFoodViewController{
    private func fetFoods(){
        dLog(self.area_id)
        // GET FOOD FROM LOCAL DATABASE
//        let foods = ManagerRealmHelper.shareInstance().getFoodsByCategory(category_type: viewModel.category_type.value, area_id: self.area_id)
        let foodsFetch  = ManagerRealmHelper.shareInstance().getFoodLimit(category_type: viewModel.category_type.value, is_allow_employee_gift:self.viewModel.is_allow_employee_gift.value,is_out_stock: self.viewModel.is_out_stock.value, keyword: key_word, area_id: self.area_id, offset: self.page, limit: self.viewModel.limit.value)
           
            
            var foodDatas = self.viewModel.dataArray.value
            foodDatas.append(contentsOf: foodsFetch)
           
            self.foods = foodDatas
        
            if(foodDatas.count > 0){
                dLog(foodDatas.toJSONString(prettyPrint: true) as Any)
                self.viewModel.dataArray.accept(foodDatas)
            }else{
               
                self.tableView.reloadData()
                self.viewModel.dataArray.accept([])
            }
        
            if(foodsFetch.count < self.viewModel.limit.value){
                self.lastPosition = true
            }
            self.spinner.stopAnimating()
            
            self.view_nodata_order.isHidden = (foods.count) > 0 ? true:false // thêm kiểm tra hiển thị icon ko có dữ liệu
            
        
        
        /*
        viewModel.branch_id.accept(self.branch_id)
        viewModel.area_id.accept(self.area_id)
//        viewModel.category_type.accept(self.category_id)
//        viewModel.is_allow_employee_gift.accept(self.is_allow_employee_gift)
//        viewModel.is_out_stock.accept(self.is_out_stock)
//        viewModel.is_sell_by_weight.accept(self.is_sell_by_weight)
        viewModel.key_word.accept(key_word)
        viewModel.foods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
               
                if let foods = Mapper<Food>().mapArray(JSONObject: response.data) {
                    
                    if(foods.count > 0){
                        dLog(foods.toJSONString(prettyPrint: true) as Any)
                        self.foods = foods
                        if(self.viewModel.allFoods.value.count == 0){
                            self.viewModel.allFoods.accept(foods)
                        }
                        self.viewModel.dataArray.accept(foods)
                    }else{
                        self.foods = foods
                        self.tableView.reloadData()
                        self.viewModel.dataArray.accept([])
                    }
                    self.view_nodata_order.isHidden = (foods.count) > 0 ? true:false // thêm kiểm tra hiển thị icon ko có dữ liệu
                    
                    
                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
         
         */
    }

    
    private func addFoodsToOrder(){
        viewModel.addFoods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                Toast.show(message: "Thêm món thành công...", controller: self)
                // check if order ready create then popViewController els navigator to OrderDetail Controller
                if(self.is_order == ACTIVE){
                    self.viewModel.makePopViewController()
                }else{
                    self.viewModel.table_name.accept(self.table_name)
                    self.viewModel.makeOrderDetailViewController()
                    // remove addFoodViewController 
                    self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
                        if vc.isKind(of: AddFoodViewController.self) {
                            return true
                        } else {
                            return false
                        }
                    })
                    
                }
                
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
//                Toast.show(message: response.message ?? "Có lỗi xảy ra khi gọi món vui lòng liên hệ admin", controller: self)

            }
         
        }).disposed(by: rxbag)
    }
    
    private func addGiftFoodsToOrder(){
        viewModel.addGiftFoods().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                Toast.show(message: "Tặng món thành công...", controller: self)
                JonAlert.showSuccess(message: "Tặng món thành công...",duration: 2.0)
                self.viewModel.makePopViewController()
            }else{
//                Toast.show(message: response.message ?? "Có lỗi trong quá trình giao tiếp server", controller: self)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
}
extension AddFoodViewController{
    private func bindData() {
        self.viewModel.dataFoodSelected.subscribe( // Thực hiện subscribe Observable
          onNext: { [weak self] data in
              self?.root_view_bottom_action.isHidden = data.count == 0
              self?.constraint_height_buttom_view_action.constant =  data.count == 0 ? 20 : 60
          }).disposed(by: rxbag)
    }
}
