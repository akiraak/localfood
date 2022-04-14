//
//  MarketCardView.swift
//  localfood
//
//  Created by Akira Kozakai on 4/13/22.
//

import UIKit

@IBDesignable
final class MarketCardView: UIView {
    var market: Market? = nil
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openingHoursText: UITextView!
    @IBOutlet weak var addressText: UITextView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setup(_ market: Market) {
        self.market = market
        nameLabel.text = market.name
        openingHoursText.text = market.openingHours
        addressText.text = market.address
    }
}
