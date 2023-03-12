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
    
    var rating = 0{
        didSet{
            updateSelectedRating()
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
    }
    
    @objc func action(sender: UIButton){
        guard let index = buttons.firstIndex(of: sender) else {return}
        let selectedRating = index + 1
        
        if selectedRating == rating{
            rating = 0
        }else{
            rating = selectedRating
        }
    }
    
    //способ проверки на выставление оценки
    private func updateSelectedRating(){
        for (index, button) in buttons.enumerated(){
            button.isSelected = index < rating
        }
    }
    
    
    private func setUpButtons(){
        
        
        for button in buttons{
             removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        buttons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar",
                                 in: bundle,
                                 compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle,
                                compatibleWith: self.traitCollection)
        
        let highlatedStar = UIImage(named: "highlitedStar",
                                    in: bundle,
                                    compatibleWith: self.traitCollection)
        
        
        for _ in 1...starCount{
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlatedStar, for: .highlighted)
            button.setImage(highlatedStar, for: [.highlighted, .selected])
           
            //отключает автоматически сгенерированные констр для кнопки
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
            addArrangedSubview(button)
            buttons.append(button)
        }
        updateSelectedRating()
    }
}
