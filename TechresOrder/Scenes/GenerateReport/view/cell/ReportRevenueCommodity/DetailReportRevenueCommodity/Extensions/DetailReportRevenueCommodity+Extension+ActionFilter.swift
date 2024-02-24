////
////  DetailReportRevenueCommodity+Extension+ActionFilter.swift
////  Techres-Seemt
////
////  Created by Huynh Quang Huy on 16/05/2023.
////  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
////
//
//import UIKit
//import RxRelay
//
//
//extension DetaiRevenueCommodityViewController: ArrayChooseViewControllerDelegate{
//    func showChooseType(button: UIButton, heigth: Int, filterType: [String]){
//
//        let controller = ArrayChooseTypeViewController(Direction.allValues)
//
//        controller.listString = filterType
//        controller.preferredContentSize = CGSize(width: 100, height: heigth)
//        controller.delegate = self
//
//        showPopup(controller, sourceView: button)
//    }
//
//    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
//        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
//        presentationController.sourceView = sourceView
//        presentationController.sourceRect = sourceView.bounds
//        presentationController.permittedArrowDirections = .up
//        self.present(controller, animated: true)
//    }
//
//    func selectAt(pos: Int) {
//        sortDataAndSetUpChartByFilterType(filterType: pos)
//    }
//
//
//    func sortDataAndSetUpChartByFilterType(filterType:Int){
//        var report = viewModel.report.value
//        if(filterType == 0){
//            report.filterType = 0
//            report.foods.sort { $0.total_original_amount > $1.total_original_amount }
//        }else if(filterType == 1){
//            report.filterType = 1
//            report.foods.sort { $0.total_amount > $1.total_amount }
//        }else if (filterType == 2){
//            report.filterType = 2
//            report.foods.sort { $0.quantity > $1.quantity }
//        }
//        viewModel.report.accept(report)
//        setupBarChart(data: viewModel.report.value.foods, barChart: bar_chart)
//    }
//
//}
