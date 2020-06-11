//
//  ViewController.swift
//  DanceApp
//
//  Created by Rais on 05/06/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class OnboardVC: UIViewController, UIScrollViewDelegate {
    

   
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var PageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0
    var pageCount:Int = 0
    
    private var lastContentOffset : CGFloat = 0
    
    var boardingImages = ["onboarding1","onboarding2","onboarding3"]
       
    override func viewDidLayoutSubviews() {
        scrollWidth = ScrollView.frame.size.width
        scrollHeight = ScrollView.frame.size.height
       }

    override func viewDidLoad() {
        super.viewDidLoad()
            self.view.layoutIfNeeded()
            UserDefaults.standard.bool(forKey: "FirstLaunch")
                    
            self.ScrollView.delegate = self
            ScrollView.isPagingEnabled = true
            ScrollView.showsHorizontalScrollIndicator = false
            ScrollView.showsVerticalScrollIndicator = false
                    
            //create the slides and add them
            var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                    
            for index in 0..<boardingImages.count {
                frame.origin.x = scrollWidth * CGFloat(index)
                frame.size = CGSize(width: scrollWidth, height: scrollHeight)
                        
                let slide = UIView(frame: frame)
                        
                //subviews
                let imageView = UIImageView.init(image: UIImage.init(named: boardingImages[index]))
                imageView.frame = ScrollView.frame
                imageView.contentMode = .scaleAspectFit
                imageView.center = CGPoint(x:scrollWidth/2,y:scrollHeight/2)
                        
                slide.addSubview(imageView)
                ScrollView.addSubview(slide)
            }
                    
            //set width of scrollview to accomodate all the slides
            ScrollView.contentSize = CGSize(width: scrollWidth * CGFloat(boardingImages.count), height: scrollHeight)
                    
            //disable vertical scroll/bounce
            self.ScrollView.contentSize.height = 1.0
                    
            //initial state
            PageControl.numberOfPages = boardingImages.count
            PageControl.currentPage = 0
                    
        }
                
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "First Launch") == true {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "skipSegue", sender: self)
                print("Segue performed - user defaults returned true!")
            }
        }
        if pageCount == 0 {
                backButton.setTitle("", for: .normal)
        }
    }
            
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
               
    }
            
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
                    pageCount -= 1
        if pageCount <= 0 {
            backButton.setTitle(" ", for: .normal)
            }
        } else {
            pageCount += 1
            backButton.setTitle("Back", for: .normal)
        }
    }
                
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
                    setIndicatorForCurrentPage()
                    
    }
                
    func setIndicatorForCurrentPage() {
        let page = (ScrollView?.contentOffset.x)!/scrollWidth
        PageControl?.currentPage = Int(page)
                    
    }
                
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.ScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.ScrollView.scrollRectToVisible(frame, animated: animated)
    }
            
            //scroll onboarding with buttons
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        backButton.setTitle("Back", for: .normal)
        if pageCount < 2 {
            pageCount += 1
            self.scrollToPage(page: pageCount, animated: true)
            PageControl.currentPage = pageCount

            if pageCount == 2 {
                nextButton.setTitle("Get Started", for: .normal)
            }
            else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
        else {
            performSegue(withIdentifier: "toHomePageSegue", sender: self)
            return
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if pageCount > 0 {
                   pageCount -= 1
                   self.scrollToPage(page: pageCount, animated: true)
                   PageControl.currentPage = pageCount
                   nextButton.setTitle("Next", for: .normal)
               }
               else {
                   PageControl.currentPage = pageCount
                   return
                       }
        
        
        if pageCount == 0 {
                   backButton.setTitle("", for: .normal)
        }
    }
}
