//
//  HandlerDelegate.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit

protocol BrandDelegate {
    func callBackChooseBrand(brand:Brand)
}
protocol TechresDelegate {
    func callBackReload()
}
protocol BranchDelegate {
    func callBackChooseBranch(branch:Branch)
}
protocol CalculatorMoneyDelegate {
    func callBackCalculatorMoney(amount:Int, position:Int)
}
protocol CaculatorInputQuantityDelegate {
    func callbackCaculatorInputQuantity(number:Float, position:Int)
}
protocol ArrayChooseViewControllerDelegate {
    func selectAt(pos: Int)
}
protocol ArrayChooseVATViewControllerDelegate {
    func selectVATAt(pos: Int)
}
protocol NotFoodDelegate {
    func callBackNoteFood(pos: Int, note:String)
}

protocol ReasonCancelFoodDelegate {
    func callBackReasonCancelFood(order_detail_id: Int, is_extra_charge:Int, reason:ReasonCancel, quantity:Int)
}
protocol ReturnBeerDelegate {
    func callBackReturnBeer(note:String)
}
protocol MoveFoodDelegate {
    func callBackComfirmSelectTableNeedMoveFood(order_id: Int, destination_table_name:String, target_table_name:String, destination_table_id:Int, target_table_id:Int, target_order_id: Int)
}
protocol OrderMoveFoodDelegate {
    func callBackNavigatorViewControllerNeedMoveFood(order_id:Int, destination_table_name:String, target_table_name:String, destination_table_id:Int, target_table_id:Int, only_one:Int, target_order_id: Int)
}

protocol ArrayChooseReasonDiscountViewControllerDelegate {
    func selectReasonDiscount(pos: Int)
}
protocol OrderActionViewControllerDelegate {
    func callBackOrderAction(destination_table_id:Int, destination_table_name:String)
    func callBackOrderActionMergeTable(destination_table_id:Int, destination_table_name:String)
    func callBackComfirmMoveTable(order_id:Int, destination_table_name:String, target_table_name:String, destination_table_id:Int, target_table_id:Int)
    func callBackOrderActionSharePoint(order_id:Int, table_name:String, employeeId:Int)
    func callBackOrderActionCloseTable(table_id:Int)
}
//
protocol MoveTableDelegate {
    func callBackComfirmMoveTable(destination_table_name:String, target_table_name:String, destination_table_id:Int, target_table_id:Int)
}

protocol UpdateCustomerSloteDelegate {
    func callbackPeopleQuantity(number_slot:Int)
}
protocol DiscountDelegate {
    func callbackDiscount()
}
protocol QRCodeCashbackBillDelegate {
    func callBackQRCodeCashbackBill(order_id:Int, qrcode:String)
}
protocol DialogConfirmDelegate{
    func accept()
    func cancel()
}
protocol DialogConfirmClosedWorkingSessionDelegate{
    func closedWorkingSession()
    func cancelClosedWorkingSession()
}
protocol DialogConfirmWorkingSessionDelegate{
    func accept(id:Int)
    func close()
}
protocol ArrayChooseCategoryViewControllerDelegate {
    func selectCategoryAt(pos: Int)
}
protocol ArrayChooseUnitViewControllerDelegate {
    func selectUnitAt(pos: Int)
}

protocol ArrayChooseCityViewControllerDelegate {
    func selectCityAt(pos: Int)
}

protocol ArrayChooseDictrictViewControllerDelegate {
    func selectDictrictAt(pos: Int)
}

protocol ArrayChooseWardViewControllerDelegate {
    func selectWardAt(pos: Int)
}

protocol MonthSelectDelegate {
    func selected(month:Int, year:Int)
}

protocol AdditionDelegate{
    func additionQuantity(quantity:Int, row:Int, itemIndex:Int, countGift: Int, food_addition_type:Int)

}
protocol verifyOTPDelegate {
    // Other functions you might need
    func callback(temp: Int)
}

protocol ChooseCityDelegate{
    func callBackChooseCity(city: Cities)
}
protocol ChooseDistrictDelegate{
    func callBackChooseDistrict(district: District)
}
protocol ChooseWardDelegate{
    func callBackChooseWard(ward: Ward)
}
protocol UsedGiftDelegate{
    func callBackUsedGift(order_id:Int)
}


protocol AccountInforDelegate{
    func callBackToAcceptSelectedArea(selectedArea:[String:Area])
}

protocol MaterialDelegate{
    func callBackNoteDelete(note: String)
}
//protocol GenerateReportDelegate{
//    func callBackToAccept
//}

protocol ArrayShowDropdownViewControllerDelegate {
    func selectAt(pos: Int)
}
