//
//  FeeViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import RxSwift

class FeeViewController: BaseViewController {
    var viewModel = FeeViewModel()
    var router = FeeRouter()
    
    // ARC managment by rxswift (deinit)
//    let rxbag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var view_container: UIView!
    
    @IBOutlet weak var btn_filter_today: UILabel!
    @IBOutlet weak var btn_filter_yesterday: UILabel!
    @IBOutlet weak var btn_filter_thisweek: UILabel!
    @IBOutlet weak var btn_filter_thismonth: UILabel!
    @IBOutlet weak var btn_filter_lastmonth: UILabel!
    @IBOutlet weak var btn_filter_three_month: UILabel!
    @IBOutlet weak var btn_filter_this_year: UILabel!
    @IBOutlet weak var btn_filter_last_year: UILabel!
    @IBOutlet weak var btn_filter_three_year: UILabel!
    
    
    @IBOutlet weak var view_filter_today: UIView!
    @IBOutlet weak var view_filter_yesterday: UIView!
    @IBOutlet weak var view_filter_thisweek: UIView!
    @IBOutlet weak var view_filter_thismonth: UIView!
    @IBOutlet weak var view_filter_lastmonth: UIView!
    @IBOutlet weak var view_filter_three_month: UIView!
    @IBOutlet weak var view_filter_this_year: UIView!
    @IBOutlet weak var view_filter_last_year: UIView!
    @IBOutlet weak var view_filter_three_year: UIView!
    
    
    @IBOutlet weak var btnFilterToday: UIButton!
    @IBOutlet weak var btnFilterYesterday: UIButton!
    @IBOutlet weak var btnFilterThisweek: UIButton!
    @IBOutlet weak var btnFilterThismonth: UIButton!
    @IBOutlet weak var btnFilterThreeMonth: UIButton!
    @IBOutlet weak var btnFilterThisYear: UIButton!
    @IBOutlet weak var btnFilterLastYear: UIButton!
    @IBOutlet weak var btnFilterThreeYear: UIButton!
    
    
    @IBOutlet weak var btnCreate: UIButton!
    
  
    @IBOutlet weak var lbl_header: UILabel!
    

    var material_fees = [Fee]()
    var other_fees = [Fee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.report_type.accept(REPORT_TYPE_TODAY)
       
        registerCell()
        bindTableSection()
        
        btnCreate.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.viewModel.makeToCreateFeeViewController()
                       }).disposed(by: rxbag)
  
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fees()
    }
    
    @IBAction func actionFilterToday(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_today, textTitle: self.btn_filter_today)
        self.viewModel.report_type.accept(REPORT_TYPE_TODAY)
        self.viewModel.from.accept(Utils.getCurrentDateString())
        fees()
    }
    
    @IBAction func actionFilterYesterday(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_yesterday, textTitle: self.btn_filter_yesterday)
        self.viewModel.report_type.accept(REPORT_TYPE_YESTERDAY)
        self.viewModel.from.accept(Utils.getCurrentDateString())
        fees()
    }
    
    @IBAction func actionFilterThisWeek(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_thisweek, textTitle: self.btn_filter_thisweek)
        self.viewModel.report_type.accept(REPORT_TYPE_THIS_WEEK)
        self.viewModel.from.accept(Utils.getCurrentDateString())
        fees()
    }
    
    @IBAction func actionFilterThisMonth(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_thismonth, textTitle: self.btn_filter_thismonth)
        self.viewModel.report_type.accept(REPORT_TYPE_THIS_MONTH)
        self.viewModel.from.accept(Utils.getCurrentDateString())
        fees()
    }
    
    
    @IBAction func actionFilterLastMonth(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_lastmonth, textTitle: self.btn_filter_lastmonth)
        self.viewModel.report_type.accept(REPORT_TYPE_LAST_MONTH)
        self.viewModel.from.accept(Utils.getCurrentDateString())
        fees()
    }
    @IBAction func actionFilterThreeMonth(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_three_month, textTitle: self.btn_filter_three_month)
        self.viewModel.report_type.accept(REPORT_TYPE_THREE_MONTHS)
        self.viewModel.from.accept(Utils.getCurrentDateString())
        fees()
    }
    
    @IBAction func actionFilterThisYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_this_year, textTitle: self.btn_filter_this_year)
        self.viewModel.report_type.accept(REPORT_TYPE_THIS_YEAR)
        self.viewModel.from.accept(Utils.getCurrentDateString())
        fees()
    }
    
    @IBAction func actionFilterLastYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_last_year, textTitle: self.btn_filter_last_year)
        self.viewModel.report_type.accept(REPORT_TYPE_LAST_YEAR)
        self.viewModel.from.accept(Utils.getCurrentDateString())
        fees()
    }
    
    @IBAction func actionFilterThreeYear(_ sender: Any) {
        self.checkFilterSelected(view_selected: self.view_filter_three_year, textTitle: self.btn_filter_three_year)
        self.viewModel.report_type.accept(REPORT_TYPE_THREE_YEAR)
        self.viewModel.from.accept(Utils.getCurrentDateString())
        fees()
    }
    
    
    
}
