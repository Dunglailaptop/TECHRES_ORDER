//
//  ManagerCategoryFoodNoteViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit

class ManagerCategoryFoodNoteViewController: BaseViewController {
    var viewModel = ManagerCategoryFoodNoteViewModel()
    var router = ManagerCategoryFoodNoteRouter()
    @IBOutlet weak var view_container: UIView!
    
    @IBOutlet weak var btn_management_category: UIButton!
    
    @IBOutlet weak var btn_management_food: UIButton!
    
    @IBOutlet weak var btn_management_note: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lbl_management_category: UILabel!
    
    @IBOutlet weak var lbl_management_food: UILabel!
    @IBOutlet weak var lbl_management_note: UILabel!
    
    
    @IBOutlet weak var view_management_category: UIView!
    @IBOutlet weak var view_management_food: UIView!
    @IBOutlet weak var view_management_note: UIView!
    
    @IBOutlet weak var lbl_header: UILabel!
    
    @IBOutlet weak var view_nodata_food: UIView!
    
    static var isCheckDataFood = false
    //    @IBOutlet weak var lbl_branch_name: UILabel!
//    @IBOutlet weak var lbl_branch_address: UILabel!
//
//    @IBOutlet weak var branch_avatar: UIImageView!
//    @IBOutlet weak var btn_choose_branch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        actionManagementCategory()
        
        // action btn_management_category
        btn_management_category.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.actionManagementCategory()
                       }).disposed(by: rxbag)
        
        btn_management_food.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.actionManagementFood()
                        //day
                       }).disposed(by: rxbag)
        
        btn_management_note.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.actionManagementNote()
                       }).disposed(by: rxbag)
        
        btnBack.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
    }

    func actionManagementCategory() {
        self.lbl_management_category.textColor = ColorUtils.green_online()

        self.lbl_management_food.textColor = ColorUtils.green_transparent()
        self.lbl_management_note.textColor = ColorUtils.green_transparent()

        self.view_management_category.isHidden = false
        self.view_management_food.isHidden = true
        self.view_management_note.isHidden = true

        // add order proccessing when load view
        let categoryManagementViewController = CategoryManagementViewController(nibName: "CategoryManagementViewController", bundle: Bundle.main)
//        categoryManagementViewController.branch_id = self.viewModel.branch_id.value

        addViewController(categoryManagementViewController)


        let foodManagementViewController = FoodManagementViewController(nibName: "FoodManagementViewController", bundle: Bundle.main)
        foodManagementViewController.remove()
        
        
        let noteManagementViewController = NoteManagementViewController(nibName: "NoteManagementViewController", bundle: Bundle.main)
        noteManagementViewController.remove()
        
    }
    
    func actionManagementFood() {
        self.lbl_management_food.textColor = ColorUtils.green_online()
        
        self.lbl_management_category.textColor = ColorUtils.green_transparent()
        self.lbl_management_note.textColor = ColorUtils.green_transparent()

        self.view_management_category.isHidden = true
        self.view_management_food.isHidden = false
        self.view_management_note.isHidden = true

        
        
        let foodManagementViewController = FoodManagementViewController(nibName: "FoodManagementViewController", bundle: Bundle.main)
        addViewController(foodManagementViewController)
        
        let categoryManagementViewController = CategoryManagementViewController(nibName: "CategoryManagementViewController", bundle: Bundle.main)
//        categoryManagementViewController.branch_id = self.viewModel.branch_id.value

        categoryManagementViewController.remove()

        
        
        let noteManagementViewController = NoteManagementViewController(nibName: "NoteManagementViewController", bundle: Bundle.main)
        noteManagementViewController.remove()
        
    }
  
    func actionManagementNote() {
        self.lbl_management_category.textColor = ColorUtils.green_transparent()

        self.lbl_management_food.textColor = ColorUtils.green_transparent()
        self.lbl_management_note.textColor = ColorUtils.green_online()

        self.view_management_category.isHidden = true
        self.view_management_food.isHidden = true
        self.view_management_note.isHidden = false

        // add order proccessing when load view
        let categoryManagementViewController = CategoryManagementViewController(nibName: "CategoryManagementViewController", bundle: Bundle.main)
//        categoryManagementViewController.branch_id = self.viewModel.branch_id.value

        categoryManagementViewController.remove()


        let foodManagementViewController = FoodManagementViewController(nibName: "FoodManagementViewController", bundle: Bundle.main)
        foodManagementViewController.remove()
        
        
        let noteManagementViewController = NoteManagementViewController(nibName: "NoteManagementViewController", bundle: Bundle.main)
        addViewController(noteManagementViewController)
        
    }

}
