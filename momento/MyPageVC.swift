//
//  MyPageVC.swift
//  momento
//
//  Created by Ali Noorani on 2018-05-07.
//  Copyright © 2018 Ali Noorani. All rights reserved.
//

import UIKit

class MyPageVC: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "IDECamController"),
            self.getViewController(withIdentifier: "IDECamController1")
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate   = self
        print("Ready!!!")
       
            setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        
      
       
        // Do any additional setup after loading the view.
    }
    required init?(coder: NSCoder) {
        super.init(transitionStyle:.scroll,navigationOrientation: .horizontal, options:nil)
    }
    func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return pages.last }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil         }
        
        return pages[nextIndex]
    }
    

  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
