//
//  PreOnboardingSingleViewController.swift
//  PerfectDude
//
//  Created by Yannis De Cleene on 12/12/2018.
//  Copyright © 2018 yannisdecleene. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PerfectUI

final class PreOnboardingSingleViewController: ViewController {
    internal var viewModel: PreOnboardingSingleViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var firstStepView: PreOnboardingStepView!
    @IBOutlet private weak var continueButton: UIButton!
}

extension PreOnboardingSingleViewController: Bindable {

    func bindViewModel() {
        blurView.layer.cornerRadius = 16
        blurView.layer.masksToBounds = true
        
        backgroundImageView.image = UIImage(named: "Background")?.blurred(withRadius: 5)
        
        let input = PreOnboardingSingleViewModel.Input(buttonTap: continueButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        output.tapResult.drive().disposed(by: disposeBag)
        output.title.drive(rx.title).disposed(by: disposeBag)
    }
}

extension UIImage {
    
    func blurred(withRadius radius: Int) -> UIImage {
        let context = CIContext(options: nil)
        let inputImage = CIImage(cgImage: self.cgImage!)
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(radius, forKey: "inputRadius")
        let result = filter.value(forKey: kCIOutputImageKey) as! CIImage
        let cgImage = context.createCGImage(result, from: inputImage.extent)!
        return UIImage(cgImage: cgImage)
    }
    
}
