//
//  ColorUtils.swift
//  ALOLINE
//
//  Created by kelvin on 4/10/2022.
//  Copyright © 2022 Kelvin. All rights reserved.
//

import Foundation
import UIKit
class ColorUtils{
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    static func toolbar()->UIColor{
        return hexStringToUIColor(hex: "#FFA233")
    }
    
    
    static func blueTransparent008()->UIColor{
    
        let black = hexStringToUIColor(hex: "#0072bc")
        let blackOpacity = black.withAlphaComponent(0.8)
        return blackOpacity;
    }
    
    //Hệ màu xanh
    static func green_200()->UIColor{
        return hexStringToUIColor(hex: "#95D9A1")
    }
    static func green_600()->UIColor{
        return hexStringToUIColor(hex: "#00A534")
    }
    
    static func green_400()->UIColor{
        return hexStringToUIColor(hex: "#38C05D")
    }
    
    static func green()->UIColor{
        return hexStringToUIColor(hex: "#34A853")
    }
    

    static func green_online()->UIColor{
        return hexStringToUIColor(hex: "#02bf54")
    }
    static func green_transparent()->UIColor{
        return hexStringToUIColor(hex: "#d3f0db")
    }
    static func green_report_quantity() -> UIColor {
        return hexStringToUIColor(hex: "#35A29F")
    }
    
    //hệ màu cam
    static func orange_brand_700()->UIColor{
        return hexStringToUIColor(hex: "#FFA233")
    }
    
    static func orange_brand_900()->UIColor{
        return hexStringToUIColor(hex: "#FF8B00")
    }
    static func orange_report_original() -> UIColor{
        return hexStringToUIColor(hex: "#FFA400")
    }
    
    // hệ màu đỏ
    static func red_brand() -> UIColor {
        return hexStringToUIColor(hex: "#F7002E")
    }
    //hệ màu trắng
    static func white()->UIColor{
        return UIColor.white
    }
    static func black()->UIColor{
        return UIColor.black
    }
    static func grey()->UIColor{
        return hexStringToUIColor(hex: "#D0D0D0")
    }
    static func yellow()->UIColor{
        return hexStringToUIColor(hex: "#f7bc0e")
    }
    
    //hệ màu xanh biển
    static func blue()->UIColor{
        return hexStringToUIColor(hex: "#418bca")
    }
    
    static func blue_color()->UIColor{
        return hexStringToUIColor(hex: "#418bca")
    }
    
    static func blue_brand_400()->UIColor{
        return hexStringToUIColor(hex: "#99C6E4")
    }
    
    static func blue_brand_700()->UIColor{
        return hexStringToUIColor(hex: "#0071BB")
    }
    static func blueButton()->UIColor{
        return hexStringToUIColor(hex: "#0072bc")
    }
    static func blueTransparent()->UIColor{
        let black = hexStringToUIColor(hex: "#0072bc")
        let blackOpacity = black.withAlphaComponent(0.1)
        return blackOpacity;
    }
    
 
    
    static func main_color()->UIColor{
        return hexStringToUIColor(hex: "#FF8B00")
    }
    static func main_navigabar_color()->UIColor{
        return hexStringToUIColor(hex: "#fa8f0c")
    }
    
    
    //hệ màu đỏ
    static func red_000()->UIColor{
        return hexStringToUIColor(hex: "#FFE8EC")
    }
    static func red_400()->UIColor{
        return hexStringToUIColor(hex: "#F2244A")
    }
    
    static func red_500()->UIColor{
        return hexStringToUIColor(hex: "#F7002E")
    }
    
    static func red_600()->UIColor{
        return hexStringToUIColor(hex: "#E8002E")
    }
    
    static func red_color()->UIColor{
        return hexStringToUIColor(hex: "#EA4335")
    }
    
    static func red_black_color()->UIColor{
        return hexStringToUIColor(hex: "#570b0b")
    }
    static func red_spin_color()->UIColor{
        return hexStringToUIColor(hex: "#ffb8b8")
    }

    
    static func blackTransparent()->UIColor{
        
        let black = hexStringToUIColor(hex: "#000000")
        let blackOpacity = black.withAlphaComponent(0.7)
        return blackOpacity;
    }
    
    static func pending_color()->UIColor{
        return hexStringToUIColor(hex: "#418bca")
    }
    static func booking_activity()->UIColor{
        return hexStringToUIColor(hex: "#0072bc")
    }
    
    static func waiting_payment_color()->UIColor{
        return hexStringToUIColor(hex: "#FFA233")
    }
    
    static func waiting_completed_color()->UIColor{
        return hexStringToUIColor(hex: "#EA4335")
    }
    
    static func order_detail_pending()->UIColor{
        return hexStringToUIColor(hex: "#FFA233")
    }
    
    static func order_detail_waiting_completed_color()->UIColor{
        return hexStringToUIColor(hex: "#4285F4")
    }
    
    static func order_detail_done_color()->UIColor{
        return hexStringToUIColor(hex: "#34A853")
    }
    
    static func order_detail_canceled()->UIColor{
        return hexStringToUIColor(hex: "#EA4335")
    }
    
    static func groupChatMyMessageColor()->UIColor{
        return hexStringToUIColor(hex: "#d5f1ff")
    }
    
    
    static func likeColor()->UIColor{
        return hexStringToUIColor(hex: "#2f74b5")
    }
    
    static func loveColor()->UIColor{
        return hexStringToUIColor(hex: "#ee7470")
    }
    
    static func emojiColor()->UIColor{
        return hexStringToUIColor(hex: "#f2cc66")
    }
    
    static func colorMyMessage()->UIColor{
        return hexStringToUIColor(hex:"#E3F2FD")
    }
    
    static func whiteBackGroundColor()->UIColor{
        return hexStringToUIColor(hex:"#FFFFFF")
    }
    
    static func blackBackGroundColor()->UIColor{
        return hexStringToUIColor(hex:"#000000")
    }
    
    static func buttonSeeAll()->UIColor{
        return hexStringToUIColor(hex:"#FAFAFA")
    }
    
    
    static func lightGrayBackGroundColor()->UIColor {
        return hexStringToUIColor(hex:"")
    }
    
    static func lightGrayTableView()->UIColor{
        return hexStringToUIColor(hex: "#FAFAFA")
    }
    
    static func mediumGrayBackGroundColor() -> UIColor {
        return hexStringToUIColor(hex:"")
    }
    
    static func darkGrayBackGroundColor() -> UIColor {
        return hexStringToUIColor(hex:"")
    }
    
    static func warningBackGroundColor() -> UIColor {
        return hexStringToUIColor(hex:"#FFFF8D")
    }
    
    static func ghostWhiteColor() -> UIColor {
        return hexStringToUIColor(hex:"#F8F8FF")
    }
    
    //Mã màu xám
    static func gray_600() -> UIColor {
        return hexStringToUIColor(hex:"#7D7E81")
    }
    
    static func grayColor() -> UIColor {
        return hexStringToUIColor(hex:"#BEBEBE")
    }
    
    static func lightGrayColor() -> UIColor {
        return hexStringToUIColor(hex:"#D3D3D3")
    }
    
    static func dimGrayColor() -> UIColor {
        return hexStringToUIColor(hex:"#696969")
    }
    
    static func disableGrayColor() -> UIColor {
        return hexStringToUIColor(hex:"#ebebeb")
    }
    
    
    
    static func transparentBackGrounnd() -> UIColor {
        return hexStringToUIColor(hex:"#1A000000")
    }
    
    
    static func friendItemBackgroundColor() -> UIColor {
        return hexStringToUIColor(hex:"#D6D6D6")
    }
    
    static func shadownGrayColor() -> UIColor {
        return hexStringToUIColor(hex:"#90A4AE")
    }
    
    static func buttonGrayColor() -> UIColor {
        return hexStringToUIColor(hex:"#E7E8EB")
    }
    static func buttonOrangeColor() -> UIColor {
        return hexStringToUIColor(hex:"#FF8B00")
    }
    
    static func buttonGreen() -> UIColor{
        return hexStringToUIColor(hex: "#0071BB")
    }
    static func lableBlack() -> UIColor{
        return hexStringToUIColor(hex: "#28282B")
    }
    
    static func textLabelBlue() -> UIColor{
        return hexStringToUIColor(hex: "#0071BB")
    }
    
    static func navigate_color()->UIColor{
        return hexStringToUIColor(hex: "#FFA233")
    }
    
    static func gray_400() ->UIColor{
        return hexStringToUIColor(hex: "C5C6C9")
    }
    
    //========= DEFINE COLOR ORDER STATUS ========
    static func bg_request_payment()->UIColor{
        
        let black = hexStringToUIColor(hex: "#ffa233")
        let blackOpacity = black.withAlphaComponent(0.15)
        return blackOpacity;
    }
    static func bg_waiting_payment()->UIColor{
        
        let black = hexStringToUIColor(hex: "#FF2D55")
        let blackOpacity = black.withAlphaComponent(0.15)
        return blackOpacity;
    }
    static func bg_opening()->UIColor{
        
        let black = hexStringToUIColor(hex: "#418bca")
        let blackOpacity = black.withAlphaComponent(0.15)
        return blackOpacity
    }
    static func bg_opening_merged_table()->UIColor{
        
        let black = hexStringToUIColor(hex: "#E75C6D")
        let blackOpacity = black.withAlphaComponent(0.15)
        return blackOpacity
    }
    static func random() -> UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
    
    static func randomLightColor() -> UIColor {
        return UIColor(red: .random(in: 0.5...1),
                       green: .random(in: 0.5...1),
                       blue: .random(in: 0.5...1),
                       alpha: 1.0)
    }
    
    
    static func randomDarkColor() -> UIColor {
        return UIColor(red: .random(in: 0...0.5),
                       green: .random(in: 0...0.5),
                       blue: .random(in: 0...0.5),
                       alpha: 1.0)
    }
    
    
    
    static func chartColors() -> [UIColor] {
            return [
                UIColor(hex: "5470c6"),
                UIColor(hex: "c23531"),
                UIColor(hex: "62c87f"),
                UIColor(hex: "e76f00"),
                UIColor(hex: "91c7ae"),
                UIColor(hex: "749f83"),
                UIColor(hex: "fac858"),
                UIColor(hex: "f4e001"),
                UIColor(hex: "00a2ae"),
                UIColor(hex: "bdbcbb")
            ]
        }
}
