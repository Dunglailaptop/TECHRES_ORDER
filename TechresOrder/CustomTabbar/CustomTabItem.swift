//
//  CustomTabItem.swift
//  CustomTabBarExample
//
//  Created by Jędrzej Chołuj on 18/12/2021.
//

import UIKit

enum CustomTabItem: String, CaseIterable {
    case general
    case order
    case area
//    case fee
    case report
    case utilities
}
 
extension CustomTabItem {
    var viewController: UIViewController {
           switch self {
           case .general:
               let view = GenerateReportViewController(nibName: "GenerateReportViewController", bundle: Bundle.main)
               return view
           case .order:
               let view = OrderViewController(nibName: "OrderViewController", bundle: Bundle.main)
               
               return view
           case .area:
               let view = AreaViewController(nibName: "AreaViewController", bundle: Bundle.main)
               
               return view
               
//           case .fee:
//               let view = FeeViewController(nibName: "FeeViewController", bundle: Bundle.main)
//
//               return view
               
           case .report:
               if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE){
                   let view = FeeViewController(nibName: "FeeViewController", bundle: Bundle.main)
                   
                   return view
               }else{
                   let view = ReportViewController(nibName: "ReportViewController", bundle: Bundle.main)
                   
                   return view
               }
               
           case .utilities:
               let view = UtilitiesViewController(nibName: "UtilitiesViewController", bundle: Bundle.main)
               
               return view
           }
       }

    
    var icon: UIImage? {
           switch self {
           case .general:
               return UIImage(named: "icon-general-tabbar")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
           case .order:
               return UIImage(named: "icon-order-tabbar")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
           case .area:
               return UIImage(named: "icon-area-tabbar")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
               
//           case .fee:
//               return UIImage(named: "icon-fee-tabbar")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
              
           case .report:
               if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE){
                   return UIImage(named: "icon-fee-tabbar")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
               }else{
                   return UIImage(named: "icon-fee-tabbar")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
               }
               
               
           case .utilities:
               return UIImage(named: "icon-utilities-tabbar")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
           }
       }

    
    var selectedIcon: UIImage? {
           switch self {
           case .general:
               return UIImage(named: "icon-general-tabbar")?.withTintColor(.white, renderingMode: .alwaysOriginal)
               
           case .order:
               return UIImage(named: "icon-order-tabbar")?.withTintColor(.white, renderingMode: .alwaysOriginal)
           case .area:
               return UIImage(named: "icon-area-tabbar")?.withTintColor(.white, renderingMode: .alwaysOriginal)
          
//           case .fee:
//               return UIImage(named: "icon-fee-tabbar")?.withTintColor(.white, renderingMode: .alwaysOriginal)
               
           case .report:
               return UIImage(named: "icon-fee-tabbar")?.withTintColor(.white, renderingMode: .alwaysOriginal)
               
           case .utilities:
               return UIImage(named: "icon-utilities-tabbar")?.withTintColor(.white, renderingMode: .alwaysOriginal)
           }
       }

    
    var name: String {
            if(self.rawValue.capitalized == "General"){
                return "Tổng quan"
            }else if(self.rawValue.capitalized == "Order"){
                return "Đơn hàng"
            }else if(self.rawValue.capitalized == "Area"){
                return "Khu vực"
                //            }else if(self.rawValue.capitalized == "Fee"){
                //                return "Chi phí"
                //            }
            } else if(self.rawValue.capitalized == "Report"){
                if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE){
                    return "Chi phí"
                }else{
                    return "Báo cáo"
                }
                
            }else if(self.rawValue.capitalized == "Utilities"){
                return "Tiện ích"
            }
            return self.rawValue.capitalized
        }
}

