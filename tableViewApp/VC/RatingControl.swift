//
//  RatingControl.swift
//  tableViewApp
//
//  Created by Рустам Т on 3/11/23.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    private var buttons: [UIButton] = []
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{
            setUpButtons()
        }
    }
    @IBInspectable var starCount: Int = 5{
        didSet{
            setUpButtons()
        }
    }
    
    
    
    var rating = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
    }
    
    @objc func action(sender: UIButton){
        print("button pressed")
    }
    
    private func setUpButtons(){
        for button in buttons{
             removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        buttons.removeAll()
        
        for _ in 1...starCount{
            let button = UIButton()
            button.backgroundColor = .red
            //отключает автоматически сгенерированные констр для кнопки
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
            addArrangedSubview(button)
            buttons.append(button)
        }
        
    }
}
