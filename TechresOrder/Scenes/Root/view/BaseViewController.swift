//
//  BaseViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper
//import FirebaseCrashlytics

class BaseViewController: UIViewController {
   var viewModels = BaseViewModel()
    var window: UIWindow?
    
    var mySceneDelegate: RestartApp?
    
    enum ExampleArray : String {
        
        case north, east, south, west,wests,westss,westsss
        
        static var allValues = [ExampleArray.north, .east, .south, .west, .wests, .westss, .westsss]
        
    }
    
    
    // MARK: - Variable -
    // ARC managment by rxswift (deinit)
    let rxbag = DisposeBag()
    
    
    var working_session = 0
    
    // MARK: - View Life Cycle -
    override open func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = ColorUtils.white()
                
        setNeedsStatusBarAppearanceUpdate()
        
        modalPresentationStyle = .fullScreen
        
        view.tintAdjustmentMode = .normal
        
        
        self.navigationController?.isNavigationBarHidden = true

      
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
   
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        Crashlytics.crashlytics().setCustomValue("Crashlytics", forKey: "TECHRES-ORDER")
//        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
        super.viewWillDisappear(animated)
    }
    
    func navigatorToRootViewController(){
        let viewController = CustomTabBarController()
       self.navigationController?.pushViewController(viewController, animated: true)
        
//        let frame = UIScreen.main.bounds
//       window = UIWindow(frame: frame)
//
//        navigationController!.setViewControllers([SplashScreenViewController()], animated: true)
//        window?.rootViewController = navigationController
//        window?.makeKeyAndVisible()
        
    }
   
    
   
    
    // MARK: - Memory Release -
    deinit {
        print("Memory Release : \(String(describing: self))\n" )
    }
}
extension BaseViewController{
    func getCurrentPoint(employee_id:Int){
        viewModels.getCurrentPoint(employee_id: employee_id).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let currentPoint = Mapper<NextPoint>().map(JSONObject: response.data) {
                    dLog(currentPoint.toJSON())
                    ManageCacheObject.saveCurrentPoint(currentPoint)
                }
            }else if(response.code == RRHTTPStatusCode.unauthorized.rawValue || response.code == RRHTTPStatusCode.forbidden.rawValue){
                dLog(response.message ?? "")
                let loginViewController = LoginRouter().viewController
                self.navigationController?.pushViewController(loginViewController, animated: true)
                
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}


extension BaseViewController{
    func presentModalDialogFindPrinterViewController() {
        let dialogFindPrinterViewController = DialogFindPrinterViewController()

        dialogFindPrinterViewController.view.backgroundColor = ColorUtils.blackTransparent()
     
            let nav = UINavigationController(rootViewController: dialogFindPrinterViewController)
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

extension BaseViewController{
    func loadMainView() {
        let viewController = CustomTabBarController()
        
        // This is to get the SceneDelegate object from your view controller
           // then call the change root view controller function to change to main tab bar
           (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        
//       self.navigationController?.pushViewController(viewController, animated: true)
        
   }
    
    func logout(){
        
        // clean all data local store befored logout 
        DbHelper.sharedDbHelper.deleteAll()
        
        ManageCacheObject.saveCurrentPoint(NextPoint()!)
        ManageCacheObject.saveCurrentBrand(Brand())
        ManageCacheObject.saveCurrentBranch(Branch())
        ManageCacheObject.setSetting(Setting()!)
//        var account = Account()
//        account.id = 0
//        account.access_token = ""
//        account.jwt_token = ""
     
        
        ManageCacheObject.saveCurrentUser(Account())
        ManageCacheObject.setConfig(Config()!)
        
//        var viewControllers = navigationController?.viewControllers
//        viewControllers?.removeAll()
        
//        navigationController?.setViewControllers(viewControllers!, animated: true)
        
        let loginViewController = LoginRouter().viewController
//        navigationController?.pushViewController(loginViewController, animated: true)
        
        
        // This is to get the SceneDelegate object from your view controller
           // then call the change root view controller function to change to main tab bar
           (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginViewController)
        
        
        
        
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(SplashScreenViewController())
        
    }

    func restart()
    {
//      let window = getWindow()
//        self.navigationController!.setViewControllers([SplashScreenViewController()], animated: true)
//        window?.rootViewController = navigationController
//        window?.makeKeyAndVisible()
        
        // iOS13 or later
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            self.navigationController!.setViewControllers([SplashScreenViewController()], animated: true)
            sceneDelegate.window!.rootViewController = navigationController
        }
        
    }
    
    func getWindow() -> UIWindow? {
       return UIApplication.shared.keyWindow
   }
    
}

