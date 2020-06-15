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
    
    @IBOutlet weak var featuredSongCollection: UICollectionView!
    
    @IBOutlet weak var popularSongCollection: UICollectionView!
    
    var imgArr = [ UIImage(named: "Highlight 1"), UIImage(named: "Highlight 2"), UIImage(named: "Highlight 3") ]
    
    let featuredSongs = [Song(name: "Castle", image: UIImage(named: "Emo 0"), artist: "NCS"),
                Song(name: "Number 1", image: UIImage(named: "Emo 1"), artist: "Loona"),
                Song(name: "Butterfly", image: UIImage(named: "Emo 2"), artist: "Loona"),
                Song(name: "Stylist", image: UIImage(named: "Emo 3"), artist: "Loona"),
                Song(name: "Colors", image: UIImage(named: "Emo 4"), artist: "Loona"),
                Song(name: "Deja Vu", image: UIImage(named: "Emo 5"), artist: "Loona"),
                Song(name: "1 Second", image: UIImage(named: "Emo 6"), artist: "Loona"),
                Song(name: "Heart Attack", image: UIImage(named: "Emo 7"), artist: "Loona"),
                Song(name: "One & Only", image: UIImage(named: "Emo 8"), artist: "Loona"),
                Song(name: "New", image: UIImage(named: "Emo 9"), artist: "Loona"),
                Song(name: "Eclipse", image: UIImage(named: "Emo 10"), artist: "Loona"),
                Song(name: "Favorite", image: UIImage(named: "Emo 11"), artist: "Loona")]
    
    let popularSongs = [Song(name: "Say So", image: UIImage(named: "Rectangle 0"), artist: "Doja Cat"),
                        Song(name: "Baby", image: UIImage(named: "Rectangle 1"), artist: "Justin Bieber"),
                        Song(name: "Dont't Start Now", image: UIImage(named: "Rectangle 2"), artist: "Dua Lipa"),
                        Song(name: "Kiss & Make Up", image: UIImage(named: "Rectangle 3"), artist: "Dua Lip ft. Blackpink"),
                        Song(name: "Ddu-du-ddu-du", image: UIImage(named: "Rectangle 4"), artist: "Blackpink"),
                        Song(name: "Finesse", image: UIImage(named: "Rectangle 5"), artist: "Bruno Mars ft. Cardi B"),
                         Song(name: "Gucci Mane", image: UIImage(named: "Rectangle 6"), artist: "Gucci Mane" )]
    
    var tempSong : Song?
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimer()
    }
    
    private func setupTimer() {
        pageView.numberOfPages = imgArr.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is SongDetailVC
        {
            let vc = segue.destination as? SongDetailVC
            vc?.theSong = tempSong
        }
    }
    
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            return imgArr.count
        } else  if collectionView.tag == 2 {
            return featuredSongs.count
        } else {
            return popularSongs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2 {
            tempSong = featuredSongs[indexPath.row]
        } else if collectionView.tag == 3 {
            tempSong = popularSongs[indexPath.row]
        }
        performSegue(withIdentifier: "goToSongDetail", sender: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        
        if collectionView.tag == 1{
            cell.image.image = imgArr[indexPath.row]
        } else if collectionView.tag == 2{
            cell.image2.image = featuredSongs[indexPath.row].image
            cell.song2.text = featuredSongs[indexPath.row].name
            cell.artist2.text = featuredSongs[indexPath.row].artist
        } else {
            cell.image3.image = popularSongs[indexPath.row].image
            cell.song3.text = popularSongs[indexPath.row].name
            cell.artist3.text = popularSongs[indexPath.row].artist
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
