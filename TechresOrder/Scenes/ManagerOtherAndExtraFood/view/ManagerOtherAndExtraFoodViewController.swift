//
//  ManagerOtherAndExtraFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 21/01/2023.
//

import UIKit

class ManagerOtherAndExtraFoodViewController: BaseViewController {
    
    var viewModel = ManagerOtherAndExtraFoodViewModel()
   var router = ManagerOtherAndExtraFoodRouter()
    
    @IBOutlet weak var view_container: UIView!
    
    @IBOutlet weak var btnOtherFood: UIButton!
    
    @IBOutlet weak var btnExtraFood: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lbl_other_food: UILabel!
    
    @IBOutlet weak var lbl_extra_food: UILabel!
    
    
    @IBOutlet weak var view_other_food: UIView!
    @IBOutlet weak var view_extra_food: UIView!
    
    @IBOutlet weak var lbl_header: UILabel!
    var order_id = 0
    var table_name = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        lbl_header.text = String(format: "#%d - %@", self.order_id, self.table_name)
        self.btnOtherFood.titleLabel?.isHidden = true
        self.btnExtraFood.titleLabel?.isHidden = true
        
        self.lbl_other_food.textColor = ColorUtils.green_online()
        
        
        self.lbl_extra_food.textColor = ColorUtils.green_transparent()
        self.view_other_food.isHidden = false
        self.view_extra_food.isHidden = true
       
        
        
        // add order proccessing when load view
         let addOtherFoodViewController = AddOtherFoodViewController(nibName: "AddOtherFoodViewController", bundle: Bundle.main)
            addOtherFoodViewController.order_id = self.order_id
            addViewController(addOtherFoodViewController)
        
        
        let extraFoodViewController = ExtraFoodViewController(nibName: "ExtraFoodViewController", bundle: Bundle.main)
        extraFoodViewController.remove()
       
        self.view.bringSubviewToFront(view_other_food)
        
        // action payment
        btnExtraFood.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.actionExtraFood()
                       }).disposed(by: rxbag)
        
        btnOtherFood.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.actionOtherFood()
                       }).disposed(by: rxbag)
        
        btnBack.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
        
    }

    func actionOtherFood() {
        self.lbl_other_food.textColor = ColorUtils.green_online()

        self.lbl_extra_food.textColor = ColorUtils.green_transparent()
        
        self.view_other_food.isHidden = false
        self.view_extra_food.isHidden = true
        
        // add order proccessing when load view
         let addOtherFoodViewController = AddOtherFoodViewController(nibName: "AddOtherFoodViewController", bundle: Bundle.main)
        addOtherFoodViewController.order_id = self.order_id
//        addChild(addOtherFoodViewController)
        addViewController(addOtherFoodViewController)
       
        
        let extraFoodViewController = ExtraFoodViewController(nibName: "ExtraFoodViewController", bundle: Bundle.main)
        extraFoodViewController.remove()
        
        
    }
    
 func actionExtraFood(){
     self.lbl_other_food.textColor = ColorUtils.green_transparent()
        
        self.lbl_extra_food.textColor = ColorUtils.green_online()

     self.view_other_food.isHidden = true
     self.view_extra_food.isHidden = false
        
        let extraFoodViewController = ExtraFoodViewController(nibName: "ExtraFoodViewController", bundle: Bundle.main)
//        extraFoodViewController.restaurant_brand_id = self.restaurant_brand_id
        extraFoodViewController.order_id = self.order_id
        self.addViewController(extraFoodViewController)
     
        let addOtherFoodViewController = AddOtherFoodViewController(nibName: "AddOtherFoodViewController", bundle: Bundle.main)
        addOtherFoodViewController.remove()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
