//
//  CreateTableViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import JonAlert
class CreateTableViewController: BaseViewController {
    var viewModel = CreateTableViewModel()
    var router = CreateTableRouter()
    var delegate:TechresDelegate?
    
    
    @IBOutlet weak var lbl_header_create_update: UILabel!
    
    @IBOutlet weak var root_view_table: UIView!
    @IBOutlet weak var textfield_table_name: UITextField!
    
    @IBOutlet weak var textfield_area_name: UITextField!
    
    @IBOutlet weak var textfield_number_slot: UITextField!

    @IBOutlet weak var lbl_number_slot: UILabel!
    
    
    @IBOutlet weak var btnCheckActivity: UIButton!
    
    @IBOutlet weak var btnCreateTable: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnChooseArea: UIButton!
    @IBOutlet weak var btnCheckbox: UIButton!
    
    @IBOutlet weak var btnQuantity: UIButton!
    var ischecked = 1
    var branch_id = 0
    var table_id = 0
    var area_names = [String]()
    var table = TableModel()
    var isPressed = true
//    var table_names = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        root_view_table.round(with: .both, radius: 8)
        // Do any additional setup after loading the view.
        btnCheckbox.isUserInteractionEnabled = false
        btnCheckbox.setImage(UIImage(named: "check_2"), for: .normal)
        textfield_table_name.becomeFirstResponder()
        
        
        _ = textfield_table_name.rx.text.map { $0 ?? "" }.bind(to: viewModel.tableNameText)
        _ = textfield_number_slot.rx.text.map { $0 ?? "" }.bind(to: viewModel.numberSlotText)

        _ = viewModel.isValid.subscribe({ [weak self] isValid in
            dLog(isValid)
            guard let strongSelf = self, let isValid = isValid.element else { return }
//            strongSelf.btnCreateTable.isEnabled = isValid
//            strongSelf.btnCreateTable.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
//            strongSelf.btnCreateTable.tintColor = ColorUtils.white()
//            strongSelf.btnCreateTable.titleLabel?.textColor = isValid ? ColorUtils.white() : ColorUtils.blackBackGroundColor()
            
            // Thêm trường kiểm tra textfield_table_name kiểm tra ko nhập ký tự đặc biệt
            if (self?.textfield_table_name.text!.count)! > 0 {
                
                self?.textfield_table_name.text = String((self?.textfield_table_name.text?.prefix(Constants.AREA_TABLE_REQUIRED.requiredAreaTableMaxLength))!)
                if(strongSelf.textfield_table_name.text!.count == Constants.AREA_TABLE_REQUIRED.requiredAreaTableMaxLength) {
                    Toast.show(message: "Tên bảng phải từ \(Constants.AREA_TABLE_REQUIRED.requiredAreaTableMinLength) tới \(Constants.AREA_TABLE_REQUIRED.requiredAreaTableMaxLength) ký tự", controller: self!)
                }
                self?.textfield_table_name.text = Utils.blockSpecialCharacters((self?.textfield_table_name.text)!)
            }

        })
        
        _ = viewModel.checkTableNameText.subscribe({ [weak self] tableNameText in
            guard let tableNameText = tableNameText.element else { return }
            if ((tableNameText.count == 1) && (tableNameText  == " ")){
                self?.textfield_table_name.text = ""
            }
            
        })
        
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.status.accept(ACTIVE)
        
        if(table!.id > 0){// update table
            lbl_header_create_update.text = "CẬP NHẬT BÀN"
            btnCreateTable.setTitle("CẬP NHẬT", for: .normal)
            textfield_table_name.text = table?.name
            textfield_area_name.text = table?.area_name
            textfield_number_slot.text = String(format: "%d", table?.slot_number ?? 0)
            self.table_id = table!.id
            viewModel.area_id.accept(table!.area_id)
            
            if(table?.is_active == ACTIVE){
                btnCheckbox.setImage(UIImage(named: "check_2"), for: .normal)
            }else{
                btnCheckbox.setImage(UIImage(named: "un_check_2"), for: .normal)
            }
            
            
        }else{
            lbl_header_create_update.text = "THÊM BÀN"
            btnCreateTable.setTitle("THÊM", for: .normal)
        }
        
        btnQuantity.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.presentModalInputQuantityViewController()
                       }).disposed(by: rxbag)
        
        btnChooseArea.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.showChooseArea()
                       }).disposed(by: rxbag)
        
        btnCancel.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.navigationController?.dismiss(animated: true)
                       }).disposed(by: rxbag)
        
        
        btnCreateTable.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.viewModel.is_active.accept(self!.ischecked)
                           self!.viewModel.status.accept(self!.ischecked)
                           self!.viewModel.table_id.accept(self!.table_id)
                           self!.viewModel.branch_id.accept(self!.branch_id)
                           self!.viewModel.table_name.accept((self!.textfield_table_name.text)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                       
                           //Kiểm tra tên bàn có đang bị trùng không
//                           for table_name in self!.table_names {
//                               if Utils.isCheckStringEqual(stringA: self!.textfield_table_name.text!, stringB: table_name){
//                                   Toast.show(message: "Tên bàn \(table_name) đã tồn tại!", controller: self!)
//                                   return
//                               }
//                           }

                           
                           // Thêm điều kiện kiểm tra số lượng
                           if self!.checkVaildText_Name_Area(Text_Area: (self?.textfield_table_name.text?.trim())!)
                           {
//                               Toast.show(message: "Tên bàn phải từ \(Constants.AREA_TABLE_REQUIRED.requiredAreaTableMinLength) tới \(Constants.AREA_TABLE_REQUIRED.requiredAreaTableMaxLength) ký tự", controller: self!)
                               JonAlert.showSuccess(message: "Tên bàn phải từ \(Constants.AREA_TABLE_REQUIRED.requiredAreaTableMinLength) tới \(Constants.AREA_TABLE_REQUIRED.requiredAreaTableMaxLength) ký tự!", duration: 2.0)
                               return
                           }

                           
                           
                           for i in self!.textfield_table_name.text!{
                               if Utils.ischaracter(string: String(i)){
//                                   Toast.show(message: "Tên bàn không được phép nhập ký tự đặc biệt.", controller: self!)
                                   JonAlert.showSuccess(message: "Tên bàn không được phép nhập ký tự đặc biệt!", duration: 2.0)
                                   return
                               }
                           }
                           
                           if let slot_number = self!.textfield_number_slot.text{
                               if(slot_number.count > 0){
                                   if(Int(slot_number)! <= 0){
//                                       Toast.show(message: "Vui lòng nhập số lượng khách/bàn", controller: self!)
                                       JonAlert.showSuccess(message: "Vui lòng nhập số lượng khách/bàn!", duration: 2.0)
                                       return
                                   }else{
                                       self!.viewModel.total_slot.accept(Int(self!.textfield_number_slot.text ?? "0")!)
                                   }
                               }else{
//                                   Toast.show(message: "Vui lòng nhập số lượng khách/bàn", controller: self!)
                                   JonAlert.showSuccess(message: "Vui lòng nhập số lượng khách/bàn!", duration: 2.0)
                                   return
                               }
                           }
                          
                    
                           if(self!.isPressed){
                              self?.isPressed = false
                              self!.createTable()

                           }

                        
                       }).disposed(by: rxbag)
        
        if(table!.id > 0){
            btnCheckbox.isUserInteractionEnabled = true
            btnCheckActivity.rx.tap.asDriver()
                           .drive(onNext: { [weak self] in
                            
                               if(self!.ischecked == 0){
                                   self!.btnCheckbox.setImage(UIImage(named: "check_2"), for: .normal)
                                   self!.ischecked = 1
                               }else{
                                   self?.btnCheckbox.setImage(UIImage(named: "un_check_2"), for: .normal)
                                   self!.ischecked = 0
                               }
                                    
                               self!.viewModel.status.accept(self!.ischecked)
                               
                           }).disposed(by: rxbag)
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAreas()
//        getTables()
    }

}
