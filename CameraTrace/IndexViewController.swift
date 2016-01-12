//
//  IndexViewController.swift
//  CameraTrace
//
//  Created by 吴迪玮 on 16/1/12.
//  Copyright © 2016年 DNT. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Trace.currentTrace = Trace()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

