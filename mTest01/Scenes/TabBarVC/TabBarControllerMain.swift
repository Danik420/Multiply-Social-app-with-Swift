//
//  TabBarControllerMain.swift
//  mTest01
//
//  Created by Danik420 on 2022/04/22.
//

import UIKit

class TabBarControllerMain: UITabBarController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.5).cgColor
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.backgroundColor = .white
        
         
        //커스텀 탭바
        /*
        let firstVC = UIViewController()
                firstVC.tabBarItem.selectedImage = UIImage(systemName: "message")
                firstVC.tabBarItem.title = "Recent"
                firstVC.tabBarItem.image = UIImage(systemName: "message.fill")
                
                let secondVC = UIViewController()
                dummyView.view.backgroundColor = .yellow
                dummyView.tabBarItem.title = "Yellow Dummy"
                dummyView.tabBarItem.image = UIImage(systemName: "trash.fill")
                
                viewControllers = [firstVC, dummyView]
        */
                
        
        //스와이프 코드
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
 
        // Do any additional setup after loading the view.
    }
 
    //스와이프 코드
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        
        if gesture.direction == .left {
            if (self.selectedIndex) < 4 { // 슬라이드할 탭바 갯수 지정 (전체 탭바 갯수 - 1)
                animateToTab(toIndex: self.selectedIndex+1)
            }
        } else if gesture.direction == .right {
            if (self.selectedIndex) > 0 {
                animateToTab(toIndex: self.selectedIndex-1)
            }
        }
    }
}
 
extension TabBarControllerMain: UITabBarControllerDelegate  {
    
    //스와이프 코드
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let tabViewControllers = tabBarController.viewControllers, let toIndex = tabViewControllers.firstIndex(of: viewController) else {
            return false
        }
        animateToTab(toIndex: toIndex)
        return true
    }
    
    func animateToTab(toIndex: Int) {
        guard let tabViewControllers = viewControllers,
            let selectedVC = selectedViewController else { return }
        
        guard let fromView = selectedVC.view,
            let toView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.firstIndex(of: selectedVC),
            fromIndex != toIndex else { return }
        
        
        // Add the toView to the tab bar view
        fromView.superview?.addSubview(toView)
        
        // Position toView off screen (to the left/right of fromView)
        let screenWidth = UIScreen.main.bounds.size.width
        let scrollRight = toIndex > fromIndex
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)
        
        // Disable interaction during animation
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        // Slide the views by -offset
                        fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y)
                        toView.center = CGPoint(x: toView.center.x - offset, y: toView.center.y)
                        
        }, completion: { finished in
            // Remove the old view from the tabbar view.
            fromView.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }
}

