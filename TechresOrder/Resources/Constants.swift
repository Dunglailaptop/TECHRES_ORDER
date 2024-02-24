//
//  Constants.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit

struct Constants {
    static let apiKey = "net.techres.order.api"
    static let OS_NAME = "iOS"
    
    static let OK = "OK"
    
    struct MESSAGE {
        static let OK = "OK"
    }
    struct AUTHORIZATION_KEYS{
        static let AUTHORIZATION =  "Authorization"
        static let AUTHORIZATION_BASIC_TYPE =  "Basic"
        static let AUTHORIZATION_BEARER_TYPE =  "Bearer"
    }
    struct PARAMS_KEY{
        static let  REQUEST_URL = "request_url"
        static let  PROJECT_ID = "project_id"
        static let  HTTP_METHOD = "http_method"
        static let  PRODUCT_MODE = "is_production_mode"
        static let  PARAMS = "params"
        static let OS_NAME = "os_name"
        
    }
    
    struct PROJECT_IDS {
       
        static let PROJECT_OAUTH = 8888 // oauth java api
        static let PROJECT_ID_ORDER = 8094
        static let PROJECT_ID_DASHBOARD = 8095
        static let PROJECT_ID_ORDER_SMALL = 8197
        static let PROJECT_ID_REPORT = 1489
        static let PROJECT_UPLOAD_SERVICE = 9007
        static let PROJECT_HEALTH_CHECK_SERVICE = 1408
     
    }
    struct METHOD_TYPE {
        static let POST = 1
        static let GET = 0
    }
    
    struct METHOD_TYPE_STRING {
        static let POST = "POST"
        static let GET = "GET"
    }
    
    
    struct ENVIRONMENT_MODE {
        
        static let ENVIRONMENT_MODE = 0// 0: develop, 1: production
    }
    
    struct STATUS_CODES {
        static let UNAUTHORIZED = 401
        static let SUCCESS = 200
        static let NOT_FOUND = 404
        static let BAD_REQUEST = 400
    }
    
    




    //CONFIG STAGING
//    #define GETWAY_SERVER_URL @"http://172.16.10.72:8892/api/queues"
//    #define CHAT_DOMAIN @"http://172.16.10.82:1483"
//    #define REALTIME_SERVER_URL @"http://172.16.10.71:1483"
//    #define UPLOAD_DOMAIN @"https://172.16.10.85"
//    #define DEFAULT_MAIN_DOMAIN @"https://beta.api.order.techres.vn"
//
    
    //    LIVE
    //        struct URL {
//                static let GETWAY_SERVER_URL = "https://api.gateway.techres.vn/api/queues"
//                static let CHAT_DOMAIN = "http://api.realtime.techres.vn:1483"
//                static let REALTIME_SERVER_URL = "http://api.realtime.techres.vn:1483"
//                static let UPLOAD_DOMAIN = "https://storage.aloapp.vn"
    //
    //        }
        
        //BETA
        struct URL {
            static let GETWAY_SERVER_URL = "http://172.16.2.243:8092/api/queues"
            static let CHAT_DOMAIN = "http://172.16.2.240:1483"
            static let REALTIME_SERVER_URL = "http://172.16.2.240:1483"
            static let UPLOAD_DOMAIN = "https://beta.storage.aloapp.vn"
        }
        
        struct Endpoints {
            static let urlConfig = "/api/configs"
            static let urlLogin = "/api/customers/login"
            static let urlCreateBooking = "/api/v2/bookings/create"
            static let urlBookings = "/api/v2/bookings"
           
            
            static let urlCreateAccount = "api/ver2/customers/register"
            static let urlOtp = "/api/ver2/customers/verify-code"
            static let urlSendOtp = "/api/ver2/customers/send-verify-code"
            static let urlUpdateInfo = "/api/ver2/customers/update-profile-register"
            
            static let groupChat = "/api/groups?limit=%d&page=%d"
            static let friendOnline = "/api/friends/online?limit=%d&page=%d"
            
            static let order = "/api/customers/\(ManageCacheObject.getCurrentUser().access_token)/orders"
        }

        
        struct KEY_DEFAULT_STORAGE{
            static let KEY_ACCOUNT = "KEY_ACCOUNT"
            static let KEY_CURRENT_POINT = "KEY_CURRENT_POINT"
            static let KEY_ACCOUNT_ID = "KEY_ACCOUNT_ID"
            static let KEY_TOKEN = "KEY_TOKEN"
            static let KEY_PUSH_TOKEN = "KEY_PUSH_TOKEN"
            static let KEY_CONFIG = "KEY_CONFIG"
            static let KEY_SETTING = "KEY_SETTING"
            static let KEY_PHONE = "KEY_PHONE"
            static let KEY_PASSWORD = "KEY_PASSWORD"
            static let KEY_BIOMETRIC = "KEY_BIOMETRIC"
            static let KEY_LOGIN = "KEY_LOGIN"
            static let KEY_LOCATION = "KEY_LOCATION"
            static let KEY_PERMISION_CONTACT = "KEY_PERMISION_CONTACT"
            static let KEY_TIME = "KEY_TIME"
            static let KEY_ACCOUNT_NODE = "KEY_ACCOUNT_NODE"
            static let KEY_TAB_INDEX = "KEY_TAB_INDEX"
            static let KEY_NUMBER_UNREAD_MESSAGE = "KEY_NUMBER_UNREAD_MESSAGE"
            
            static let KEY_BRAND = "KEY_BRAND"
            static let KEY_BRANCH = "KEY_BRANCH"
            static let KEY_RESTAURANT_NAME = "KEY_RESTAURANT_NAME"
            
        }
        
    struct LOGIN_FORM_REQUIRED{
//        static let requiredUserIDMinLength = 6
        static let requiredUserIDMinLength = 8
        static let requiredUserIDMaxLength = 10
        
        static let requiredUserNameLength = 4
        static let requiredPasswordLengthMin = 4
        static let requiredPasswordLengthMax = 20
        static let requiredPhoneMinLength = 10
        static let requiredPhoneMaxLength = 11
        
        static let requiredRestaurantMinLength = 2
        static let requiredRestaurantMaxLength = 50
        
    }
    struct PROFILE_FORM_REQUIRED{
        static let requiredFullNameMinLength = 3
        static let requiredFullNameMaxLength = 50
        
//        static let requiredUserNameLength = 4
//        static let requiredPasswordLengthMin = 4
        static let requiredPhoneMinLength = 10
        static let requiredPhoneMaxLength = 11
//        
//        static let requiredRestaurantMinLength = 4
//        static let requiredRestaurantMaxLength = 30
        
    }
    struct AREA_FORM_REQUIRED{
        static let requiredAreaNameMinLength = 2
        static let requiredAreaNameMaxLength = 20 // thay 18 -> 20
        
    }
    
    // Thêm truong giới hạn của table Area
    struct AREA_TABLE_REQUIRED{
        static let requiredAreaTableMinLength = 2
        static let requiredAreaTableMaxLength = 6
    }
    

    
    struct CATEGORY_FORM_REQUIRED{
        static let requiredUserIDMinLength = 2
        static let requiredUserIDMaxLength = 50
        
    }
    struct ADDITION_FEE_FORM_REQUIRED{
        static let requiredNoteMinLength = 2
        static let requiredNoteMaxLength = 100
        
        static let requiredDateMinLength = 9
        static let requiredDateMaxLength = 50
        
        static let requiredNameLength = 2
        static let requiredNameLengthMax = 50
        
        
    }
    struct DISCOUNT_FORM_REQUIRED{
        static let requiredDiscountPercentMinLength = 1
        static let requiredDiscountPercentMaxLength = 100
        
        static let requiredDiscountReasonMinLength = 3
        static let requiredDiscountReasonMaxLength = 50
       
        //length percent
        static let requiredDiscountPercentMaxLengthString = 3
    }
    
    struct REGISTER_FORM_REQUIRED{
        static let requiredPhoneMinLength = 10
        static let requiredPhoneMaxLength = 11
    }
    struct OTP_FORM_REQUIRED{
        static let requiredOtpLength = 4
        static let otpSuccess = "SMS đã gửi thành công"
        static let otpFail = "SMS gửi thất bại"
        
    }
    
    struct UPDATE_INFO_FORM_REQUIRED{
        static let requiredNameLength = 2
        static let requiredNameLengthMax = 50
        static let requiredGender = 3
        
        static let requiredPassword = 4
        static let requiredPasswordMin = 4
        static let requiredPasswordMax = 20
        static let requireNameMin = 2
        static let requireNameMax = 50
        static let requireEmailLength = 50
        static let requireAddressLength = 255
        static let requireAddressMin = 2
        
        static let requireEmailLengthMin = 3
        static let requireDescriptionMin = 3
        static let requireDescriptionMax = 255
    }
    
    var icon_materials = ["icon_an_uong",
                "icon_chi_tieu_hang_ngay",
                "icon_di_lai",
                "icon_giao_duc",
                "icon_my_pham",
                "icon_phi_giao_luu",
                "icon_phi_lien_lac",
                "icon_quan_ao",
                "icon_tien_dien",
                "icon_tien_nuoc",
                "icon_tien_nha",
                "icon_y_te",
                "online-shopping"]
    
    var stringsOtherMaterials = ["Ăn uống",
                    "Chi tiêu hằng ngày",
                    "Đi lại",
                    "Giáo dục",
                    "Mỹ phẩm",
                    "Giao lưu",
                    "Liên lạc",
                    "Quần áo",
                    "Tiền điện",
                    "Tiền nước",
                    "Tiền nhà",
                    "Y tế",
                    "Mua sắm"]
    
    
    
    struct PRINTER_TYPE{
        static let BAR = 0
        static let CHEF = 1
        static let CASHIER = 2
        static let FISH_TANK = 3
        static let STAMP = 4
    }
    
  
    static let REPORT_TYPE_DICTIONARY:[Int:String] = [
        REPORT_TYPE_TODAY:Utils.getCurrentDateTime().dateTimeNow,
        REPORT_TYPE_YESTERDAY:Utils.getCurrentDateTime().yesterday,
        REPORT_TYPE_THIS_WEEK:Utils.getCurrentDateTime().thisWeek,
        REPORT_TYPE_LAST_MONTH:Utils.getCurrentDateTime().lastMonth,
        REPORT_TYPE_THIS_MONTH:Utils.getCurrentDateTime().thisMonth,
        REPORT_TYPE_THREE_MONTHS:Utils.getCurrentDateTime().threeLastMonth,
        REPORT_TYPE_LAST_YEAR:Utils.getCurrentDateTime().lastYear,
        REPORT_TYPE_THIS_YEAR:Utils.getCurrentDateTime().yearCurrent,
        REPORT_TYPE_THREE_YEAR:Utils.getCurrentDateTime().threeLastYear,
        REPORT_TYPE_ALL_YEAR:""]
    
}
