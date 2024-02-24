//
//  CreateFoodViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 03/02/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import Photos
import ZLPhotoBrowser
import JonAlert
//MARK: -- CALL API
extension CreateFoodViewController {

    func createFood(){
        viewModel.createFood().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get kitchen Success...")
                //mới
                JonAlert.showSuccess(message: "Thêm mới món ăn thành công!", duration: 2.0)

                self.delegate?.callBackReload()
                self.viewModel.makePopViewController()
            }else{
                dLog(response.message)
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    func updateFood(){
        viewModel.updateFood().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
               
                dLog("Get kitchen Success...")
                //mới
                JonAlert.showSuccess(message: "Cập nhật món ăn thành công!", duration: 2.0)
                self.delegate?.callBackReload()
                self.viewModel.makePopViewController()
            }else{
                dLog(response.message)
                JonAlert.showSuccess(message: response.message ?? "Cập nhật thất bại!", duration: 2.0)
            }
            self.isPressed = true
        }).disposed(by: rxbag)
        
    }
    
    
    func getCategories(){
        viewModel.getCategories().subscribe(onNext: {[weak self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let categories = Mapper<Category>().mapArray(JSONObject: response.data) {
                    if(categories.count > 0){
                        dLog(categories.toJSONString(prettyPrint: true) as Any)
                        self?.categories = categories
                        if(categories.count > 0){
                            
                            if(self!.food.id > 0) { // update food
                                categories.enumerated().forEach { (index, value) in
                                    if(self!.food.category_id == value.id){
                                        self?.btnCategory.setTitle(value.name, for: .normal)
                                    }
                                }
                            }else{ // create food
                                var foodRequest = self!.viewModel.foodRequest.value
                                foodRequest.category_id = categories[0].id
                                foodRequest.category_type = categories[0].category_type
                                foodRequest.category_name = categories[0].name
                                self?.btnCategory.setTitle(categories[0].name, for: .normal)
                                self?.viewModel.foodRequest.accept(foodRequest)
                            }
                            
                           
                        }
                    }else{
                        self!.viewModel.dataArray.accept([])
                    }
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    func getKitchenes(){
        viewModel.getKitchenes().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get kitchen Success...")
                if let kitchens  = Mapper<Kitchen>().mapArray(JSONObject: response.data){
                    self.kitchenses = kitchens.filter({$0.type != 2})
                    dLog(self.kitchenses.toJSON())
                    for i in 0..<self.kitchenses.count {
                        self.kitchen_names.append(self.kitchenses[i].name)
                        }
                    if self.kitchenses.count > 0 {
                            if(self.food.id > 0) { // update food
                                self.kitchenses.enumerated().forEach { (index, value) in
                                    if(self.food.restaurant_kitchen_place_id == value.id){
                                        self.btnSelectChefNeedPrint.setTitle(String(format: "      %@", value.name), for: .normal)
                                    }
                                }
                            }else{ // create food
                                var foodRequest = self.viewModel.foodRequest.value
                                foodRequest.restaurant_kitchen_place_id = self.kitchenses[0].id
                                self.btnSelectChefNeedPrint.setTitle(String(format: "      %@", self.kitchenses[0].name), for: .normal)
                                self.viewModel.foodRequest.accept(foodRequest)
                            }
                           
                            
                        }
                }

            }
        }).disposed(by: rxbag)
        
    }
    func getUnits(){
        viewModel.getUnits().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get Units Success...")
                if let units  = Mapper<Unit>().mapArray(JSONObject: response.data){
                    self.units = units
                    dLog(units.toJSON())
                        if units.count > 0 {
                            if(self.food.id > 0) { // update food
                                units.enumerated().forEach { (index, value) in
                                    if(self.food.unit_type == value.name){
                                        self.btnUnit.setTitle(value.name, for: .normal)
                                        
                                    }
                                }
                            }else{ // create food
                                var foodRequest = self.viewModel.foodRequest.value
                                foodRequest.unit = units[0].name
                                self.viewModel.foodRequest.accept(foodRequest)
                                self.btnUnit.setTitle(units[0].name, for: .normal)
                            }
                            
                            
                        }
                }

            }
        }).disposed(by: rxbag)
        
    }
    
    func getVAT(){
        viewModel.getVAT().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get VAT Success...")
                if let vats  = Mapper<Vat>().mapArray(JSONObject: response.data){
                    dLog(vats.toJSON())
                    self.vats = vats
                    for i in 0..<vats.count {
                        self.vat_names.append(vats[i].vat_config_name)
                        if(self.food.restaurant_vat_config_id > 0){
                            if(self.vats[i].id == self.food.restaurant_vat_config_id){
                                self.btnSelectVAT.setTitle(self.vats[i].vat_config_name, for: .normal)
                                self.viewModel.vat_id.accept(self.vats[i].id)
                            }
                        }
                    }
                    if(self.food.restaurant_vat_config_id == 0){
                        if vats.count > 0 {
                            self.btnSelectVAT.setTitle(vats[0].vat_config_name, for: .normal)
                            self.viewModel.vat_id.accept(vats[0].id)
                        }
                    }
                    
                }

            }
        }).disposed(by: rxbag)
        
    }
    
    
}
extension CreateFoodViewController: ArrayChooseViewControllerDelegate{
   
    func showChefBar(){
        chooseType = 4
        
        var listName = [String]()
        var listIcon = [String]()
           
        for kitchen in self.kitchenses {
            listName.append(kitchen.name)
            listIcon.append("baseline_account_balance_black_48pt")
        }
           
        let controller = ArrayChooseViewController(Direction.allValues)
        
        controller.list_icons = listIcon
        controller.listString = listName
        controller.preferredContentSize = CGSize(width: 300, height: 300)
        controller.delegate = self
        
        showPopup(controller, sourceView: btnSelectChefNeedPrint)
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    func selectAt(pos: Int) {
        dLog(self.kitchen_names[pos])
//        lbl_chef.text = self.kitchen_names[pos]
        btnSelectChefNeedPrint.setTitle(String(format: "      %@", self.kitchenses[pos].name), for: .normal)
        var foodRequest = viewModel.foodRequest.value
        foodRequest.restaurant_kitchen_place_id = self.kitchenses[pos].id
        viewModel.foodRequest.accept(foodRequest)
    }
    
    
}

extension CreateFoodViewController: ArrayChooseVATViewControllerDelegate{
    func showChooseVAT(){
        var listName = [String]()
        var listIcon = [String]()
           
        for vat_name in self.vat_names {
            listName.append(vat_name)
            listIcon.append("baseline_account_balance_black_48pt")
        }
           
        let controller = ArrayChooseVATViewController(Direction.allValues)
        
        controller.list_icons = listIcon
        controller.listString = listName
        controller.preferredContentSize = CGSize(width: 300, height: 300)
        controller.delegate = self
        
        showPopup(controller, sourceView: btnSelectVAT)
    }
    
    func selectVATAt(pos: Int) {
        dLog(self.vat_names[pos])
        btnSelectVAT.setTitle(self.vat_names[pos], for: .normal)
//        lbl_vat.text = self.vat_names[pos]
        viewModel.vat_id.accept(self.vats[pos].id)
    }
}


extension CreateFoodViewController: CalculatorMoneyDelegate{
    func presentModalCaculatorInputMoneyViewController(btnType:String) {
            let caculatorInputMoneyViewController = CaculatorInputMoneyViewController()
            
            //phân biệt lúc người dùng đang thao tác trên text_field nào từ đó lấy giá trị hiện của text_field đó
            switch btnType {
                case "CHOOSE_MONEY":
                    if let money = self.textfield_price.text?.trim().replacingOccurrences(of: ",", with: ""){
                        caculatorInputMoneyViewController.result = Int(money == "" ? "0" : money)!
                    }
                    break
                
                case "CHOOSE_TEM_PRICE":
                    if let money = self.textfield_price_by_time.text?.trim().replacingOccurrences(of: ",", with: ""){
                        caculatorInputMoneyViewController.result = Int(money == "" ? "0" : money)!
                    }
                    break
                
                default:
                    return
            }
            
            caculatorInputMoneyViewController.limitMoneyFee = 999999999
            caculatorInputMoneyViewController.checkMoneyFee = 100
            caculatorInputMoneyViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: caculatorInputMoneyViewController)
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
            caculatorInputMoneyViewController.delegate = self
    //        newFeedBottomSheetActionViewController.newFeed = newFeed
    //        newFeedBottomSheetActionViewController.index = position
            present(nav, animated: true, completion: nil)

        }
    
    func callBackCalculatorMoney(amount: Int, position: Int) {
        dLog(amount)
        if(self.is_partime_price == DEACTIVE){
            textfield_price.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(String(format: "%d", amount))!)
            var foodRequest = viewModel.foodRequest.value
            foodRequest.price = Float(amount)
            viewModel.foodRequest.accept(foodRequest)
        }else{
            textfield_price_by_time.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(String(format: "%d", amount))!)
            var foodRequest = viewModel.foodRequest.value
            foodRequest.price = Float(amount)
            viewModel.foodRequest.accept(foodRequest)
        }
       
        
    }
    
}
extension CreateFoodViewController: ArrayChooseCategoryViewControllerDelegate{
    func showChooseCategory(){
        
        var listName = [String]()
        var listIcon = [String]()
           
        for cate in self.categories {
            listName.append(cate.name)
            listIcon.append("baseline_account_balance_black_48pt")
        }
           
        let controller = ArrayChooseCategoryViewController(Direction.allValues)
        
        controller.list_icons = listIcon
        controller.listString = listName
        controller.preferredContentSize = CGSize(width: 300, height: 300)
        controller.delegate = self
        
        showPopup(controller, sourceView: btnCategory)
    }
    
    func selectCategoryAt(pos: Int) {
        dLog(self.categories[pos].toJSON())
//        lbl_chef.text = self.kitchen_names[pos]
        btnCategory.setTitle(self.categories[pos].name, for: .normal)
//        viewModel.cate_id.accept(self.kitchenses[pos].id)
        var foodRequest = viewModel.foodRequest.value
        foodRequest.category_id = self.categories[pos].id
        foodRequest.category_name = self.categories[pos].name
        foodRequest.category_type = self.categories[pos].category_type
        viewModel.foodRequest.accept(foodRequest)
    }
}
extension CreateFoodViewController: ArrayChooseUnitViewControllerDelegate{
    func showChooseUnit(){
        
        var listName = [String]()
        var listIcon = [String]()
           
        for unit in self.units {
            listName.append(unit.name)
            listIcon.append("baseline_account_balance_black_48pt")
        }
           
        let controller = ArrayChooseUnitViewController(Direction.allValues)
        
        controller.list_icons = listIcon
        controller.listString = listName
        controller.preferredContentSize = CGSize(width: 300, height: 300)
        controller.delegate = self
        
        showPopup(controller, sourceView: btnUnit)
    }
    
    func selectUnitAt(pos: Int) {
        dLog(self.units[pos].toJSON())
//        lbl_chef.text = self.kitchen_names[pos]
        btnUnit.setTitle(self.units[pos].name, for: .normal)
//        viewModel.cate_id.accept(self.kitchenses[pos].id)
        var foodRequest = viewModel.foodRequest.value
        foodRequest.unit = self.units[pos].name
        viewModel.foodRequest.accept(foodRequest)
    }
}
extension CreateFoodViewController: DateTimePickerDelegate{
    
    func chooseDate(isFrom:Int){
//        self.isFrom = isFrom // 1 from | 0 = to
        let selectedDate = convertDateStringToDate(dateString: isFrom == ACTIVE ? lbl_from.text! : lbl_to.text!)
        let min = selectedDate.addingTimeInterval(-60 * 60 * 24 * 4)
        let max = selectedDate.addingTimeInterval(60 * 60 * 24 * 4)
        
        let picker = DateTimePicker.show(selected: selectedDate, minimumDate: min, maximumDate: max)
        //        picker.timeInterval = DateTimePicker.MinuteInterval.thirty
        
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 162.0/255.0, blue: 51.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "CHỌN"
        picker.doneBackgroundColor = UIColor(red: 0.0/255.0, green: 114.0/255.0, blue: 188.0/255.0, alpha: 1)
        picker.locale = Locale(identifier: "vi")

        picker.todayButtonTitle = "Hôm nay"
        picker.is12HourFormat = true
        picker.dateFormat = "dd/MM/yyyy HH:mm"
        picker.isTimePickerOnly = false
        picker.isDatePickerOnly = false
        picker.includeMonth = false // if true the month shows at top
        picker.completionHandler = { date in
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy HH:mm"
          self.title = formatter.string(from: date)
        }
        picker.delegate = self
        self.picker = picker
  }
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        dLog(isFrom)
        if(isFrom == ACTIVE){
            lbl_from.text = picker.selectedDateString
            var foodRequest = viewModel.foodRequest.value
            foodRequest.temporary_price_from_date = picker.selectedDateString
            viewModel.foodRequest.accept(foodRequest)
        }else{
            lbl_to.text = picker.selectedDateString
            var foodRequest = viewModel.foodRequest.value
            if(foodRequest.temporary_price_from_date == ""){
                foodRequest.temporary_price_from_date = Utils.getFullCurrentDate()
            }
            foodRequest.temporary_price_to_date = picker.selectedDateString
            viewModel.foodRequest.accept(foodRequest)
        }
    }
    
    private func convertDateStringToDate(dateString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = dateFormatter.date(from: dateString)
        return date ?? Date()
    }
    
}
extension CreateFoodViewController{
    func setupPathFiles(){
        
//     chuan bi du lieu path file
        self.imagecover.enumerated().forEach { (index, value) in
            
            self.selectedAssets[0].requestContentEditingInput(with: PHContentEditingInputRequestOptions(), completionHandler: { (contentEditingInput, dictInfo) in
                if(self.selectedAssets[0].mediaType == .video){
                    if let strURL = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString {
                        self.resources_path.append(URL(string: strURL)!)
//
//                        if(self.resources_path.count == self.imagecover.count){
//
//                        }else{
//
//                        }
//
                        }
                }else{
                    if let strURL = contentEditingInput?.fullSizeImageURL {
                        self.resources_path.append(strURL)
//                        if(self.resources_path.count == self.imagecover.count){
//
//                        }else{
//
//                        }
                    }
                  
                }

                })
            
            
        }
    }
    
    
    
    func chooseAvatar() {
       let config = ZLPhotoConfiguration.default()
       config.maxSelectCount = 1
       config.maxVideoSelectCount = 1
       config.useCustomCamera = false
       config.sortAscending = false
       config.sortAscending = false
       config.allowSelectVideo = false
       config.allowEditImage = true
       config.allowEditVideo = false
       config.allowSlideSelect = false
       config.maxSelectVideoDuration = 60 * 100//100 phut
        let ps = ZLPhotoPreviewSheet()
        ps.selectImageBlock = { [weak self] results, isOriginal in
            // your code
            self?.avatar_food.image = results[0].image
            self?.imagecover.append(results[0].image)
            self?.selectedAssets.append(results[0].asset)
            self!.generateFileUpload()
        }
        ps.showPhotoLibrary(sender: self)
       
    }

    func generateFileUpload(){
        if imagecover.count > 0{
            var medias_requests = [Media]()
            //            for i in 0...self.selectedImages.count {
//
//                let format = DateFormatter()
//                format.dateFormat = "dd/MM/yyyy"
//
//                let date = Date()
//                let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd"
//                let result = formatter.string(from: date)
//
//                let number = Int.random(in: 1 ... 100)
//                let random = Utils.randomString(length: number)
//                var file_name = String(format: "file_name_%@_%@.%@", result, random, "png")
//
//                let unreserved = "-._~/?%$!:"
//                let allowed = NSMutableCharacterSet.alphanumeric()
//                allowed.addCharacters(in: unreserved)

                
                let widthImageAvatar = Int(self.imagecover[0].size.width)
                let heightImageAvatar = Int(self.imagecover[0].size.height)

                
                var media_request = Media()
//                file_name = String(format: "file_name_%@_%@.%@", result, random, "png")
                media_request.type = 0
                
                media_request.name = Utils.getImageFullName(asset: self.selectedAssets[0])
                
                media_request.size = 1
                media_request.is_keep = 1 // lưu lại mãi mãi. Nếu 0 sẽ bị xoá sau 1 thời gian ( trường hợp trong group chat)
                media_request.width = widthImageAvatar
                media_request.height = heightImageAvatar
                media_request.type = TYPE_IMAGE// hình ảnh
            
                medias_requests.append(media_request)
                self.viewModel.medias.accept(medias_requests)
                
        }
    }
    
//
// func chooseAvatar() {
//
//        let config = ZLPhotoConfiguration.default()
//        config.maxSelectCount = 1
//        config.maxVideoSelectCount = 1
//        config.useCustomCamera = false
//        config.sortAscending = false
//        config.sortAscending = false
//        config.allowSelectVideo = false
//        config.allowEditImage = true
//        config.allowEditVideo = false
//        config.allowSlideSelect = false
//        config.maxSelectVideoDuration = 60 * 100//100 phut
//
//        let ps = ZLPhotoPreviewSheet(config: config)
//     ps.selectImageBlock = { [self] (images, assets, isOriginal) in
//
//            self.avatar_food.image = images[0]
//            self.imagecover.append(images[0])
//            self.selectedAssets.append(contentsOf: assets)
//
////            self.setupPathFiles()
//
//            if imagecover.count > 0{
//
////                let parameters = [String:AnyObject]()
//                var medias_requests = [Media]()
//                //            for i in 0...self.selectedImages.count {
//
//
//                    let format = DateFormatter()
//                    format.dateFormat = "dd/MM/yyyy"
//
//                    let date = Date()
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "yyyy-MM-dd"
//                    let result = formatter.string(from: date)
//
//                    let number = Int.random(in: 1 ... 100)
//                    let random = Utils.randomString(length: number)
//                    var file_name = String(format: "file_name_%@_%@.%@", result, random, "png")
//
//                    let unreserved = "-._~/?%$!:"
//                    let allowed = NSMutableCharacterSet.alphanumeric()
//                    allowed.addCharacters(in: unreserved)
//
//
//                    let widthImageAvatar = Int(self.imagecover[0].size.width)
//                    let heightImageAvatar = Int(self.imagecover[0].size.height)
//
//
//                    var media_request = Media()
//                file_name = String(format: "file_name_%@_%@.%@", result, random, "png")
//                media_request.type = 0
//
//
//
//
//                    media_request.name = file_name
//
//                    media_request.size = 1
//                    media_request.is_keep = 1 // lưu lại mãi mãi. Nếu 0 sẽ bị xoá sau 1 thời gian ( trường hợp trong group chat)
//                    media_request.width = widthImageAvatar
//                    media_request.height = heightImageAvatar
//                    medias_requests.append(media_request)
//
//
//
//                self.viewModel.medias.accept(medias_requests)
//
////                self.getGenerateFile()
//
//            }
//
//        }
//
//
//
//
//
//        ps.showPhotoLibrary(sender: self)
//    }
    
    func getGenerateFile(){
            viewModel.getGenerateFile().subscribe(onNext: {(response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    // Call API Generate success...
                     let media_objects = Mapper<MediaObject>().mapArray(JSONArray: response.data as! [[String : Any]])
                    dLog(media_objects.toJSON())
                    
                    if(media_objects.count > 0){
                        // CALL API UPDATE PROFILE
                        var foodRequest = self.viewModel.foodRequest.value
    //                    user_request.avatar = media_objects[0].media_id!
                        foodRequest.avatar = media_objects[0].thumb?.url ?? ""
                        self.viewModel.foodRequest.accept(foodRequest)
                        
                        var mediass_request = [mediass]()
                      
                        
                        // call api create or update food after upload image to server media
                        
                        if((self.food.id) > 0){ // update food
                            self.updateFood()
                        }else{// create food
                            self.createFood()
                        }
                        
                        
                        // CALL API UPLOAD IMAGE TO SERVER
                            var upload_requests = [MediaRequest]()
                           
                                // repair media request
                                var medias = mediass()
                                medias?.media_id = media_objects[0].media_id!
                                medias?.content = ""
                                mediass_request.append(medias!)

                                var upload_request = MediaRequest()
                                
                                upload_request?.media_id = media_objects[0].media_id
                                upload_request?.name = media_objects[0].original?.name
                                upload_request?.image = self.imagecover[0]
                                upload_request?.data = self.imagecover[0].jpegData(compressionQuality: 0.5)
                                upload_request?.type = 0// type image | 1= type video
                                upload_requests.append(upload_request!)
                        dLog(self.imagecover[0])
                       
                        self.viewModel.upload_request.accept(upload_requests)
                        
                        self.uploadMedia()
                        
                    }
                  
                    
                }else{
//                    Toast.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ", controller: self)
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                    dLog(response.message)
                }
            }).disposed(by: rxbag)
        }
    
    public func uploadMedia(){
        viewModel.uploadImageWidthAlamofire()
    }
    
}


extension CreateFoodViewController {
    // kiểm tra giá food lớn hơn giá thời vụ
    func isValidCheckPriceFoodwithPriceTempory(price_tempory: Int) -> Bool{
        let text_value_price = self.textfield_price.text?.trim().replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "-", with: "")
        let price = Int(text_value_price!.count > 0 ? text_value_price! : "0")
        if price_tempory > price! || price_tempory == 0 {
            return true
        }
        return false
    }
    
    func isCheckdatetimeValue() -> Bool {
        // kiểm tra thời gian kết thúc phải lớn hơn thời gian hiện tại
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let startDate = dateFormatter.date(from: self.lbl_from.text ?? ""), let endDate = dateFormatter.date(from: self.lbl_to.text ?? "") {
            if Utils.isWithinDateLimit(startDate: startDate, endDate: endDate)
            {
                return false
            }else
            {
                return true
            }
            
        }
        return false
    }
    
    func isCheckFromDate() -> Bool {
        // kiểm tra thời gian bắt đầu phải lớn hơn thời gian hiện tại
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let startDate = dateFormatter.date(from: self.lbl_from.text ?? ""){
            if Utils.isGreaterThanOrEqualCurrentDate(startDate: startDate)
            {
                return false
            }else
            {
                return true
            }
            
        }
        return false
    }
    func isCheckToDate() -> Bool {
        // kiểm tra thời gian bắt đầu phải lớn hơn thời gian hiện tại
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let startDate = dateFormatter.date(from: self.lbl_from.text ?? ""), let endDate = dateFormatter.date(from: self.lbl_to.text ?? "") {
            if Utils.isGreaterThanFromDate(startDate: startDate, endDate: endDate)
            {
                return false
            }else
            {
                return true
            }
            
        }
        return false
    }
  
}
