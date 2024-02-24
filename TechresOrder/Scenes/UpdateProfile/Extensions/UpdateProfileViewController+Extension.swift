//
//  UpdateProfileViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 04/02/2023.
//

import UIKit
import ObjectMapper
import ZLPhotoBrowser
import ActionSheetPicker_3_0
import JonAlert
import RxRelay

extension UpdateProfileViewController{
    func setProfile(account:Account){
//        self.account = account
        
        avatar.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: account.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
        dLog(Utils.getFullMediaLink(string: account.avatar))
        lbl_username.text = ManageCacheObject.getCurrentUser().username
        lbl_role_name.text = ManageCacheObject.getCurrentUser().employee_role_description
        lbl_branch_name.text = ManageCacheObject.getCurrentUser().branch_name
        lbl_branch_address.text = ManageCacheObject.getCurrentUser().branch_name
        textfield_birthday.text = account.birthday
        textfield_address.text = account.address
        textfield_full_name.text = account.name
        textfield_email.text = account.email
        textfiled_phone_number.text = account.phone_number
    
        textfield_city.text = account.city_name
        textfield_district.text = account.district_name
        textfield_ward.text = account.ward_name
        
        if(account.gender == ACTIVE){
            self.radioMale.setImage(UIImage(named: "icon-radio-checked"), for: .normal)
            self.radioFeMale.setImage(UIImage(named: "icon-radio-uncheck"), for: .normal)
        }else{
            self.radioMale.setImage(UIImage(named: "icon-radio-uncheck"), for: .normal)
            self.radioFeMale.setImage(UIImage(named: "icon-radio-checked"), for: .normal)
        }
        
        dLog(account.avatar)
        viewModel.avatar.accept(account.avatar)
        viewModel.birthdayText.accept(account.birthday)
        viewModel.emailText.accept(account.email)
        viewModel.addressText.accept(account.address)
        viewModel.fullNameText.accept(account.name)
        //h
        viewModel.phoneText.accept(account.phone_number)
        
        viewModel.selectedArea.accept(
            [
                "CITY" : Area(id: account.city_id, name: account.city_name, is_select: ACTIVE),
                "DISTRICT" :Area(id: account.district_id, name: account.district_name, is_select: ACTIVE),
                "WARD" : Area(id: account.ward_id, name: account.ward_name, is_select: ACTIVE)
            ]
        )
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
            self?.avatar.image = results[0].image
            self?.imagecover.append(results[0].image)
            self?.selectedAssets.append(results[0].asset)
            self!.generateFileUpload()
        }
        ps.showPhotoLibrary(sender: self)
       
    }

    
    func generateFileUpload(){
        if imagecover.count > 0{
            var medias_requests = [Media]()
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
//
//
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
                dLog(media_request)
                dLog(medias_requests)
                self.viewModel.medias.accept(medias_requests)
        }
    }
    
    func getGenerateFile(){
            viewModel.getGenerateFile().subscribe(onNext: {(response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    // Call API Generate success...
                     let media_objects = Mapper<MediaObject>().mapArray(JSONArray: response.data as! [[String : Any]])
                    
                    dLog(media_objects[0].thumb)
                    /*
                        Nếu user thay đổi ảnh thì ta sẽ
                            gọi API để tạo file ảnh từ server trước, sau đó accept qua cho biến avatar và
                            gọi API update profile và upload ảnh lên server, sau khi update thành công thì
                            thấy đổi avatar của user (trong cache)
                        */
          
                   
                    
                    var mediass_request = [mediass]()
                    // CALL API UPLOAD IMAGE TO SERVER
                    var upload_requests = [MediaRequest]()
                    let upload_request = MediaRequest()
                    upload_request?.media_id = media_objects[0].media_id
                    upload_request?.name = media_objects[0].original?.name
                    upload_request?.image = self.imagecover[0]
                    upload_request?.data = self.imagecover[0].jpegData(compressionQuality: 0.5)
                    upload_request?.type = TYPE_IMAGE// Hình ảnh
                    upload_requests.append(upload_request!)
                    self.viewModel.upload_request.accept(upload_requests)
                    self.uploadMedia()
                    
                    // CALL API UPDATE PROFILE
                    self.viewModel.avatar.accept(media_objects[0].thumb?.url! ?? "")
                    self.updateProfile()
                     
                }else{
//                    Toast.show(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", controller: self)
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.",duration: 2.0)
                    dLog(response.message)
                }
            }).disposed(by: rxbag)
        }
    
    func updateProfileWithAvatar(){
        getGenerateFile()
    }
    
    func updateProfileWithoutAvatar(){
        updateProfile()
    }
    
    func uploadMedia(){
        viewModel.uploadImageWidthAlamofire()
    }
    
}
extension UpdateProfileViewController{
    
    func chooseBirthDayDate(dateFromString: Date){


        let datePicker = ActionSheetDatePicker(title: "Chọn ngày sinh", datePickerMode: .date, selectedDate: dateFromString, doneBlock: { picker, value, index in

            let formatter = DateFormatter()
                      formatter.dateFormat = "dd/MM/yyyy"
                      let localDateString = formatter.string(from: value as! Date)
            
                      self.textfield_birthday.text = localDateString
                      print(localDateString)
                        self.viewModel.birthdayText.accept(localDateString)
                      return
        }, cancel: { ActionStringCancelBlock in
            return
        }, origin: (self.btnChooseBirthday as AnyObject).superview!?.superview)

        let currentDate = Date()
        let calendar = Calendar.current
//        let maximumDate = calendar.date(byAdding: .year, value: -16, to: currentDate) // Ngày sinh tối thiểu là 16 năm trước ngày hiện tại
        let minimumDate = calendar.date(byAdding: .year, value: -200, to: currentDate) // Ngày sinh tối đa là 200 năm trước ngày hiện tại

        datePicker?.minimumDate = minimumDate
        //tối thiểu 16t
//        datePicker?.maximumDate = maximumDate
        datePicker?.maximumDate = currentDate
        datePicker?.show()

    }
    
    func chooseBirthDayDate(){
      
        let datePicker = ActionSheetDatePicker(title: "Chọn ngày sinh", datePickerMode: .date , selectedDate: Date() , doneBlock: {
           
          picker, value, index in
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          let localDateString = formatter.string(from: value as! Date)
          
          self.textfield_birthday.text = localDateString
          print(localDateString)
            self.viewModel.birthdayText.accept(localDateString)
          return
      }, cancel: { ActionStringCancelBlock in return }, origin: (self.btnChooseBirthday as AnyObject).superview!?.superview)
      datePicker?.maximumDate = Date()
      datePicker?.show()
    }

}

// HANDLE CHOOSE CITY
extension UpdateProfileViewController{
    func presentAddressDialogOfAccountInforViewController(areaType:String) {
        let addressDialogOfAccountInforViewController = AddressDialogOfAccountInforViewController()
        addressDialogOfAccountInforViewController.delegate = self
        addressDialogOfAccountInforViewController.view.backgroundColor = ColorUtils.blackTransparent()

        switch areaType{
            case "CITY":
                addressDialogOfAccountInforViewController.selectedArea = viewModel.selectedArea.value
                addressDialogOfAccountInforViewController.areaType = areaType
                break
            case "DISTRICT":
             
                addressDialogOfAccountInforViewController.selectedArea = viewModel.selectedArea.value
                addressDialogOfAccountInforViewController.areaType = areaType
                break
            case "WARD":
                addressDialogOfAccountInforViewController.areaType = areaType
                addressDialogOfAccountInforViewController.selectedArea = viewModel.selectedArea.value
                break
        default:
            return
        }

        let nav = UINavigationController(rootViewController: addressDialogOfAccountInforViewController)
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
           
            present(nav, animated: true, completion: nil)

        }
}


extension UpdateProfileViewController:AccountInforDelegate{
    func callBackToAcceptSelectedArea(selectedArea:[String:Area]) {
        var cloneSelectedArea = viewModel.selectedArea.value

        cloneSelectedArea.updateValue(selectedArea["CITY"]!, forKey: "CITY")
        cloneSelectedArea.updateValue(selectedArea["DISTRICT"]!, forKey: "DISTRICT")
        cloneSelectedArea.updateValue(selectedArea["WARD"]!, forKey: "WARD")
        viewModel.selectedArea.accept(cloneSelectedArea)
        
        textfield_city.text = selectedArea["CITY"]!.name
        textfield_district.text = selectedArea["DISTRICT"]!.name
        textfield_ward.text = selectedArea["WARD"]!.name
    }
}

