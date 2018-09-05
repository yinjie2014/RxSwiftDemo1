//
//  ViewController.swift
//  RxSwiftDemo1
//
//  Created by Yin on 2018/9/4.
//  Copyright © 2018 Yin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var label: UILabel!
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label = UILabel(frame: CGRect(x: 100, y: 50, width: 200, height: 30))
        self.view.addSubview(self.label)
        
        // Observable序列 （每隔1秒发出一个索引数）
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
        // bind 用法
        /*
        observable
            .map{"当前索引数:\($0)"}
            .bind{[weak self](text) in
                self?.label.text = text
            }
            .disposed(by: disposeBag)
         */
        


        // 使用AnyObserver创建观察者
        // 创建观察者
        /*
        let observer: AnyObserver<String> = AnyObserver { [weak self] (event) in
            switch event {
                case .next(let text):
                    self?.label.text = text
                default:
                    break
            }
            
        }
        
        // 使用BindTo
        observable
            .map{"当前索引数:\($0)"}
            .bind(to: observer)
            .disposed(by: disposeBag)
        */
        
        // 使用binder创建观察者
        // 相较于AnyObserver更注重于特定的场景
        // 1. binder不会处理错误事件
        // 2. 确保绑定都是在主线程中
        
//        let observer: Binder<String> = Binder(label) { (view, text) in
//            view.text = text
//        }
        
        observable
            .map{"当前索引数:\($0)"}
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
 
        
        let obser : Observable<Int> = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
        obser
            .map{CGFloat($0)}
            .bind(to: label.rx.fontSize)
            .disposed(by: disposeBag)
        
        
    }


}


extension Reactive where Base : UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self.base) { label, fontSize in
            label.font = .systemFont(ofSize: fontSize)
        }
    }
    
    public var text: Binder<String?> {
        return Binder(self.base) { label, text in
            label.text = text
        }
    }
}

extension Reactive where Base : UILabel {
    public var attributedText : Binder<NSAttributedString?> {
        return Binder(self.base) { label, attributedText in
            label.attributedText = attributedText
        }
    }
}
