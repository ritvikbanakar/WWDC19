
//  WWDC
//
//  Created by Ritvik Banakar on 3/19/19.
//  Copyright © 2019 Ritvik Banakar. All rights reserved.
//

//: # Welcome to Ritvik's ARKit Demonstration
//: My WWDC 2019 Scholarship Submission, Made on Xcode 10.1 - Runs on Swift Playgrounds
//: Click the About Me button!

//:### General information
//: This is the MyViewController class that then uses two other classes that are in different files to run
//: either the physics demo or the literature demo. As stated in my paragraph both of these
//: have a very heavy educational aspect to them as they are my take on how iPads can change the
//: future of education even more than they already have. NOTE: The bouncing ball was to have a numerical value next to it but due to time constraints this was not possible
//:## Run Info
//: When running the literary section, please make sure to have quite a bit of space as the portal and basket take quite a bit of space. When you first run the program the portal will take a quick second to appear just as it will with the ball. With the ball demonstration, a UILabel called potentialEnergy was supposed to be displayed right next to the ball but due to time I could not get this feature working. Tap the ball to watch it go up and eventually bonce back down.
//:## Some Issues
//: Due to time constrainsts I was not able to create a back button from either the physics or literature
//: page and so in order to get from one to the other, you will have to stop the program and run it
//: once again. In addition, I was not able to add a delay when loading assests so both situations will take a second to load. Last but not least, in the literature section, the basket does not disappear alongside the maskedRoom and I am not sure why. Hopefully I can fix all of these bugs at WWDC 2019!


import UIKit
import PlaygroundSupport
import ARKit


var physics = false
var lit = false
class MyViewController: UIViewController {
    
    let cardView        = UIView() // This is the white card that flashes up
    let profileView  = UIImageView()
    let titleLabel      = UILabel()
    // This is just the WWDC button but it does not do anything when clicked due to time restraints.
    let wwdcButton     = UIButton()
    let aboutButton   = UIButton()
    let physicsButton = UIButton()
    let litButton = UIButton()
    
// These are so that the respective ARKit Demos
// can run.
    
    let physicsControl = PhysicsController()
    let litControl = LitController()

    
    
    var cardViewBottomConstraint: NSLayoutConstraint!
    
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .black
        self.view = view
        setupCardView()
    }
    
    
    func setupCardView() {
        view.addSubview(cardView)
        cardView.backgroundColor    = .white
        cardView.layer.cornerRadius = 12
        setupCardViewConstraints()
        
        setupAboutButton()
        setupProfileView()
        setupTitleLabel()
        setupWWDCButton()
      setupPhysicsButton()
        setupLitButton()
        
    }
    
    
    
    func setupProfileView() {
        cardView.addSubview(profileView)
        profileView.layer.cornerRadius  = 12
        profileView.layer.masksToBounds = true
        profileView.image               = UIImage(named: "profile.jpg")
        
        setProfileViewConstraints()
    }
    
    
    func setupTitleLabel() {
        cardView.addSubview(titleLabel)
        titleLabel.text             = "Ritvik Banakar - Developer, Designer"
        titleLabel.font             = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor        = .darkGray
        titleLabel.textAlignment    = .center
        
        setTitleLabelConstraints()
    }
    
    
    func setupWWDCButton() {
        cardView.addSubview(wwdcButton)
        wwdcButton.setTitle("WWDC19", for: .normal)
        wwdcButton.setTitleColor(.white, for: .normal)
        wwdcButton.backgroundColor    = .red
        wwdcButton.layer.cornerRadius = 12
        
        setWWDCButtonConstraints()
    }
    
    
    func setupAboutButton() {
        view.addSubview(aboutButton)
        aboutButton.setTitle("About Me", for: .normal)
        aboutButton.setTitleColor(.white, for: .normal)
        aboutButton.backgroundColor    = .blue
        aboutButton.layer.cornerRadius = 12
        aboutButton.addTarget(self, action: #selector(aboutCard), for: .touchUpInside)
        
        setAboutButtonConstraints()
    }
    
   func setupPhysicsButton() {
        view.addSubview(physicsButton)
        physicsButton.setTitle("Experience Physics in a new way!", for: .normal)
        physicsButton.setTitleColor(.white, for: .normal)
        physicsButton.backgroundColor    = UIColor(red: 0, green: 0.2588, blue: 0.4588, alpha: 1.0)
        physicsButton.layer.cornerRadius = 12
        physicsButton.addTarget(self, action: #selector(runPhysics), for: .touchUpInside)
        
      setPhysicsButtonConstraints()
    }
    
    func setupLitButton() {
        view.addSubview(litButton)
        litButton.setTitle("Live in a Book!", for: .normal)
        litButton.setTitleColor(.white, for: .normal)
        litButton.backgroundColor    = .purple
        litButton.layer.cornerRadius = 12
       litButton.addTarget(self, action: #selector(runLit), for: .touchUpInside)
        
        setLitButtonConstraints()
    }
    
    
    
    
    func setupCardViewConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 360).isActive = true
        
        cardViewBottomConstraint = cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 600)
        cardViewBottomConstraint.isActive = true
    }
    
    
    func setProfileViewConstraints() {
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30).isActive = true
        profileView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30).isActive = true
        profileView.heightAnchor.constraint(equalTo: profileView.widthAnchor, multiplier: 9.0/16.0).isActive = true
        
        profileView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30).isActive = true
    }
    
    
    func setTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        titleLabel.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 18).isActive = true
    }
    
    
    func setWWDCButtonConstraints() {
        wwdcButton.translatesAutoresizingMaskIntoConstraints = false
        wwdcButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30).isActive = true
        wwdcButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30).isActive = true
        wwdcButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        wwdcButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20).isActive = true
    }
    
    
    func setAboutButtonConstraints() {
        aboutButton.translatesAutoresizingMaskIntoConstraints = false
        aboutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        aboutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        aboutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        aboutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
    }
    
    func setLitButtonConstraints() {
        litButton.translatesAutoresizingMaskIntoConstraints = false
        litButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        litButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        litButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        litButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
    }
    
   func setPhysicsButtonConstraints() {
        physicsButton.translatesAutoresizingMaskIntoConstraints = false
        physicsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        physicsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        physicsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        physicsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 190).isActive = true
    }
    
    
    @objc func aboutCard() {
        cardViewBottomConstraint.constant = -10
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func runPhysics() {
        physicsControl.viewDidLoad()
        let vc = PhysicsController()
        vc.preferredContentSize = CGSize(width: 375, height: 812) //iPhone X, just helpful since I have an iPhone X
        PlaygroundPage.current.liveView = vc
    }
    
    @objc func runLit() {
        litControl.viewDidLoad()
        let vc = LitController()
        vc.preferredContentSize = CGSize(width: 375, height: 812) //iPhone X, just helpful since I have an iPhone X
        PlaygroundPage.current.liveView = vc
        
    }
    
  

}


        
        let vc = MyViewController()
        vc.preferredContentSize = CGSize(width: 375, height: 812) //iPhone X, just helpful since I have an iPhone X
        PlaygroundPage.current.liveView = vc


 

