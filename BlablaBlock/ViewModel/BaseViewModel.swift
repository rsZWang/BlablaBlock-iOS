//
//  BaseViewModel.swift
//  BlablaBlock
//
//  Created by Harry on 2021/12/19.
//

import RxCocoa
import RxSwift

public class BaseViewModel: NSObject {
    
    internal var disposeBag: DisposeBag!
    let errorMessageObservable = PublishRelay<String>()
    
    override init() {
        super.init()
        disposeBag = DisposeBag()
    }
    
    func refreshBag() {
        disposeBag = nil
        disposeBag = DisposeBag()
    }
    
    internal func errorCodeHandler(_ response: ResponseFailure) {
        errorCodeHandler(code: response.code, msg: response.msg)
    }
    
    internal func errorCodeHandler(code: Int, msg: String) {
        Timber.w("Error: \(code) \(msg)")
        var string: String
        switch code {
        case 1001:
            string = "登入失敗"
        case 1002:
            string = "註冊失敗"
        case 1003:
            string = "寄送驗證信件失敗"
        case 1004:
            string = "重設密碼失敗，使用者不存在"
        case 1005:
            string = "重設密碼失敗"
        case 1008:
            string = "此信箱尚未註冊"
        case 501:
            string = "綁定失敗"
        default:
            string = "未知錯誤(\(msg))"
        }
        string += "(\(code))"
        errorMessageObservable.accept(string)
    }
    
    internal func errorHandler(error: Error) {
        Timber.e("\(error)")
        errorMessageObservable.accept(error.localizedDescription)
    }
    
}
