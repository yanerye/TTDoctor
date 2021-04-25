//
//  testSwiftDemo.swift
//  TTDoctor
//
//  Created by YK on 2021/4/7.
//  Copyright © 2021 YK. All rights reserved.
//

import UIKit

//@objc(testSwiftDemo)
//
//public class testSwiftDemo : NSObject {
//   @objc public func logMe() {
//        print("测试登录");
//    }
//}
//


class testSwiftDemo : UIViewController {
    override func viewDidLoad() {
        super .viewDidLoad()
        self.view.backgroundColor = UIColor.cyan;
        self.navigationController?.navigationBar.barTintColor = UIColor.green;
        self.navigationItem.title = "测试一下";
        let testStr = "哈哈哈";
        print(testStr);
    }
    
    
}

