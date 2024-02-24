//
//  CustomTabBar.swift
//  CustomTabBarExample
//
//  Created by Jędrzej Chołuj on 18/12/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class CustomTabBar: UIStackView {
    
    var itemTapped: Observable<Int> { itemTappedSubject.asObservable() }
    
    
//      private lazy var customItemViews: [CustomItemView] = [generalItem, orderItem, areaItem, feeItem, reportItem, utilitiesItem]
    private lazy var customItemViews: [CustomItemView] = [generalItem, orderItem, areaItem, reportItem, utilitiesItem]


    
    private let generalItem = CustomItemView(with: .general, index: 0)
    private let orderItem = CustomItemView(with: .order, index: 1)
    private let areaItem = CustomItemView(with: .area, index: 2)
    private let reportItem = CustomItemView(with: .report, index: 3)
    private let utilitiesItem = CustomItemView(with: .utilities, index: 4)
    
    
    private let itemTappedSubject = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        
        setupHierarchy()
        setupProperties()
        bind()
        
        setNeedsLayout()
        layoutIfNeeded()
//        selectItem(index: 0)
        setCurrentTab()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupHierarchy() {
        // GPQT
        if ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_ONE {
//            if (Utils.checkRoleOwner(permission: ManageCacheObject.getCurrentUser().permissions)) {// Quyền chủ nhà hàng
//                addArrangedSubviews([ orderItem, areaItem, utilitiesItem])
//            } else {
//                addArrangedSubviews([ orderItem, areaItem, reportItem, utilitiesItem])
//            }
            addArrangedSubviews([ orderItem, areaItem, reportItem, utilitiesItem])
        }else{//GPBH
            if (Utils.checkRoleOwner(permission: ManageCacheObject.getCurrentUser().permissions)) {// Quyền chủ nhà hàng
                addArrangedSubviews([generalItem, orderItem, areaItem, reportItem, utilitiesItem])
            }else{
                addArrangedSubviews([orderItem, areaItem, reportItem, utilitiesItem])
            }
           
        }

       }
       
       private func setCurrentTab(){
           
           if ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_ONE {
               self.orderItem.animateClick {
                   self.selectItem(index: self.orderItem.index)
               }
           } else {
               if (Utils.checkRoleOwner(permission: ManageCacheObject.getCurrentUser().permissions)) {
                   self.generalItem.animateClick {
                       self.selectItem(index: self.generalItem.index)
                   }
                   
               } else {
                   self.orderItem.animateClick {
                       self.selectItem(index: self.orderItem.index)
                   }
               }
           }
           
       }

    
    private func setupProperties() {
        distribution = .fillEqually
        alignment = .center
        
        backgroundColor = .systemIndigo
       
        setupCornerRadius(20)
        
        customItemViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
        }
    }
    
    private func selectItem(index: Int) {
        customItemViews.forEach { $0.isSelected = $0.index == index }
        itemTappedSubject.onNext(index)
    }
    
    //MARK: - Bindings
    
    private func bind() {
            generalItem.rx.tapGesture()
                .when(.recognized)
                .bind { [weak self] _ in
                    guard let self = self else { return }
                    self.generalItem.animateClick {
                        self.selectItem(index: self.generalItem.index)
                    }
                }
                .disposed(by: disposeBag)
            
            orderItem.rx.tapGesture()
                .when(.recognized)
                .bind { [weak self] _ in
                    guard let self = self else { return }
                    self.orderItem.animateClick {
                        self.selectItem(index: self.orderItem.index)
                    }
                }
                .disposed(by: disposeBag)
            
            areaItem.rx.tapGesture()
                .when(.recognized)
                .bind { [weak self] _ in
                    guard let self = self else { return }
                    self.areaItem.animateClick {
                        self.selectItem(index: self.areaItem.index)
                    }
                }
                .disposed(by: disposeBag)
            
//            feeItem.rx.tapGesture()
//                .when(.recognized)
//                .bind { [weak self] _ in
//                    guard let self = self else { return }
//                    self.feeItem.animateClick {
//                        self.selectItem(index: self.feeItem.index)
//                    }
//                }
//                .disposed(by: disposeBag)
            
            reportItem.rx.tapGesture()
                .when(.recognized)
                .bind { [weak self] _ in
                    guard let self = self else { return }
                    self.reportItem.animateClick {
                        self.selectItem(index: self.reportItem.index)
                    }
                }
                .disposed(by: disposeBag)
            
            utilitiesItem.rx.tapGesture()
                .when(.recognized)
                .bind { [weak self] _ in
                    guard let self = self else { return }
                    self.utilitiesItem.animateClick {
                        self.selectItem(index:self.utilitiesItem.index)
                    }
                }
                .disposed(by: disposeBag)
            
           
        }
}
