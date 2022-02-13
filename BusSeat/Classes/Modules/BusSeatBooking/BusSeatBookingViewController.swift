//
//  ViewController.swift
//  BusSeat
//
//  Created by Dkatalis on 12/02/22.
//

import UIKit

class BusSeatBookingViewController: UIViewController {

    //Properties
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        let seatLayout = BusSeatFlowLayout()
        //seatLayout.self
        seatLayout.itemSize = CGSize(width: 50, height: 50)
        collectionView.setCollectionViewLayout(seatLayout, animated: true)

        collectionView.register(UINib(nibName: String(describing: BusSeatCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: BusSeatCell.self))
        collectionView.register(UINib(nibName: String(describing: DriverSeatCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: DriverSeatCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.borderWidth = 1.0
        collectionView.layer.borderColor = UIColor.lightGray.cgColor
        collectionView.layer.cornerRadius = 10.0
        return collectionView
    }()
    
    var viewModel = BusSeatBookingViewModel()

    var heightCollectionConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        if height == 0 {
            heightCollectionConstraint?.constant = 300

        } else {
            heightCollectionConstraint?.constant = height

        }
        self.view.layoutIfNeeded()
    }
}


extension BusSeatBookingViewController {
    
    func setupView() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80.0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80.0).isActive = true
        let heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint.isActive = true
        self.heightCollectionConstraint = heightConstraint
        
    }
}
extension BusSeatBookingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfSeat(compartment: viewModel.sections[section])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let compartment: Compartment = viewModel.sections[indexPath.section]
        
        switch compartment {
            
        case .driverSeat:
            guard let driverCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DriverSeatCell.self), for: indexPath) as? DriverSeatCell else {return UICollectionViewCell()}
            return driverCell
        case .passengerSeat:
            guard let cell: BusSeatCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BusSeatCell.self), for: indexPath) as? BusSeatCell else { return UICollectionViewCell() }
            
            cell.setData(item: String(indexPath.row))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        if let cell: BusSeatCell = collectionView.cellForItem(at: indexPath) as? BusSeatCell {
            cell.seatIcon.image = UIImage(named: "seat-fill")

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let compartment: Compartment = viewModel.sections[indexPath.section]
        
        switch compartment {
        case .passengerSeat:
            return CGSize(width: collectionView.frame.width, height: 120)

        case .driverSeat:
            return CGSize(width: collectionView.frame.width/4, height: 40)
        }
    }
}
