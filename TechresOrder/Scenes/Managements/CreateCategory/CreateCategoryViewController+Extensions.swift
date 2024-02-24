//
//  CreateCategoryViewController+Extensions.swift
//  TechresOrder
//
//  Created by Kelvin on 01/02/2023.
//

import UIKit

extension CreateCategoryViewController: ArrayChooseViewControllerDelegate{
    func showChooseCategory(){
       
           
        let controller = ArrayChooseViewController(ExampleArray.allValues)
        
        controller.list_icons = list_icons
        controller.listString = title_array
        controller.preferredContentSize = CGSize(width: 300, height: 300)
        controller.delegate = self
        
        showPopup(controller, sourceView: btnChooseCategory)
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    func selectAt(pos: Int) {
        categoryType = pos
        viewModel.categoryType.accept(pos)
        self.textfield_category_type.text = title_array[pos]
    }
    
}
