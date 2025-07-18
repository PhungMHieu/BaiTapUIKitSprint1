//
//  IndexV.swift
//  BaiTapDuLich
//
//  Created by Admin on 5/7/25.
//

import UIKit

class IndexV: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var index: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var unit: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    required init?(coder: NSCoder){
        super.init(coder: coder)
        loadFromNib()
    }
    override func layoutSubviews() {
        
    }
    private func loadFromNib(){
        let nib = UINib(nibName: "IndexV", bundle: nil)
        let nibView = nib.instantiate(withOwner: self).first as! UIView
        addSubview(nibView)
        nibView.translatesAutoresizingMaskIntoConstraints = false
        nibView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nibView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nibView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nibView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    func config(customIndex: CustomIndex){
        title.text = customIndex.title
        index.text = "\(customIndex.index)"
        if customIndex.unit == ""{
            unit.isHidden = true
        }else{
            unit.isHidden = false
            unit.text = customIndex.unit
        }
        unit.setLineHeight(24)
    }
    func config(color: UIColor){
        self.index.textColor = color
        self.unit.textColor = color
    }
    func setIndex(index: String){
        self.index.text = index
    }
}
