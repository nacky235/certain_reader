//
//  ModalContainerNavigationController.swift
//  NarouReader
//
//  Created by 稲葉夏輝 on 2020/12/19.
//
import UIKit
import PanModal

class ModalContainerNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ModalContainerNavigationViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(300)
    }

    var shouldRoundTopCorners: Bool {
        true
    }

    var showDragIndicator: Bool {
        true
    }
}
