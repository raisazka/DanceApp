//
//  HomeVC.swift
//  DanceApp
//
//  Created by Rais on 09/06/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    @IBOutlet weak var musicCover: UICollectionView!
    
    @IBOutlet weak var musicCover2: UICollectionView!
    
    var imgArr = [ UIImage(named: "Highlight 1"), UIImage(named: "Highlight 2"), UIImage(named: "Highlight 3") ]
    
    var mscCov1 = [ UIImage(named: "Emo 0"), UIImage(named: "Emo 1"), UIImage(named: "Emo 2"), UIImage(named: "Emo 3"), UIImage(named: "Emo 4"), UIImage(named: "Emo 5"), UIImage(named: "Emo 6"), UIImage(named: "Emo 7"), UIImage(named: "Emo 8"), UIImage(named: "Emo 9"), UIImage(named: "Emo 10"), UIImage(named: "Emo 11") ]
    var mscSong1 = [ "Happy", "Number 1", "Butterfly", "Stylist", "Colors", "Deja Vu", "1 Second", "Heart Attack", "One & Only", "New", "Eclipse", "Favorite", "" ]
    var mscArtist1 = [ "Loona", "Loona", "Loona", "Loona", "Loona", "Loona", "Loona", "Loona", "Loona", "Loona", "Loona", "Loona" ]
    
    var mscCov2 = [ UIImage(named: "Rectangle 0"), UIImage(named: "Rectangle 1"), UIImage(named: "Rectangle 2"), UIImage(named: "Rectangle 3"), UIImage(named: "Rectangle 4"), UIImage(named: "Rectangle 5"), UIImage(named: "Rectangle 6") ]
    var mscSong2 = [ "Say So", "Yummy", "Don't Start Now", "Kiss & Make Up", "Ddu-du-ddu-du", "Finesse", "Wake Up In The Sky" ]
    var mscArtist2 = [ "Doja Cat", "Justin Bieber", "Dua Lipa", "Dua Lipa ft Blackpink", "Blackpink", "Bruno Mars ft Cardi B", "Gucci Mane" ]
    
    var tempImage: UIImage?
    var tempSong: String = ""
    var tempArtist: String = ""
    
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageView.numberOfPages = imgArr.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func changeImage() {
        
        if counter < imgArr.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
        
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            return imgArr.count
        } else  if collectionView.tag == 2 {
            return mscCov1.count
        } else {
            return mscCov2.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2 {
            tempImage = UIImage(imageLiteralResourceName: "Emo \(indexPath.row)")
            tempSong = mscSong1[indexPath.row]
            tempArtist = mscArtist1[indexPath.row]
        } else  if collectionView.tag == 3 {
            tempImage = UIImage(imageLiteralResourceName: "Rectangle \(indexPath.row)")
            tempSong = mscSong2[indexPath.row]
            tempArtist = mscArtist2[indexPath.row]
        }
        performSegue(withIdentifier: "goToSongDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is SongDetailVC
        {
            let vc = segue.destination as? SongDetailVC
            vc?.mscArtist = tempArtist
            vc?.mscSong = tempSong
            vc?.mscCov = tempImage
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        
        if collectionView.tag == 1{
            cell.image.image = imgArr[indexPath.row]
        } else if collectionView.tag == 2{
            cell.image2.image = mscCov1[indexPath.row]
            cell.song2.text = mscSong1[indexPath.row]
            cell.artist2.text = mscArtist1[indexPath.row]
        } else {
            cell.image3.image = mscCov2[indexPath.row]
            cell.song3.text = mscSong2[indexPath.row]
            cell.artist3.text = mscArtist2[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1{
            let size = sliderCollectionView.frame.size
            return CGSize(width: size.width, height: size.height)
        } else if collectionView.tag == 2 {
            return CGSize(width: 128, height: 137)
        }  else {
            return CGSize(width: 128, height: 137)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
