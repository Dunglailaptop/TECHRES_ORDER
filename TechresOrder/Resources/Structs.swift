//
//  Structs.swift
//  ALOLINE
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 11/10/2022.
//  Copyright © 2022 Android developer. All rights reserved.
//


import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

public struct APIEndPoint {
    
    static let endPointURL = Environment.develop.rawValue
    static let enviromentMod = EnvironmentMode.develop.rawValue
    static let endPointRealTimeURL = EnvironmentRealtime.develop.rawValue
    
    private enum Environment:String {
        case develop = "https://beta.api.gateway.overate-vntech.com"
        case staging = "http://172.16.10.72:7080"
        case production = "https://api.gateway.overate-vntech.com"
    }
    
    private enum EnvironmentMode:Int {
        case develop = 0
        case staging = 2
        case production = 1
    }
    
    private enum EnvironmentRealtime:String {
        case develop = "https://beta.realtime.order.techres.vn"
        case staging = "http://172.16.10.71:1483"
        case production = "http://api.realtime.techres.vn:1483"
    }
    
    struct  ORDER_STATUS {
        static let order_status_proccessing = "0,1,3,4,6"
        static let order_status_completed = "2,5,7"
    }
    struct  ORDER_STATUS_ENUM {
        static let  COMPLETED = 2
        static let  WAITING_PAYMENT = 4
        static let  DEBT_BILL = 5
        static let  WAITING_COMFIRED = 6
    }
    
    
    struct  MESSAGE_STYPE_ENUM {
        static let  SUCCESS = 0
        static let  INFO = 1
        static let  WARNING = 2
        static let  FAIL = 3
    }
    
   
    
    
        private static let version = "v4"
        private static let report_api_version = "v2"
        private static let upload_api_version = "v2"
        //VERSION SEEMT
        private static let version_report_service = "v2"
        private static let version_upload_service = "v2"
        private static let version_check_data = "v1"
    
    
    struct Name {
        static let REALTIME_SERVER = endPointRealTimeURL
        static let GATEWAY_SERVER_URL = endPointURL
        
        static let urlSessions = String(format: "/api/%@/sessions", version)
        static let urlConfig = String(format: "/api/%@/configs", version)
        static let urlRegisterDevice =  String(format: "/api/%@/register-device", version)
        static let urlCheckVersion = String(format: "/api/%@/check-version", version)
       
        static let urlLogin = String(format: "/api/%@/employees/login", version)
        static let urlSetting = String(format: "/api/%@/employees/settings", version)
        
        static let urlBrands = String(format: "api/%@/restaurant-brands",version)
        static let urlBranches = String(format: "/api/%@/branches", version)
        static let urlBranchesInfo = "/api/\(version)/branches/%d"
        static let urlOrder = "/api/\(version)/orders/%d"
        
        //Define Area Screen
//        static let urlAreas = "/api/medium/application/areas"
        static let urlAreas =  String(format: "/api/%@/areas", version )
        static let urlTables =  String(format: "/api/%@/tables",version)
        
        
        //Define Order Screen
        static let urlOrders = String(format: "/api/%@/orders",version )
        
        static let urlOrderDetail = "/api/\(version)/orders/%d"
        
        //Define Food Screen
        static let urlFoods = String(format: "/api/%@/foods", version)
        
        static let urlAddFoodsToOrder = "/api/\(version)/orders/%d/add-food"
        static let urlAddGiftFoodsToOrder = "/api/\(version)/orders/%d/gift-food"
        static let urlKitchenes = String(format: "/api/%@/restaurant-kitchen-places",version )
        static let urlVAT = String(format: "/api/%@/restaurant-vat-configs",version )
        
        static let urlAddOtherFoodsToOrder = "/api/\(version)/orders/%d/add-special-food"
        static let urlAddNoteToOrderDetail = "/api/\(version)/order-details/%d/note"
        static let urlReasonCancelFoods = String(format: "/api/%@/orders/cancel-reasons",version )
        static let urlCancelFood = "/api/\(version)/orders/%d/cancel-order-detail"
        static let urlCancelExtraCharge = "/api/\(version)/order-extra-charges/%d/cancel-extra-charge"
        static let urlUpdateFood = "/api/\(version)/orders/%d/update-multi-order-detail"
        static let urlOrderNeedMove =  "/api/\(version)/orders/%d/order-detail-move"
        static let urlMoveFoods =  "/api/\(version)/tables/%d/move-food"
        static let urlOrderDetailPayment =  "/api/\(version)/orders/%d"
        static let urlOpenTable =  "/api/\(version)/tables/%d/open"
        static let urlDiscount = "/api/\(version)/orders/%d/apply-discount"
        static let urlMoveTable = "/api/\(version)/tables/%d/move"
        
        static let urlMergeTable = "/api/\(version)/tables/%d/merge"
        static let urlProfile = "/api/\(version)/employees/%d"
        
        static let urlExtraCharges = "/api/\(version)/restaurant-extra-charges"
        static let urlAddExtraCharges = "/api/\(version)/order-extra-charges/%d/add-extra-charges"
        static let urlReturnBeer = "/api/\(version)/orders/%d/return-beer"

        static let urlReviewFood = "/api/\(version)/orders/%d/review-order-details"
        static let urlGetFoodsNeedReview = "/api/\(version)/orders/%d/customer-review"
        static let urlUpdateCustomerNumberSlot = "/api/\(version)/orders/%d/update-customer-slot-number"
        static let urlRequestPayment = "/api/\(version)/orders/%d/request-payment"
        static let urlCompletedPayment = "/api/\(version)/orders/%d/complete"
       
        static let urlTablesManagement = String(format:"/api/%@/tables/manage",version )
        static let urlCreateArea = String(format: "/api/%@/areas/manage",version )
        
        static let urlAllFoodsManagement = String(format: "/api/%@/foods/branch",version )
        static let urlAllNotesManagement = "/api/\(version)/order-detail-notes"
        static let urlAllCategoriesManagement = "/api/\(version)/categories"
        
        static let urlPrinters = String(format: "/api/%@/restaurant-kitchen-printers",version )
        
        static let urlOpenWorkingSession = String(format: "/api/%@/order-session/open-session",version )
        static let urlWorkingSession = "/api/\(version)/employees/%d/branch-working-sessions"
        static let urlCheckWorkingSessions = String(format: "/api/%@/order-session/check-working-session",version )
        static let urlSharePoint = "/api/\(version)/orders/%d/share-point"
        
        static let urlCurrentPoint = "/api/\(version)/employees/%d/next-salary-target"
        
        static let urlAssignCustomerToBill = "/api/\(version)/orders/%d/assign-to-customer"
        static let urlApplyVAT = "/api/\(version)/orders/%d/apply-vat"
        static let urlFees = String(format: "/api/%@/addition-fees",version )
        static let urlCreateFee = String(format: "/api/%@/addition-fees/create",version )
        
        static let urlFoodsNeedPrint = String(format: "/api/%@/orders/is-print",version )
        static let urlRequestPrintChefBar = "/api/\(version)/orders/%d/print"
        static let urlUpdateReadyPrinted = String(format: "/api/%@/orders/is-print",version )
        static let urlEmployees = String(format: "/api/%@/employees",version )
        static let urlKitchens = String(format: "/api/%@/restaurant-kitchen-places",version )
        static let urlUpdateKitchen = "/api/\(version)/restaurant-kitchen-places/%d"
        static let urlUpdatePrinter = "/api/\(version)/restaurant-kitchen-printers/%d/update"
        static let urlCreateUpdateNote = String(format:"/api/%@/order-detail-notes/manage",version )
        static let urlCreateCategory = String(format: "/api/%@/categories/create",version )
        static let urlOrdersHistory = "/api/\(version)/employees/%d/orders-history"
        static let urlUnits = String(format: "/api/%@/foods/unit",version )
        static let urlUpdateCategory = "/api/\(version)/categories/%d/update"
        
        static let urlCreateFood = String(format: "/api/%@/foods/create",version )
        static let urlEditFood =  "/api/\(version)/foods/%d/update"
        static let urlCities = String(format: "/api/%@/administrative-units/cities",version )
        static let urlDistrict = String(format: "/api/%@/administrative-units/districts",version )
        static let urlWards = String(format: "/api/%@/administrative-units/wards",version )
        static let urlUpdateProfile = "/api/\(version)/employees/%d/change-profile"
        static let urlUpdateProfileInfo = "/api/\(version)/employee-profile/%d"
        
        static let urlChangePassword = "/api/\(version)/employees/%d/change-password"
        static let urlCloseTable = "/api/\(version)/tables/%d/close"
        
        static let urlFeedbackAndSentError = String(format: "/api/%@/employees/feedback",version )
        static let urlWorkingSessionValue = String(format: "/api/%@/order-session/working-session-value",version )
        static let urlCloseWorkingSession = String(format: "/api/%@/order-session/close-session",version )
        
        static let urlAssignWorkingSession = String(format: "/api/%@/order-session-employees/create",version )
        
        static let urlForgotPassword = String(format: "/api/%@/employees/forgot-password",version )
        static let urlVerifyOTP = String(format: "/api/%@/employees/verify-code", version)
        static let urlVerifyPassword = String(format: "/api/%@/employees/verify-change-password", version)
        //static let urlNotes = String(format: "/api/%@/food-notes", version)
        static let urlNotes = String(format: "/api/%@/order-detail-notes", version)// tagview
        
        static let urlGift = String(format: "/api/%@/customer-gifts/qr-code-gift", version)
        static let urlUseGift = "/api/\(version)/orders/%d/use-customer-gift-food"
        
        static let urlTableManage = String(format: "/api/%@/tables/manage", version)
        
        static let urlNotesByFood = "/api/\(version)/food-notes/by-food-id/%d"
        static let urlVATDetails = "/api/\(version)/orders/%d/order-detail-by-vat-percent"
       
        static let urlGenerateLink = "/api/\(upload_api_version)/media/generate"
        static let urlUpdateOtherFeed = "/api/\(version)/addition-fees/%d"
        
        static let urlGetAdditionFee = "/api/\(version)/addition-fees/%d"
        static let urlUpdateAdditionFee = "/api/\(version)/addition-fees/%d/update"
        static let urlCancelAdditionFee = "/api/\(version)/addition-fees/%d/change-status" // chi phí nguyên liệu và chi phí khác
        static let urlUpdateOtherFee = "/api/\(version)/addition-fees/%d/update" // update chi phí khác

        static let urlMoveExtraFoods =  "/api/\(version)/order-extra-charges/%d/move"
        
        static let urlGetFoodsBookingStatus = "api/\(version)/order-details/%d/booking" //v4 lấy danh sách food khi trạng thái bàn booking
        
        static let urlUpdateBranch = "api/\(version)/branches/%d" // update branch

        static let urlHealthCheckChangeFromServer = "/api/\(version_check_data)/food-health-check/check" // Kiểm tra xem server cho thay đổi món ăn không để lấy menu mới về
    }
    struct NameReportEndPoint {
        
        // ========= API REPORT ==========
        
        static let urlReportRevenueByBrand = "/api/\(report_api_version)/order-restaurant-current-day"
        static let urlReportRevenueByTime = "/api/\(report_api_version)/order-restaurant-revenue-report"
        static let urlReportRevenueActivitiesInDayByBrand = String(format: "/api/\(report_api_version)/order-restaurant-revenue-cost-customer-by-branch")
        
        
        static let urlReportRevenueFeeProfit = "/api/\(report_api_version)/order-revenue-cost-profit-by-branch"
        static let urlReportRevenueByCategory = "/api/\(report_api_version)/order-restaurant-revenue-by-category"
        static let urlReportRevenueByEmployee = "/api/\(report_api_version)/order-revenue-current-by-employee"
        static let urlReportBusinessAnalytics = "/api/\(report_api_version)/order-restaurant-revenue-by-food"
        
        static let urlReportRevenueByAllEmployees = "/api/\(report_api_version)/order-restaurant-revenue-by-employee"
        
        static let urlReportFoods = "/api/\(report_api_version)/order-report-food"
        static let urlReportCancelFoods = "/api/\(report_api_version)/order-report-food-cancel-mobile"
        static let urlReportGiftedFoods = "/api/\(report_api_version)/order-report-food-gift-mobile"
        static let urlReportDiscount = "/api/\(report_api_version)/order-restaurant-discount-from-order"
        static let urlReportVAT = "/api/\(report_api_version)/restaurant-vat-report"

        static let urlReportAreaRevenue = "/api/\(report_api_version)/window-area-revenue-rank"
        static let urlReportTableRevenue = "/api/\(report_api_version)/order-restaurant-revenue-by-table"
        
        
        //api report seemt====================
        static let urlOrderReportFood = "/api/\(version_report_service)/order-report-food" // Báo cáo món ăn, đồ uống, món khác
        static let urlOrderReportFoodCancel = "/api/\(version_report_service)/order-report-food-cancel" // Báo cáo món huỷ //@2
        static let urlOrderReportFoodGift = "/api/\(version_report_service)/order-report-food-gift" // Báo cáo món tặng //@3
        static let urlOrderReportFoodTakeAway = "/api/\(version_report_service)/order-report-food-take-away" // Báo cáo món ăn mang về //@4
        static let urlGetRevenueDetailByBrandId = "/api/\(version_upload_service)/order-restaurant-revenue-detail-by-restaurant-brand" // Doanh thu bán hàng trong ngày theo thương hiệu //@6
        static let urlGetRevenueDetailByBranch = "/api/\(version_upload_service)/order-restaurant-revenue-by-branch" // Doanh thu bán hàng trong ngày theo chi nhánh //@7
        static let urlGetRestaurantRevenueCostProfitEstimation = "/api/\(version_report_service)/order-restaurant-revenue-cost-profit/estimate" // Báo cáo doanh thu chi phí lợi nhuận ước tính //@8
        static let urlGetRestaurantRevenueCostProfitSum = "/api/\(version_report_service)/order-restaurant-revenue-cost-profit-synthetic" // Báo cáo doanh thu chi phí lợi nhuận tổng //@9
        // ============================ HẢI THANH API REPORT ============================
        static let urlReportOrderRestaurantDiscountFromOrder = "/api/\(version_report_service)/order-restaurant-discount-from-order" // Báo cáo lấy chi tiết các khoản chi phí của nhà hàng || Báo cáo giảm giá //@10
        static let urlReportRevenueGenral = "/api/\(version_report_service)/order-restaurant-revenue-report" // Báo cáo lấy doanh thu nhà hàng theo chi nhánh //@11
        static let urlReportRevenueArea = "/api/\(version_report_service)/order-restaurant-revenue-by-area" // Báo cáo lợi nhuận bán hàng theo khu vực //@12
        static let urlReportSurcharge = "/api/\(version_report_service)/order-restaurant-order-extra-charge" // Báo cáo phụ thu //@13
        static let urlRestaurantVATReport = "/api/\(version_report_service)/window-order-report-data/vat" // Báo cáo VAT //@14
        static let urlOrderCustomerReport = "/api/\(version_report_service)/order-customer-report" // Báo cáo lấy chi tiết các khoản chi phí của nhà hàng //@15
        // ========= API P&L REPORT ==========
        static let urlRestaurantPLReport = "/api/\(version_report_service)/restaurant-p-and-l-report" // Báo cáo P&L //@16
        // ========= API INVENTORY REPORT ==========
        static let urlWarehouseSessionImportReport = "/api/\(version_report_service)/warehouse-session-import" // Báo cáo nhập kho//@17
        
        // ========= API REVENUE EMPLOYEE REPORT ==========
        static let urlRenueByEmployeeReport = "/api/\(version_report_service)/order-restaurant-revenue-by-employee" //Báo cáo doanh thu nhân viên //@18
        static let urlReportRevenueProfitFood = "/api/\(version_report_service)/order-restaurant-revenue-by-food" // Báo cáo lợi nhuận món ăn //@
        static let urlGetRestaurantRevenueCostProfitReality = "/api/\(version_report_service)/order-restaurant-revenue-cost-profit/reality" // Báo cáo doanh thu chi phí lợi nhuận thực tế
        
     

    }
    
    struct SOCKET_GATEWAY {
        static let CHAT_DOMAIN = "http://172.16.2.240:9013"
    }
    
   
}

enum RRSortEnum: Int {
    case asc
    case desc

    var title: String? {
        switch self {
        case .asc:
            return "Ascending"
        case .desc:
            return "Descending"
        }
    }
}
