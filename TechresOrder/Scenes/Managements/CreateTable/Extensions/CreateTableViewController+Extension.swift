//
//  CreateTableViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert

//Thêm phần mở rộng cho CreateTableViewController
extension CreateTableViewController {
    func checkVaildText_Name_Area(Text_Area: String) -> Bool {
        if (Text_Area.count >= Constants.AREA_TABLE_REQUIRED.requiredAreaTableMinLength && Text_Area.count <= Constants.AREA_TABLE_REQUIRED.requiredAreaTableMaxLength){
            return false
        }
        return true
    }
    
}


//MARK: CALL API
extension CreateTableViewController {
    func getAreas(){
        viewModel.getAreas().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Areas Success...")
                if let areas  = Mapper<Area>().mapArray(JSONObject: response.data){
                    dLog(areas.toJSON())
                    for i in 0..<areas.count {
                        self.area_names.append(areas[i].name)
                    }
                    self.viewModel.area_array.accept(areas)
                    
                    if(areas.count > 0){
                        if(self.table!.id > 0) { // update table
                            areas.enumerated().forEach { (index, value) in
                                if(self.table?.area_id == value.id){
                                    self.textfield_area_name.text = value.name
                                    self.viewModel.area_id.accept(value.id)
                                }
                            }
                        }else{ // create table
                            self.textfield_area_name.text = self.area_names[0]
                            self.viewModel.area_id.accept(areas[0].id)
                        }
                        
                      
                    }
                }
            }
        }).disposed(by: rxbag)
  }
//    
//    func getTables(){
//        viewModel.getTables().subscribe(onNext: { (response) in
//            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                dLog("Get Tables Success...")
//                if let tables  = Mapper<TableModel>().mapArray(JSONObject: response.data){
//                    dLog(tables.toJSON())
//                    for i in 0..<tables.count {
//                        self.table_names.append(tables[i].name)
//                    }
//                    self.viewModel.table_array.accept(tables)
//
//                }
//            }
//        }).disposed(by: rxbag)
//  }
    
    func createTable(){
        viewModel.createTable().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Create Table Success...")
//                Toast.show(message: "Tạo bàn thành công ", controller: self)
                if self.table_id > 0{
                    JonAlert.showSuccess(message: "Cập nhật bàn thành công!", duration: 2.0)
                }else{
                    JonAlert.showSuccess(message: "Thêm bàn mới thành công!", duration: 2.0)
                }
                self.delegate?.callBackReload()
                self.navigationController?.dismiss(animated: true)
            }else{
//                Toast.show(message: response.message ?? "Tạo bàn thất bại", controller: self)
                JonAlert.showSuccess(message: response.message ?? "Tạo bàn thất bại", duration: 2.0)
                dLog(response.message)
            }
            self.isPressed = true
        }).disposed(by: rxbag)
}
    
}

extension CreateTableViewController: ArrayChooseViewControllerDelegate{
    func showChooseArea(){
        var listName = [String]()
        var listIcon = [String]()
           
        for area_name in self.area_names {
            listName.append(area_name)
            listIcon.append("baseline_account_balance_black_48pt")
        }
           
        let controller = ArrayChooseViewController(ExampleArray.allValues)
        
        controller.list_icons = listIcon
        controller.listString = listName
        controller.preferredContentSize = CGSize(width: 300, height: 300)
        controller.delegate = self
        
        showPopup(controller, sourceView: btnChooseArea)
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    func selectAt(pos: Int) {
        let areas = viewModel.area_array.value
        textfield_area_name.text = areas[pos].name
        viewModel.area_id.accept(areas[pos].id)
    }
    
}
extension CreateTableViewController:CaculatorInputQuantityDelegate{
    func presentModalInputQuantityViewController() {
        let inputQuantityViewController = InputQuantityViewController()
        inputQuantityViewController.view.backgroundColor = ColorUtils.blackTransparent()
        inputQuantityViewController.max_quantity = Float(999)
        dLog(table!.slot_number)
        inputQuantityViewController.current_quantity = Float(table!.slot_number)
        let nav = UINavigationController(rootViewController: inputQuantityViewController)
            // 1
        nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
        inputQuantityViewController.delegate = self
    //        newFeedBottomSheetActionViewController.newFeed = newFeed
    //        newFeedBottomSheetActionViewController.index = position
            present(nav, animated: true, completion: nil)

        }
    
    func callbackCaculatorInputQuantity(number: Float, position: Int) {
        textfield_number_slot.text = String(format: "%.0f", number)
        viewModel.number_slot.accept(Int(number))
    }
}
