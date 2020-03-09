//
//  CharactersTableViewController.swift
//  flink
//
//  Created by beTech CAPITAL on 06/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation
import UIKit

class CharacterTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate{
    
    var resultSearchController = UISearchController()
    var characterListViewModel = CharacterListViewModel()
    
    var nextPage: String = ""
    var isUpdating: Bool = false
    var auxTexSearchBar: String = ""
    var queryParameter: String = "name"
    let itemsStatus = ["Alive" , "Dead", "Unknown"]
    let itemsGenders = ["Female", "Male", "Genderless", "Unknown"]
    var initialEffect: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        populateCharacters()
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        configSearchBar(placeHolder: Strings.searchByName)
        populateCharacters()
    }
    
    private func configUI(){
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: Strings.pullToGet)
        self.refreshControl!.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(self.refreshControl!)
        
        configSearchBar(placeHolder: Strings.searchByName)
    
    }
    
    private func configSearchBar(placeHolder: String) {
        
        resultSearchController.searchResultsUpdater = self
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchBar.placeholder = placeHolder
        resultSearchController.searchBar.showsCancelButton = false
        tableView.tableHeaderView = resultSearchController.searchBar

    }
    
    private func configSegmentedStatus(){
        self.tableView.tableHeaderView = nil
        
        let segmentedControl = UISegmentedControl(items : itemsStatus)
        segmentedControl.addTarget(self, action: #selector(self.indexChangedStatus(_:)), for: .valueChanged)

        self.tableView.tableHeaderView = segmentedControl
    }
    
    private func configSegmentedGender(){
       self.tableView.tableHeaderView = nil
        
        let segmentedControl = UISegmentedControl(items : itemsGenders)
        segmentedControl.addTarget(self, action: #selector(self.indexChangedGender(_:)), for: .valueChanged)

        self.tableView.tableHeaderView = segmentedControl
    }
    
    private func findCharacter(name : String){
        
        self.tableView.showLoader()
        self.characterListViewModel.restoreCharacters()
        self.updateData()

        if let character = CharactersOptions.getCharacterByName(name: name, queryParameter: self.queryParameter){
            Webservice().load(resource:character){[weak self] result in
                DispatchQueue.main.async {
                    switch result{
                        case .success(let response):
                            self?.nextPage = response.info.next
                            self?.tableView.restore(showSingleLine: true)
                            self?.characterListViewModel.charactersViewModel = response.results.map(CharacterViewModel.init)
                           
                            if !(self?.nextPage.isEmpty)!{
                                self?.characterListViewModel.charactersViewModel.append((self?.characterListViewModel.getNilObject())!)
                            }
                            
                            self?.updateData()
                        case .failure(_):
                            self?.tableView.restore(showSingleLine: false)
                            self?.tableView.setEmptyView(title: Strings.noResults, message: Strings.noResultsDesc, messageImage: UIImage.init(named: "navegador.png")!)
                            
                    }
                }
                
                
            }
            
        }else{
            
            self.tableView.restore(showSingleLine: false)
            self.tableView.setEmptyView(title: Strings.errorSearch, message: Strings.errorSearchDesc, messageImage: UIImage.init(named: "nube.png")!)
        }
            
    }
    
    private func populateCharacters(nextPage: String = ""){
        
        self.tableView.showLoader()
        
        if Tools.hasInternet(){
            self.tableView.isScrollEnabled = true
            if nextPage.isEmpty{
                DispatchQueue.main.async {
                    Webservice().load(resource: CharactersOptions.get){[weak self] result in
                        if (self?.refreshControl!.isRefreshing)!{
                            self?.refreshControl?.endRefreshing()
                        }
                        
                        switch result{
                            case .success(let response):
                                self?.nextPage = response.info.next
                                self?.tableView.restore(showSingleLine: true)
                                self?.characterListViewModel.charactersViewModel = response.results.map(CharacterViewModel.init)
                               
                                if !(self?.nextPage.isEmpty)!{
                                self?.characterListViewModel.charactersViewModel.append((self?.characterListViewModel.getNilObject())!)
                                }
                                
                                self?.updateData()
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
                                
                                self?.updateData()
                                self?.isUpdating = false
                            case .failure(let error):
                                print(error)
                        }
                        
                    }
                }
            }
        }else{
            self.tableView.isScrollEnabled = false
            self.tableView.restore(showSingleLine: false)
            self.tableView.setEmptyView(title: Strings.noWifi, message: Strings.noWifiDesc, messageImage: UIImage.init(named: "nowifi.png")!, select: #selector(self.retryConnection), delegate: self)
        }
        
    }
    
    @objc func retryConnection() {
        self.tableView.restore(showSingleLine: false)
        populateCharacters()
    }
    
    func updateData(){
       let dispatchTime = DispatchTime.now() + 0.10;
       DispatchQueue.main.asyncAfter(deadline: dispatchTime){
                      
           if self.initialEffect == false
           {
               self.initialEffect = true
               UIView.transition(with: self.tableView, duration: 0.50,
                                 options: UIView.AnimationOptions.transitionCrossDissolve,
                                 animations: {
                                   self.tableView.reloadData()
                                   
               },
                                 completion: nil)
           }
           else
           {
               UIView.transition(with: self.tableView!, duration: 0.30,
                                 options: UIView.AnimationOptions.transitionCrossDissolve,
                                 animations: {
                                   self.tableView.reloadData()
                                   
               },
                                 completion: nil)
           }
           
       }
   }
    
    // MARK: TABLE VIEW METHODS
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !self.nextPage.isEmpty{
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
                    if Tools.hasInternet(){
                    self.characterListViewModel.charactersViewModel.removeLast()
                        self.populateCharacters(nextPage: nextPage)
                    }else{
                        showAlertNoWifi()
                    }
                    
                }
                
            }
        }
        
    }
    
    private func showAlertNoWifi(){
        let alert = UIAlertController(title: Strings.noWifi, message: Strings.noWifiDesc, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default, handler:nil))
        self.present(alert, animated: true)
    }
    
    
    // MARK: SEARCH FILTER ITEM CLICK
    @IBAction func searchFilter(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Select search filter", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Name", style: .default, handler: {action in
            self.configSearchBar(placeHolder: Strings.searchByName)
            self.queryParameter = "name"
        }))
        
        alert.addAction(UIAlertAction(title: "Status", style: .default, handler: {action in
            self.configSegmentedStatus()
            self.queryParameter = "status"
        }))
        
        alert.addAction(UIAlertAction(title: "Specie", style: .default, handler: {action in
            self.configSearchBar(placeHolder: Strings.searchBySpecie)
            self.queryParameter = "species"
        }))
        
        alert.addAction(UIAlertAction(title: "Type", style: .default, handler: {action in
            self.configSearchBar(placeHolder: Strings.searchByType)
            self.queryParameter = "type"
        }))
        
        alert.addAction(UIAlertAction(title: "Gender", style: .default, handler: {action in
            self.configSegmentedGender()
            self.queryParameter = "gender"
        }))
        alert.addAction(UIAlertAction(title: Strings.cancel, style: .cancel, handler: nil))

    
        self.present(alert, animated: true)
    }
    
    // MARK: SEGMENTED CONTROL METHODS
    @objc private func indexChangedStatus(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 0:
            self.findCharacter(name: itemsStatus[sender.selectedSegmentIndex])
        case 1:
            self.findCharacter(name: itemsStatus[sender.selectedSegmentIndex])
        case 2:
            self.findCharacter(name: itemsStatus[sender.selectedSegmentIndex])
        default:
            break
        }
    }
    
    @objc private func indexChangedGender(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 0:
            self.findCharacter(name: itemsGenders[sender.selectedSegmentIndex])
        case 1:
            self.findCharacter(name: itemsGenders[sender.selectedSegmentIndex])
        case 2:
            self.findCharacter(name: itemsGenders[sender.selectedSegmentIndex])
        case 3:
            self.findCharacter(name: itemsGenders[sender.selectedSegmentIndex])
        default:
            break
        }
    }
    
    // MARK: SEARCH BAR METHODS
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    
        let text = searchController.searchBar.text!
        self.auxTexSearchBar = text
        
        if (searchController.isBeingPresented){
            self.characterListViewModel.auxCharacters = self.characterListViewModel.charactersViewModel
        }
        
        if (!searchController.isBeingPresented){
            if !text.isEmpty{
                if Tools.hasInternet(){
                    self.findCharacter(name: text.replacingOccurrences(of: " ", with: "%20"))
                }
            }
        }
    
    }
}
