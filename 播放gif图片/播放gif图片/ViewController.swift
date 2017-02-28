//
//  ViewController.swift
//  播放gif图片
//
//  Created by zhangzhifu on 2017/2/28.
//  Copyright © 2017年 seemygo. All rights reserved.
//

import UIKit
import Kingfisher
import ImageIO

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. 获取图片路径
        guard let filePath = Bundle.main.path(forResource: "demo.gif", ofType: nil) else { return }
        
        // 2. 将图片转成Data类型
        guard let data = NSData(contentsOfFile: filePath) else { return }
        
        // 3. 从Data中获取CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return }
        
        // 4. 获取gif图片中分解出来图片的个数
        let count = CGImageSourceGetCount(imageSource)
        
        // 5. 遍历所有的图片,获取图片的数组,以及gif图片播放时长
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0..<count {
            // 5.1 获取图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            
            // 5.2 获取时长
            guard let propertyDict = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary else {
                continue
            }
            guard let gifDict = propertyDict[kCGImagePropertyGIFDictionary] as? NSDictionary else {
                continue
            }
            guard let duration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += duration.doubleValue
        }
        
        // 6. 给image设置动画的属性
        imageView.animationImages = images
        imageView.animationDuration = totalDuration
        imageView.animationRepeatCount = 2
        
        // 7 开始动画
        imageView.startAnimating()
    }
}

 
