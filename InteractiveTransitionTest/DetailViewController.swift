//
//  DetailViewController.swift
//  InteractiveTransitionTest
//
//  Created by Jayson Rhynas on 2018-09-28.
//  Copyright © 2018 Jayson Rhynas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    let titleLabel = UILabel()
    let detailText = UITextView()
    
    convenience init(item: Item) {
        self.init(nibName: nil, bundle: nil)
        configure(for: item)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        detailText.backgroundColor = .clear
        
        view.addSubview(titleLabel)
        view.addSubview(detailText)
        
        [titleLabel, detailText].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            detailText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            detailText.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            detailText.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            detailText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func configure(for item: Item) {
        self.titleLabel.text = item.title
        self.detailText.text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Primum cur ista res digna odio est, nisi quod est turpis? Tu enim ista lenius, hic Stoicorum more nos vexat. Dicet pro me ipsa virtus nec dubitabit isti vestro beato M.
        
        Duo Reges: constructio interrete. Tum Piso: Quoniam igitur aliquid omnes, quid Lucius noster? Sed et illum, quem nominavi, et ceteros sophistas, ut e Platone intellegi potest, lusos videmus a Socrate. Cupiditates non Epicuri divisione finiebat, sed sua satietate. Eorum enim omnium multa praetermittentium, dum eligant aliquid, quod sequantur, quasi curta sententia; Quamquam tu hanc copiosiorem etiam soles dicere. Itaque haec cum illis est dissensio, cum Peripateticis nulla sane.
        """
    }
}
