//
//  ViewController.swift
//  usingSizeClassProgrammatically
//
//  Created by Nguyễn Hữu Khánh on 22/03/2021.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- STEP 1 Create three different arrays, that contains NSLayoutConstraint type
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    
    //MARK:- STEP 2 And then create UI elements
    private lazy var view1: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        return view
    }()
    private lazy var view2: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return view
    }()
    private lazy var view3: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        return view
    }()
    
    let label1: UILabel = {
        let label1 = UILabel()
        label1.text = "Test Size text"
        label1.translatesAutoresizingMaskIntoConstraints = false
        return label1
    }()
    

    override func loadView() {
        super.loadView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        // setupUI
        addSubviews()
        
        // setupConstraints
        setupConstraints()
        
        // Activate common constraints
        NSLayoutConstraint.activate(sharedConstraints)
        
        // Capture current trait collections
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }

    //MARK:- Add Subviews
    func addSubviews() {
        [view1, view2, view3].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view3.addSubview(label1)
    }
    
    //MARK:- UI SWITCH
    func uiSwitch(_ status: Size) {
        if status == .Compact {
            label1.font = UIFont.boldSystemFont(ofSize: 30)
            label1.textColor = .red
        } else {
            label1.font = UIFont.boldSystemFont(ofSize: 60)
            label1.textColor = .blue
        }
    }
    
    //MARK: - Setup constraints
    func setupConstraints(){
     
        compactConstraints.append(contentsOf: [
            view1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            view2.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 20),
            view2.leadingAnchor.constraint(equalTo: view1.leadingAnchor),
            view2.trailingAnchor.constraint(equalTo: view1.trailingAnchor),
            view3.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: 20),
            view3.leadingAnchor.constraint(equalTo: view2.leadingAnchor),
        ])
        
        regularConstraints.append(contentsOf: [
            view1.trailingAnchor.constraint(equalTo: view2.leadingAnchor, constant: -20),
            view1.bottomAnchor.constraint(equalTo: view3.topAnchor, constant: -20),
            view1.widthAnchor.constraint(equalTo: view2.widthAnchor),
            view2.topAnchor.constraint(equalTo: view1.topAnchor),
            view2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            view2.bottomAnchor.constraint(equalTo: view1.bottomAnchor),
            view3.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: 20),
            view3.leadingAnchor.constraint(equalTo: view1.leadingAnchor),
            
        ])
        
        sharedConstraints.append(contentsOf: [
            view1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            view1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            view2.heightAnchor.constraint(equalTo: view1.heightAnchor),
            view3.trailingAnchor.constraint(equalTo: view2.trailingAnchor),
            view3.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            view3.heightAnchor.constraint(equalTo: view2.heightAnchor),
            label1.centerXAnchor.constraint(equalTo: view3.centerXAnchor),
            label1.centerYAnchor.constraint(equalTo: view3.centerYAnchor),
        ])
    }
    
    //MARK:- decisions for autolayout with selected iphone screen size and orientations
    func layoutTrait(traitCollection: UITraitCollection) {
        
        if let first = sharedConstraints.first {
            // If sharedConstraints.isActivate = false then activate it
            if !first.isActive {
                NSLayoutConstraint.activate(sharedConstraints)
            }
        }
        
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            // we are on iphone screen size and vertical orientaion
            if regularConstraints.count > 0 && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            NSLayoutConstraint.activate(compactConstraints)
            uiSwitch(.Compact)
            
        } else { // else we are on ipad or iphone horizontal orientation
            if compactConstraints.count > 0 && compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            NSLayoutConstraint.activate(regularConstraints)
            uiSwitch(.Regular)
        }
    }
    
    //MARK:- STEP 05:  Override traitCollectionDidChange method, this will be notified when iPhone has changed in different orientations.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }

}

