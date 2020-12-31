//
//  LoadingDots.swift
//  Curs2
//
//  Created by Артём Сарана on 26.12.2020.
//

import UIKit

class LoadingDots: UIView {
    
    var dotList = [Circle]()
    var timerDuration = 0.2
    var myTimer: Timer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLoader()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLoader()
    }

    override func draw(_ rect: CGRect) {
        self.startAnimation()
    }
    
    func setupLoader() {
        self.backgroundColor = .clear
        
        for _ in 0..<3 {
            self.dotList.append(Circle())
        }
        
        let stackView = UIStackView(arrangedSubviews: self.dotList)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        
        let topConstraint = stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)
        let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        let leadingConstraint = stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5)
        let trailingConstraint = stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        self.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    func startAnimation() {
        guard self.myTimer == nil else { return }

        self.myTimer = Timer.scheduledTimer(
            timeInterval: self.timerDuration * Double(self.dotList.count + 2),
            target      : self,
            selector    : #selector(animation),
            userInfo    : nil,
            repeats     : true)
    }
    
    
    @objc private func animation(){
        for i in 0..<self.dotList.count {
            UIView.animate(withDuration: self.timerDuration, delay: Double(i) * self.timerDuration, options: [.curveLinear], animations: {
                self.dotList[i].transform = self.transform.scaledBy(x: 1.2, y: 1.2)
                self.dotList[i].alpha = 1
            }, completion: { _ in
                UIView.animate(withDuration: self.timerDuration, animations: {
                    self.dotList[i].transform = CGAffineTransform.identity
                    self.dotList[i].alpha = 0.0
                })
            })
        }

    }
    
    func stopAnimation() {
        guard let timer = self.myTimer else { return }
        timer.invalidate()
        self.myTimer = nil
    }

}

class Circle: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(UIColor.black.cgColor)
        let circleSize = min(self.frame.width / 2, self.frame.height / 2)
        context.fillEllipse(in: CGRect(x: self.frame.width/2 - circleSize/2, y: self.frame.height/2 - circleSize/2, width: circleSize, height: circleSize))
    }
}
