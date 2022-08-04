//
//  UISupportFile.swift
//  SellAcha
//
//  Created by VinodKatta on 27/04/22.
//

import UIKit

class UISupportFile: NSObject {
    
    
}

class ImageStore: NSObject {
    static let imageCache = NSCache<NSString, UIImage>()
}
extension UIView {
    
    func roundCorners(view :UIView, corners: UIRectCorner, radius: CGFloat){
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
    }

}

extension UITextField {

    func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIImageView {

    func MakeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0,y: 50,width: size.width, height: lineWidth))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
extension UIImageView {
    func loadImageUsingURL(_ url: String?) {
        DispatchQueue.global().async { [weak self] in
            guard let stringURL = url, let url = URL(string: stringURL) else {
                return
            }
            func setImage(image: UIImage?) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
            let urlToString = url.absoluteString as NSString
            if let cachedImage = ImageStore.imageCache.object(forKey: urlToString) {
                setImage(image: cachedImage)
            } else if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    ImageStore.imageCache.setObject(image, forKey: urlToString)
                    setImage(image: image)
                }
            } else {
                setImage(image: nil)
            }
        }
    }
}

protocol Loadable {
    func showLoadingView()
    func hideLoadingView()
}

extension  UIViewController: Loadable {
    

    func showLoadingView() {
          let loadingView = LoadingView()
                view.addSubview(loadingView)
                view.isUserInteractionEnabled = false
                loadingView.translatesAutoresizingMaskIntoConstraints = false
                loadingView.widthAnchor.constraint(equalToConstant: 100).isActive = true
                loadingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
                loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                
                loadingView.animate()
                
                loadingView.tag = LoaderConstants.loadingViewTag
    }
    
    func hideLoadingView() {
          view.isUserInteractionEnabled = true
                view.alpha = 1
                view.subviews.forEach { subview in
                    if subview.tag == LoaderConstants.loadingViewTag {
                        subview.removeFromSuperview()
                    }
                }
    }
}

final class LoadingView: UIView {
    private let activityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)

        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            backgroundColor = UIColor.darkGray.withAlphaComponent(1)
            layer.cornerRadius = 5
            activityIndicatorView.color = .white
            
            if activityIndicatorView.superview == nil {
                addSubview(activityIndicatorView)
                activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
                activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                activityIndicatorView.startAnimating()
            }
        }
        
        public func animate() {
            activityIndicatorView.startAnimating()
        }
    
    }
fileprivate struct LoaderConstants {
    /// an arbitrary tag id for the loading view, so it can be retrieved later without keeping a reference to it
    fileprivate static let loadingViewTag = 1234
}


