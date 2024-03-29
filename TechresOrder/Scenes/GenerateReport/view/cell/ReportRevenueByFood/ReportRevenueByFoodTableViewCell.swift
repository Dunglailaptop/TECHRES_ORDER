//
//  ReportRevenueByFoodTableViewCell.swift
//  Techres-Seemt
//
//  Created by Nguyen Thanh Vinh on 15/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import Charts

class ReportRevenueByFoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bar_chart: BarChartView!
    @IBOutlet weak var root_view_empty_data: UIView!
    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var lbl_total_original_amount: UILabel!
    @IBOutlet weak var lbl_total_quantity: UILabel!
    
    // MARK: Biến của button filter
    @IBOutlet weak var btn_today: UIButton!
    @IBOutlet weak var btn_yesterday: UIButton!
    @IBOutlet weak var btn_this_week: UIButton!
    @IBOutlet weak var btn_this_month: UIButton!
    @IBOutlet weak var btn_last_month: UIButton!
    @IBOutlet weak var btn_last_three_month: UIButton!
    @IBOutlet weak var btn_this_year: UIButton!
    @IBOutlet weak var btn_last_year: UIButton!
    @IBOutlet weak var btn_last_three_year: UIButton!
    @IBOutlet weak var btn_all_year: UIButton!
        
    @IBOutlet weak var btn_filter_value: UIButton!
    
    var btnArray:[UIButton] = []
    
    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {  
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        
        guard let viewModel = self.viewModel else {return}
        var foodReport = viewModel.foodReport.value
        foodReport.foods = []
        foodReport.reportType = sender.tag
        foodReport.dateString = viewModel.view?.reportTypeArray[sender.tag] ?? ""
        viewModel.foodReport.accept(foodReport)
        viewModel.view?.getRevenueReportByFood()
    }
    
    func changeBgBtn(btn:UIButton){
        for button in self.btnArray{
            button.backgroundColor = ColorUtils.white()
            button.setTitleColor(ColorUtils.orange_brand_900(),for: .normal)
            
            let btnTxt = NSMutableAttributedString(string: button.titleLabel?.text ?? "",attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 12, weight: .semibold)])
        
            button.setAttributedTitle(btnTxt,for: .normal)
            button.borderWidth = 1
            button.borderColor = ColorUtils.orange_brand_900()
        }
        btn.borderWidth = 0
        btn.backgroundColor = ColorUtils.orange_brand_900()
        btn.setTitleColor(ColorUtils.white(),for: .normal)
    }
    

    
    var viewModel: GenerateReportViewModel? {
           didSet {
               guard let viewModel = self.viewModel else {return}
            
               btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
               changeBgBtn(btn: btn_this_month)
               for btn in self.btnArray{
                   btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                       self?.changeBgBtn(btn: btn)
                   }).disposed(by: disposeBag)
               }
               
               viewModel.foodReport.subscribe(onNext: { [self] report in
                   if report.foods.count > 0{
                       setupBarChart(data: report.foods, barChart: bar_chart)
                   }
                   root_view_empty_data.isHidden = report.total_amount > 0 ? true : false
               }).disposed(by: disposeBag)
           }
    }
    
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToDetailRevenueByFoodViewController()
    }
    
}


