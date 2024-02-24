//
//  FeeViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit

class FeeManagerViewController: BaseViewController {
    var viewModel = FeeManagerViewModel()
    var router = FeeManagerRouter()
    
    @IBOutlet weak var view_container: UIView!
    
    @IBOutlet weak var btn_material_fee: UIButton!
    @IBOutlet weak var btn_other_fee: UIButton!
    
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lbl_material_fee: UILabel!
    @IBOutlet weak var lbl_other_fee: UILabel!
    

    @IBOutlet weak var lbl_header: UILabel!
    
    @IBOutlet weak var material_fee_view: UIView!
    @IBOutlet weak var other_fee_view: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        actionManagementMaterial()
        // action btn_management_material
        btn_material_fee.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.actionManagementMaterial()
                       }).disposed(by: rxbag)
        
        btn_other_fee.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.actionManagementOtherFee()
                       }).disposed(by: rxbag)
        
        
        btnBack.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
        
    }

    private func actionManagementMaterial() {
        self.lbl_material_fee.textColor = ColorUtils.green_600()
        self.lbl_other_fee.textColor = ColorUtils.green_200()
        material_fee_view.addBorder(toEdges: [.bottom], color: ColorUtils.green_600(), thickness: 4)
        other_fee_view.addBorder(toEdges: [.bottom], color: ColorUtils.white(), thickness: 4)

        // add materialsFeeViewController when load view
        let materialsFeeViewController = MaterialsFeeViewController(nibName: "MaterialsFeeViewController", bundle: Bundle.main)
        addViewController(materialsFeeViewController)
        
        let otherFeeViewController = OtherFeeViewController(nibName: "OtherFeeViewController", bundle: Bundle.main)
        otherFeeViewController.remove()
    }

    private func actionManagementOtherFee() {
        self.lbl_material_fee.textColor = ColorUtils.green_200()
        self.lbl_other_fee.textColor = ColorUtils.green_600()
        material_fee_view.addBorder(toEdges: [.bottom], color: ColorUtils.white(), thickness: 4)
        other_fee_view.addBorder(toEdges: [.bottom], color: ColorUtils.green_600(), thickness: 4)

        let materialsFeeViewController = MaterialsFeeViewController(nibName: "MaterialsFeeViewController", bundle: Bundle.main)
        materialsFeeViewController.remove()
        
        // add otherFeeViewController when load view
        let otherFeeViewController = OtherFeeViewController(nibName: "OtherFeeViewController", bundle: Bundle.main)
        addViewController(otherFeeViewController)
    }
}
