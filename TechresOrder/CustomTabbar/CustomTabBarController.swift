//
//  CustomTabBarViewController.swift
//  CustomTabBarExample
//
//  Created by Jędrzej Chołuj on 18/12/2021.
//

import UIKit
import RxSwift
import SnapKit
import ObjectMapper
import SocketIO
import JonAlert


class CustomTabBarController: UITabBarController {
    var viewModel = CustomViewModel()
    var router = CustomViewRouter()
    
    private let customTabBar = CustomTabBar()
    
    private let disposeBag = DisposeBag()
    var workingSession = WorkingSession.init()
    
    
    // ======= SETUP SOCKET REALTIME ========
    static let chatSharedInstance = SocketIOManager()
    var managerRealtime: SocketManager?
    var socketRealtime:SocketIOClient?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
            
        setupHierarchy()
        setupLayout()
        setupProperties()
        bind()
        view.layoutIfNeeded()
        
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.emplpoyee_id.accept(ManageCacheObject.getCurrentUser().id)
        
        // kiểm tra chỉ có GPBH02-OPT01 && Có quyền thu ngân hoặc chủ quán mới mở ca & đóng ca làm việc để bắt đầu làm việc ca mới.
        if(ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE && Utils.checkRoleOwnerOrCashier(permission: ManageCacheObject.getCurrentUser().permissions)){
            checkWorkingSession()
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        if(!ManageCacheObject.isLogin()){
            dLog("Not Login...........")
            let loginViewController = LoginRouter().viewController
            navigationController?.pushViewController(loginViewController, animated: true)
            NotificationCenter.default.post(Notification(name: .refreshAllTabs))
        }
        // THỰC HIỆN CONNECT SOCKET IO TRƯỚC KHI BẮT ĐẦU CÁC CHỨC NĂNG
//       setupSocketIO()
      
    }
    
    private func setupHierarchy() {
        view.addSubview(customTabBar)
    }
    
    private func setupLayout() {
        customTabBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(0)
            $0.height.equalTo(80)
        }
    }
    
    private func setupProperties() {
        tabBar.isHidden = true
        
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.addShadow()
        
        selectedIndex = 0
        let controllers = CustomTabItem.allCases.map { $0.viewController }
        setViewControllers(controllers, animated: true)
    }

    private func selectTabWith(index: Int) {
        self.selectedIndex = index
    }
    
    //MARK: - Bindings
    
    private func bind() {
        customTabBar.itemTapped
            .bind { [weak self] in self?.selectTabWith(index: $0) }
            .disposed(by: disposeBag)
    }
}
extension CustomTabBarController{
    func checkWorkingSession(){
        viewModel.checkWorkingSessions().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("check working session Success...")
                if let workingSession  = Mapper<CheckWorkingSession>().map(JSONObject: response.data){
                    dLog(workingSession.toJSON())
//                    self.presentModalDialogConfirmViewController(dialog_type: ACTIVE, title: "Đóng ca làm việc".uppercased(), content: "Ca làm việc hiện tại đã hết hạn. Vui lòng đóng ca hiện tại và mở ca mới để tiếp tục làm việc", isHideCancelButton:true)
                    if(workingSession.type == CLOSE_SHIFT){
                        self.getWorkingSession()
                    }else if(workingSession.type == OPENED_SHIFT){
                        // Tiếp tục làm việc và thực hiện assign ca làm việc cho mình hoặc đóng ca hiện tại và làm ca mới
                        self.presentModalDialogConfirmWorkingSessionViewController(order_working_session_id: workingSession.order_session_id, title: "THÔNG BÁO", content: "Hiện tại ca làm việc đang mở. Nhấn nút \"Tiếp Tục\" để làm việc với ca hiện tại hoặc nhấn nút \"Đóng Ca\" để mở ca mới ", isHideCancelButton: false)
                      
                    }else if(workingSession.type == EXPIRED_SHIFT){// Ca đã hết hạn
                        // Tiến hành đóng ca trước khi mở ca làm việc lại ( bắt buộc đóng ca hiện tại )
                        self.presentModalDialogConfirmViewController(dialog_type: ACTIVE, title: "Đóng ca làm việc".uppercased(), content: "Ca làm việc hiện tại đã hết hạn. Vui lòng đóng ca hiện tại và mở ca mới để tiếp tục làm việc", isHideCancelButton:true)
                        
//
                    }
                    
                    
                }

            }
        }).disposed(by: disposeBag)
  }
    
    func getWorkingSession(){
        viewModel.workingSessions().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("check working session Success...")
                if let workingSessions  = Mapper<WorkingSession>().mapArray(JSONObject: response.data){
                    dLog(workingSessions.toJSON())
                    if(workingSessions.count > 0){
                        //Open ca lam viec
                        self.presentModalDialogOpenWorkingSessionViewController(workingSession:workingSessions[0])
                    }else{
                        // show thong bao ban chua co ca lam viec nao vui long lien he quan ly de tao ca lam viec
                        self.presentModalDialogConfirmViewController(dialog_type: ACTIVE, title: "THÔNG BÁO", content: "Bạn chưa có ca làm việc nào. Vui lòng liên hệ quản lý để tạo ca làm việc.", isHideCancelButton: true)
                    }
                }

            }
        }).disposed(by: disposeBag)
  }
    
    func assignWorkingSession(){
        viewModel.assignWorkingSessions().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("check working session Success...")
                JonAlert.showSuccess(message: "Mở ca thành công. Bắt đầu vào ca làm việc", duration: 2.0)
//                Toast.show(message: "Mở ca thành công. Bắt đầu vào ca làm việc", controller: self)
            }
        }).disposed(by: disposeBag)
  }
    
}
extension CustomTabBarController: DialogConfirmWorkingSessionDelegate{
    
    func presentModalDialogConfirmWorkingSessionViewController(order_working_session_id:Int, title:String, content:String, isHideCancelButton:Bool) {
        let dialogConfirmWorkingSessionViewController = DialogConfirmWorkingSessionViewController()

        dialogConfirmWorkingSessionViewController.view.backgroundColor = ColorUtils.blackTransparent()
        dialogConfirmWorkingSessionViewController.dialog_title = title
        dialogConfirmWorkingSessionViewController.content = content
        dialogConfirmWorkingSessionViewController.title_btn_ok = "Tiếp tục".uppercased()
        dialogConfirmWorkingSessionViewController.title_btn_cancel = "Đóng ca".uppercased()
        dialogConfirmWorkingSessionViewController.order_working_session_id = order_working_session_id
        dialogConfirmWorkingSessionViewController.isHideCancelButton = isHideCancelButton
        dialogConfirmWorkingSessionViewController.delegate = self
            let nav = UINavigationController(rootViewController: dialogConfirmWorkingSessionViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
           
            present(nav, animated: true, completion: nil)

        }
    
    func accept(id:Int) {
        dLog("accept.....")
        self.viewModel.order_session_id.accept(id)
        self.assignWorkingSession()
       
    }
    func close() {
        dLog("close")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            let closeWorkingSessionViewController = ClosedWorkingSessionRouter().viewController as! ClosedWorkingSessionViewController
            closeWorkingSessionViewController.delegate = self
            self.navigationController?.pushViewController(closeWorkingSessionViewController, animated: true)
        }
    }
   
}
extension CustomTabBarController: DialogConfirmDelegate, TechresDelegate{
    func presentModalDialogConfirmViewController(dialog_type:Int, title:String, content:String, isHideCancelButton:Bool) {
        let dialogConfirmViewController = DialogConfirmViewController()

        dialogConfirmViewController.view.backgroundColor = ColorUtils.blackTransparent()
        dialogConfirmViewController.dialog_title = title
        dialogConfirmViewController.content = content
//        dialogConfirmViewController.title_button_ok = "Mở ca".uppercased()
        dialogConfirmViewController.dialog_type = dialog_type
        dialogConfirmViewController.isHideCancelButton = isHideCancelButton
        dialogConfirmViewController.delegate = self
        
            let nav = UINavigationController(rootViewController: dialogConfirmViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
           
            present(nav, animated: true, completion: nil)

        }
    
    func accept() {
        dLog("accept.....")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            let closeWorkingSessionViewController = ClosedWorkingSessionRouter().viewController as! ClosedWorkingSessionViewController
            closeWorkingSessionViewController.delegate = self
            self.navigationController?.pushViewController(closeWorkingSessionViewController, animated: true)
        }
        
    }
    func cancel() {
        dLog("Cancel...")
    }
    func callBackReload() {
        self.presentModalDialogOpenWorkingSessionViewController(workingSession: self.workingSession!)
    }
    
}

extension CustomTabBarController{
    func presentModalDialogOpenWorkingSessionViewController(workingSession:WorkingSession) {
        self.workingSession = workingSession
        let openWorkingSessionViewController = OpenWorkingSessionViewController()
        openWorkingSessionViewController.workingSession = workingSession
        openWorkingSessionViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: openWorkingSessionViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
           
            present(nav, animated: true, completion: nil)

        }
    
}
extension Notification.Name {
    static let refreshAllTabs = Notification.Name("RefreshAllTabs")
}
extension CustomTabBarController {
    
    func setupSocketIO(){
        // socket io here
//        SocketIOManager.sharedInstance.initSocketInstance(String(format: "/restaurants_%d_branches_%d", ManageCacheObject.getCurrentUser().restaurant_id, ManageCacheObject.getCurrentUser().branch_id), false)
        
        // == End socket io
    }
    
//    func connectSocketOauth(){
//        if(ManageCacheObject.isLogin()){
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                if let url = URL(string:APIEndPoint.Name.REALTIME_SERVER) {
//                    let auth = ["token": ManageCacheObject.getCurrentUser().jwt_token]
//                    self.managerRealtime = SocketManager(socketURL: url, config: [.log(true), .compress, .reconnects(true)])
//
//                    self.socketRealtime = self.managerRealtime!.socket(forNamespace: String(format: "/restaurants_%d_branches_%d", ManageCacheObject.getCurrentUser().restaurant_id, ManageCacheObject.getCurrentUser().branch_id))
//
//
//                    self.managerRealtime?.connectSocket(self.socketRealtime!, withPayload: auth)
//
//
////                    self.managerRealtime!.connect()
//
//                    self.socketRealtime!.on(clientEvent: .error) {data, ack in
//                          print("socket error CustomTabBarController")
//                        print(data)
//                      }
//
//
//
//                }
//            })
//        }
//
//
//    }
}
