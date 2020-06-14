//
//  SongDetailVC.swift
//  DanceApp
//
//  Created by Rais on 09/06/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class SongDetailVC: UIViewController {

    @IBOutlet weak var sdImage: UIImageView!
    @IBOutlet weak var sdTitle: UILabel!
    @IBOutlet weak var sdArtist: UILabel!
    @IBOutlet weak var sdSC: UISegmentedControl!
    
    var theSong: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        sdSC.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        sdSC.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        sdSC.backgroundColor = UIColor(red:28/255.0, green:28/255.0, blue:31/255.0, alpha: 1.0)
        sdSC.tintColor = UIColor(red:33/255.0, green:199/255.0, blue:223/255.0, alpha: 1.0)
    }
    
    private func setupData() {
        sdImage.image = theSong?.image
        sdTitle.text = theSong?.name
        sdArtist.text = theSong?.artist
    }

}
