//
//  LockView.swift
//  GestureLock
//
//  Created by 刘佳  on 2022/6/13.
//

import UIKit

protocol LockViewDelegate: AnyObject {
   func didPanEnded(password: String)
}

class LockView: UIView {
    
    let topMargin: CGFloat = 150
    var seletedArr = [UIButton]()
    var currentP: CGPoint?
    weak var delegate:LockViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        let tapGes = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_ :)))
        addGestureRecognizer(tapGes)
        setButtons()
    }
    
    @objc private func panGesture(_ ges: UIPanGestureRecognizer) {
        currentP = ges.location(in: self)
        
        self.subviews.forEach { btn in
            guard let btn1 = btn as? UIButton else { return }
            guard let position = currentP else { return }
            if btn1.frame.contains(position) && !btn1.isSelected {
                btn1.isSelected = true
                self.seletedArr.append(btn1)
            }
        }
        //告诉视图需要重新绘制
        setNeedsDisplay()
        
        if ges.state == .ended {
            var strArr = [String]()
            if seletedArr.count <= 4 {
                let alert = UIAlertController(title: "提示", message: "手势必须大于四个连接点", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel,handler: { _ in
                    self.seletedArr.forEach { btn in
                        btn.isSelected = false
                    }
                    self.seletedArr.removeAll()
                }))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
               
            }
            self.seletedArr.forEach { btn in
                btn.isSelected = false
                strArr.append("\(btn.tag)")
            }
            self.delegate?.didPanEnded(password: strArr.joined())
            self.seletedArr.removeAll()
        }
    }
    
    private func setButtons() {
        
        for i in 0..<10 {
            print("i -- \(i)")
            let btn = UIButton(type: .custom)
            btn.isUserInteractionEnabled =  false
            btn.setImage(UIImage(systemName: "circle.circle"), for: .normal)
            btn.setImage(UIImage(systemName: "circle.circle.fill"), for: .selected)
            btn.tag = i + 1
            addSubview(btn)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置行数
        let cols: CGFloat = 3
        let count = self.subviews.count
        var x: CGFloat = 0
        var y: CGFloat = 0
        let w: CGFloat = 74
        let h: CGFloat = 74
        let margin = (bounds.size.width - CGFloat(cols * w)) / CGFloat(cols + 1)
        var col: CGFloat = 0
        var row: CGFloat = 0
        
        for i in 0..<count-1 {
            let btn: UIButton = self.subviews[i] as! UIButton
            col = CGFloat(i % Int(cols))
            row = CGFloat(i / Int(cols))
            x = margin + col * (margin + w)
            y = row * (margin + w)
            
            btn.frame = CGRect(x: x, y: y + topMargin , width: w, height: h)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        if self.seletedArr.count == 0 {return}
        let bezierPath = UIBezierPath()
        for i in 0..<seletedArr.count {
            let btn = self.seletedArr[i]
            if i == 0 {
                bezierPath.move(to: btn.center)
            } else {
                bezierPath.addLine(to: btn.center)
            }
        }
        
//        guard let currentP = currentP else { return }
//        bezierPath.addLine(to: currentP)
        UIColor.systemPink.set()
        bezierPath.lineWidth = 4
        bezierPath.lineJoinStyle = .round
        bezierPath.lineCapStyle = .round
        bezierPath.stroke()
            
    }

}
