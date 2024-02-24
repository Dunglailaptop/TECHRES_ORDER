//
//  Observable+Extension.swift
//  ALOLINE
//
//  Created by Kelvin on 02/11/2022.
//  Copyright © 2022 OVERATE-VNTECH. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    func showAPIErrorToast() -> Observable<Element> {
        return self.do(onNext: { (event) in
        }, onError: { (error) in
            // TODO: It is possible to present information that is currently available on the Internet.
            print("\(error.localizedDescription)")
            dLog("\(error.localizedDescription)")
        }, onCompleted: {
        }, onSubscribe: {
        }, onDispose: {
        })
    }
}
