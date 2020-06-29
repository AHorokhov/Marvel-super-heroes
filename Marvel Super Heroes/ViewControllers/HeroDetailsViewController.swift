//
//  HeroDetailsViewController.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/20/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

class HeroDetailsViewController: UIViewController {
    
    @IBOutlet private weak var heroImaveView: UIImageView!
    @IBOutlet private weak var heroNameLabel: UILabel!
    @IBOutlet private weak var itemsStackView: UIStackView!
    private var selectedHero: Hero?
    private var loadedComics: [Item] = []
    private var loadedEvents: [Item] = []
    private var loadedSeries: [Item] = []
    private var loadedStories: [Item] = []
    private let downloadSession = URLSession(configuration: URLSessionConfiguration.ephemeral)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        loadItems()
    }
    
    func updateWith(hero: Hero) {
        selectedHero = hero
    }
    
    private func setupLayout() {
        guard let hero = selectedHero else { return }
        heroImaveView.loadImageFor(url: URL(string: hero.portraitImageUrlString))
        heroNameLabel.text = hero.name
    }
    
    private func loadItems() {
        let itemsCollection = ItemsCollectionViewController()
        let group = DispatchGroup()
        guard let hero = selectedHero else { return }
        hero.comicsURls.forEach { url in
            group.enter()
            let urlString = "\(url)\(Constants.charactes)?\(Constants.completedKey)"
            guard let url = URL(string: urlString) else { return }
            DispatchQueue.global().async {
                let task = self.downloadSession.dataTask(with: url) { [weak self] data, response, error in
                    guard let self = self else { return }
                    guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
                    let comics = Manager.shared.getResultsFrom(json: json)
                    guard let first = comics.first, let item = Item(json: first) else { return }
                    self.loadedComics.append(item)
                    
                    DispatchQueue.main.async {
                        group.leave()
                        self.setChildConroller(child: itemsCollection)
                        itemsCollection.updateWith(items: self.loadedComics)
                    }
                }
                task.resume()
            }
        }
    }
    
    private func setChildConroller(child: UIViewController) {
        child.willMove(toParent: self)
        self.addChild(child)
        self.itemsStackView.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }
    
    
}

extension HeroDetailsViewController: StoryboardInstantiable {
    static var storyboardIdentifier: String { return "Details" }
}

extension HeroDetailsViewController: PresentableAsDialog {
    var dialogSize: CGSize {
        if UIDevice.current.isIPhone() {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100)
        }
        else {
            return CGSize(width: 500.0, height: 250.0)
        }
    }
    
    func dialogBackgroundTapped() {
        dismiss(animated: true, completion: nil)
    }
}
