//
//  CharactersTableViewController.swift
//  flink
//
//  Created by beTech CAPITAL on 06/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation
import UIKit

class CharacterTableViewController: UITableViewController, UISearchResultsUpdating{
    
    var resultSearchController = UISearchController()
    var characterListViewModel = CharacterListViewModel()
    
    var nextPage: String = ""
    var isUpdating: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        populateCharacters()
    }
    
    private func configUI(){
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        resultSearchController = ({
               let controller = UISearchController(searchResultsController: nil)
               controller.searchResultsUpdater = self
               controller.searchBar.sizeToFit()

               tableView.tableHeaderView = controller.searchBar

               return controller
           })()
        
        
    }
    
    private func findCharacter(name : String){
        self.tableView.showLoader()
        self.characterListViewModel.restoreCharacters()
        self.tableView.reloadData()

        Webservice().load(resource: CharactersOptions.getCharacterByName(name: name)){[weak self] result in
            DispatchQueue.main.async {
                switch result{
                    case .success(let response):
                        self?.nextPage = response.info.next
                        self?.tableView.restore(showSingleLine: true)
                        self?.characterListViewModel.charactersViewModel = response.results.map(CharacterViewModel.init)
                       
                        if !(self?.nextPage.isEmpty)!{
                            self?.characterListViewModel.charactersViewModel.append((self?.characterListViewModel.getNilObject())!)
                        }
                        
                        self?.tableView.reloadData()
                    case .failure(_):
                        self?.tableView.restore(showSingleLine: false)
                        self?.tableView.setEmptyView(title: "Sin resultados", message: "Tú busqueda no arrojo ningún resultado", messageImage: UIImage.init(named: "navegador.png")!)
                        
                }
            }
            
            
        }
        
    }
    
    private func populateCharacters(nextPage: String = ""){
        self.tableView.showLoader()
        
        if nextPage.isEmpty{
            DispatchQueue.main.async {
                Webservice().load(resource: CharactersOptions.get){[weak self] result in
                    switch result{
                        case .success(let response):
                            self?.nextPage = response.info.next
                            self?.tableView.restore(showSingleLine: true)
                            self?.characterListViewModel.charactersViewModel = response.results.map(CharacterViewModel.init)
                           
                            if !(self?.nextPage.isEmpty)!{
                            self?.characterListViewModel.charactersViewModel.append((self?.characterListViewModel.getNilObject())!)
                            }
                            
                            self?.tableView.reloadData()
                        case .failure(let error):
                            print(error)
                    }
                    
                }
            }
            
        }else{
            DispatchQueue.main.async {
                Webservice().load(resource: CharactersOptions.getCharacterNP(page: nextPage)){[weak self] result in
                    switch result{
                        case .success(let response):
                            
                            self?.nextPage = response.info.next
                        
                            self?.characterListViewModel.charactersViewModel.append(contentsOf: response.results.map(CharacterViewModel.init))
                                
                               if !(self?.nextPage.isEmpty)!{
                            self?.characterListViewModel.charactersViewModel.append((self?.characterListViewModel.getNilObject())!)
                                }
                            
                            self?.tableView.reloadData()
                            self?.isUpdating = false
                        case .failure(let error):
                            print(error)
                    }
                    
                }
            }
        }
    }
    
    // MARK: TABLE VIEW METHODS
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.nextPage.isEmpty{
            return self.characterListViewModel.charactersViewModel.count - 1
        }else{
            return self.characterListViewModel.charactersViewModel.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = self.characterListViewModel.characterViewModel(at: indexPath.row)
        
        if vm.character.id != nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell", for: indexPath) as! CharacterTableViewCell
            
            cell.nameLabel?.text = vm.character.name
            cell.specieLabel?.text = vm.character.species
            cell.statusLabel?.text = vm.character.status
            cell.profileImageView.image = nil
            cell.loader.isHidden = false
            cell.loader.startAnimating()
            cell.loader.color = AppConfigurator.mainColor
            
            Tools.downloadImage(url: URL(string: vm.character.image!)!) { (image, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        cell.loader.isHidden = true
                        cell.profileImageView.image = image
                    }
                }
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoaderCell", for: indexPath) as! LoaderCell
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vm = self.characterListViewModel.charactersViewModel[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailC =  storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailC.character = vm.character
        self.navigationController?.pushViewController(detailC, animated: true)
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if !self.nextPage.isEmpty{
                if !self.isUpdating{
                    self.isUpdating = true
                    self.characterListViewModel.charactersViewModel.removeLast()
                    self.populateCharacters(nextPage: nextPage)

                }
                
            }
        }
    }
    
    
    
    // MARK: SEARCH BAR METHODS
    
    func updateSearchResults(for searchController: UISearchController) {
    
        let text = searchController.searchBar.text!
        
        if (searchController.isBeingPresented){
            self.characterListViewModel.auxCharacters = self.characterListViewModel.charactersViewModel
        }
        
        if (!searchController.isBeingPresented){
            if !text.isEmpty{
                self.findCharacter(name: text.replacingOccurrences(of: " ", with: "%20"))
            }
        }
        if (searchController.isBeingDismissed){
            if text.isEmpty{
                self.characterListViewModel.charactersViewModel = self.characterListViewModel.auxCharacters
                self.tableView.reloadData()
            }
            
        }
        
    }
}
