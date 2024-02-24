//
//  CreateNoteViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 01/02/2023.
//

import UIKit
import RxSwift
import RxRelay

class CreateNoteViewModel: BaseViewModel {
    private(set) weak var view: CreateNoteViewController?
    private var router: CreateNoteRouter?
    var branch_id = BehaviorRelay<Int>(value: 0)
    var status = BehaviorRelay<Int>(value: 0)
    var is_deleted = BehaviorRelay<Int>(value: 0)
    var noteRequest = BehaviorRelay<NoteRequest>(value: NoteRequest.init())
    
    
    // Khai báo biến để hứng dữ liệu từ VC
     var noteContentText = BehaviorRelay<String>(value: "")
    
    // Khai báo viến Bool để lắng nghe sự kiện và trả về kết quả thoả mãn điều kiện
    var isValidNoteContent: Observable<Bool> {
        return self.noteContentText.asObservable().map { noteContent in
            noteContent.trim().count >= 2 &&
            noteContent.trim().count <= 50
        }
    }
    // Khai báo biến để lắng nghe kết quả của cả 3 sự kiện trên
    
    var isValid: Observable<Bool> {
        return isValidNoteContent
      

    }
     
    
    
    func bind(view: CreateNoteViewController, router: CreateNoteRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
}
extension CreateNoteViewModel {
    func createUpdateNote() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.createNote(branch_id: branch_id.value, noteRequest: noteRequest.value, is_deleted: is_deleted.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
