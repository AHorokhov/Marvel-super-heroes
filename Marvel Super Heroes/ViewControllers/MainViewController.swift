//
//  MainViewController.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/15/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    // MARK: - lets & vars -
    
    @IBOutlet private weak var mainCollectionView: UICollectionView!
    @IBOutlet private weak var pageCollectionView: UICollectionView!
    private var downloadedHeroes: [Hero] = []
    private var pageCollectionDataSourceAndDelegate = PageCollectionViewController()
    private var alert = UIAlertController()

    private var dialogTransitionDelegate: DialogTransitioningDelegate?

    
    
    // MARK: - lifecycle - 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageCollectionView.dataSource = pageCollectionDataSourceAndDelegate
        pageCollectionView.delegate = pageCollectionDataSourceAndDelegate
        pageCollectionDataSourceAndDelegate.delegate = self
        LoadingOverlay.show(in: view, backgroundColor: UIColor.lightGray, animated: true)
        Manager.shared.getAllHeroes(offset: 0) { [weak self] heroes, totalCount, error in
            guard let self = self else { return }
            guard error == nil else {
                LoadingOverlay.hideAllLoadingOverlays(in: self.view, animated: true)
                return
            }
            self.downloadedHeroes = heroes.compactMap{ $0 }
            DispatchQueue.main.async {
                self.pageCollectionDataSourceAndDelegate.updateWithNumberOfPages(amount: (totalCount / 20) + 1)
                self.mainCollectionView.reloadData()
                self.pageCollectionView.reloadData()
                self.alert.dismiss(animated: true, completion: nil)
                LoadingOverlay.hideAllLoadingOverlays(in: self.view, animated: true)
            }
        }
        navigationController?.navigationBar.barTintColor = UIColor.lightGray
    }

}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadedHeroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "heroCollectionCell", for: indexPath) as? HeroCollectionViewCell else { return UICollectionViewCell() }
        cell.updateWith(hero: downloadedHeroes[indexPath.row])
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width / 2 - 15, height: 200)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailsVc = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: HeroDetailsViewController.storyboardIdentifier) as? HeroDetailsViewController else { return }
        dialogTransitionDelegate = DialogTransitioningDelegate()
        detailsVc.transitioningDelegate = dialogTransitionDelegate
        detailsVc.modalPresentationStyle = .custom
        detailsVc.updateWith(hero: downloadedHeroes[indexPath.row])
        present(detailsVc, animated: true, completion: nil)
    }
}

extension MainViewController: PageVCDelegate {
    func didSelectPage(number: Int) {
        LoadingOverlay.show(in: view, backgroundColor: UIColor.lightGray, animated: true)
        Manager.shared.getAllHeroes(offset: number * 20) { [weak self] heroes, totalCount, error in
            guard let self = self else { return }
            guard error == nil else {
                LoadingOverlay.hideAllLoadingOverlays(in: self.view, animated: true)
                return
            }
            self.downloadedHeroes = heroes.compactMap{ $0 }
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
                LoadingOverlay.hideAllLoadingOverlays(in: self.view, animated: true)

            }
        }
    }
}

