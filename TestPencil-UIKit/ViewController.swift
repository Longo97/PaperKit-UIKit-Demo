//
//  ViewController.swift
//  TestPencil-UIKit
//
//  Created by Marco Longobardi on 17/09/25.
//

import UIKit
import PaperKit
import PencilKit

class ViewController: UIViewController {
    
    var paperVC: PaperMarkupViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        var featureSet = FeatureSet.latest
        featureSet.colorMaximumLinearExposure = 4
        
        let markupModel = PaperMarkup(bounds: view.bounds)
        paperVC = PaperMarkupViewController(markup: markupModel, supportedFeatureSet: featureSet)
        
        
        guard let paperVC = paperVC else { return }
        view.addSubview(paperVC.view)
        addChild(paperVC)
        paperVC.didMove(toParent: self)
        
        print("Done configuration")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let paperVC = paperVC else { return }

        let toolpicker = PKToolPicker()
        toolpicker.colorMaximumLinearExposure = 4
        toolpicker.setVisible(true, forFirstResponder: paperVC)
        toolpicker.addObserver(paperVC)
        paperVC.pencilKitResponderState.activeToolPicker = toolpicker
        paperVC.pencilKitResponderState.toolPickerVisibility = .visible
        paperVC.becomeFirstResponder()
        
        toolpicker.accessoryItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonPressed(_:)))
    }
    
    @objc func plusButtonPressed(_ button: UIBarButtonItem) {
        guard let paperVC = paperVC else { return }
        var featureSet = FeatureSet.latest
        featureSet.colorMaximumLinearExposure = 4
        
        let markupEditViewController = MarkupEditViewController(supportedFeatureSet: featureSet)
        
        markupEditViewController.delegate = paperVC as? any MarkupEditViewController.Delegate
        markupEditViewController.modalPresentationStyle = .popover
        markupEditViewController.popoverPresentationController?.barButtonItem = button
        
        present(markupEditViewController, animated: true)
        
    }
}

