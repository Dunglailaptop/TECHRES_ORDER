//
//  UpdateProfileViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 04/02/2023.
//

import UIKit
import RxSwift
import RxRelay

class UpdateProfileViewModel: BaseViewModel {
    
    private(set) weak var view: UpdateProfileViewController?
    private var router: UpdateProfileRouter?
    var branch_id = BehaviorRelay<Int>(value: 0)
    var employee_id = BehaviorRelay<Int>(value: 0)
    var status = BehaviorRelay<Int>(value: 0)


    var avatar = BehaviorRelay<String>(value: "")
    
    // Khai báo biến để hứng dữ liệu từ VC
    var fullNameText = BehaviorRelay<String>(value: "")
    // them sdt
    var phoneText = BehaviorRelay<String>(value: "")
    var birthdayText = BehaviorRelay<String>(value: "")
    var emailText = BehaviorRelay<String>(value: "")
    var cityText = BehaviorRelay<String>(value: "")
    var districtText = BehaviorRelay<String>(value: "")
    var wardText = BehaviorRelay<String>(value: "")
    var addressText = BehaviorRelay<String>(value: "")
    var gender = BehaviorRelay<Int>(value:0)
    var selectedArea = BehaviorRelay<[String:Area]>(value:[String:Area]())
        
    // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
    var isValidFullName: Observable<Bool> {
        dLog(fullNameText)
        return self.fullNameText.asObservable().map { full_name in
            full_name.count >= Constants.PROFILE_FORM_REQUIRED.requiredFullNameMinLength &&
            full_name.count <= Constants.PROFILE_FORM_REQUIRED.requiredFullNameMaxLength
        }
    }
 
    var isValidPhone: Observable<Bool> {
        
        return self.phoneText.asObservable().map { phoneText in
  
  
            return (
                phoneText.count >= Constants.PROFILE_FORM_REQUIRED.requiredPhoneMinLength &&
                phoneText.count <= Constants.PROFILE_FORM_REQUIRED.requiredPhoneMaxLength
            )
        }
    }
    //email h
    var isValidEmail: Observable<Bool> {
        return self.emailText.asObservable().map { email in
            
            return Utils.isValidEmail(email)
        }
    }
    
    var isValidBirthday: Observable<Bool> {
        dLog(birthdayText)
        return self.birthdayText.asObservable().map { birthday in
            birthday.count >= Constants.PROFILE_FORM_REQUIRED.requiredFullNameMinLength &&
            birthday.count <= Constants.PROFILE_FORM_REQUIRED.requiredFullNameMaxLength
        }
    }
    //h giới hạn >= 16 tuổi
    var isValidDateOfBirth: Observable<Bool> {
        return self.birthdayText.asObservable().map { birthday in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd" // Định dạng ngày sinh nhật

            if let date = dateFormatter.date(from: birthday) {
                let currentDate = Date()
                let calendar = Calendar.current

                dLog(date)
                dLog(currentDate)
                // So sánh ngày sinh nhật với ngày hiện tại
                _ = calendar.compare(date, to: currentDate, toGranularity: .day)

                let ageComponents = calendar.dateComponents([.year], from: date, to: currentDate)
                if let age = ageComponents.year, age >= 16 {
                    return true
                }
            }

            return false
        }.filter { $0 } // Lọc những giá trị true để chỉ trả về khi hợp lệ
    }

    
    var isValidCity: Observable<Bool> {
        return self.cityText.asObservable().map { city in
            city.count >= Constants.PROFILE_FORM_REQUIRED.requiredFullNameMinLength &&
            city.count <= Constants.PROFILE_FORM_REQUIRED.requiredFullNameMaxLength
        }
    }
    var isValidDistrict: Observable<Bool> {
        return self.districtText.asObservable().map { district in
            district.count >= Constants.PROFILE_FORM_REQUIRED.requiredFullNameMinLength &&
            district.count <= Constants.PROFILE_FORM_REQUIRED.requiredFullNameMaxLength
        }
    }
    
    var isValidWard: Observable<Bool> {
        return self.wardText.asObservable().map { ward in
            ward.count >= Constants.PROFILE_FORM_REQUIRED.requiredFullNameMinLength &&
            ward.count <= Constants.PROFILE_FORM_REQUIRED.requiredFullNameMaxLength
        }
    }
    //không tính khoảng cách giữa các từ
    //h thêm check bỏ khoảng trắng và thêm Utils check địa chỉ
    var isValidAddress: Observable<Bool> {
        return self.addressText.asObservable().map { address in
 
            address.replacingOccurrences(of: " ", with: "").count >= 2 &&
            address.count <= 255 && Utils.isCheckValidateAddress(address: address)
        }
    }
    
    

    
    
    // Khai báo biến để lắng nghe kết quả của cả 5 sự kiện trên
    var isValid: Observable<Bool> {
        return Observable.combineLatest(isValidFullName, isValidBirthday, isValidAddress) {$0 && $1 && $2 }

    }
//    var isValid: Observable<Bool> {
//        return Observable.combineLatest(isValidFullName, isValidBirthday) {$0 && $1}
//
//    }
    
    
    func bind(view: UpdateProfileViewController, router: UpdateProfileRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
// MARK: -- CALL API HERE...
extension UpdateProfileViewModel{
    func getProfile() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.profile(branch_id: branch_id.value, employee_id: employee_id.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
        
    func updateProfile() -> Observable<APIResponse> {
        var profileRequest = ProfileRequest()
        profileRequest.avatar = avatar.value
        profileRequest.id = ManageCacheObject.getCurrentUser().id
        profileRequest.name = fullNameText.value
        profileRequest.phone_number =  phoneText.value
        profileRequest.email = emailText.value
        profileRequest.birthday = birthdayText.value
        profileRequest.address = addressText.value
        profileRequest.gender = gender.value// new
        profileRequest.city_id = selectedArea.value["CITY"]!.id
        profileRequest.district_id = selectedArea.value["DISTRICT"]!.id
        profileRequest.ward_id = selectedArea.value["WARD"]!.id
        
        
        
        return appServiceProvider.rx.request(.updateProfile(profileRequest: profileRequest))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    
//    func updateProfileInfo() -> Observable<APIResponse> {
//        return appServiceProvider.rx.request(.updateProfileInfo(infoRequest: userInfoRequest.value))
//               .filterSuccessfulStatusCodes()
//               .mapJSON().asObservable()
//               .showAPIErrorToast()
//               .mapObject(type: APIResponse.self)
//       }
    
}
