//
//  ViewController.swift
//  ContactExample
//
//  Created by 박성원 on 25/08/2019.
//  Copyright © 2019 sungwon. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var complation: ((_ contact:[String:String]) -> ())?
    
    lazy var contacts: [CNContact] = {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey] as [Any] as [Any] as [Any]

        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        return results
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        var contactDic = [String: String]()

        contactDic["name"] = "\(contact.familyName)\(contact.givenName)"
        
        for ContctNumVar: CNLabeledValue in contact.phoneNumbers {
            contactDic["phoneNumber"] = (ContctNumVar.value).value(forKey: "digits") as? String
        }

        navigationController?.popViewController(animated: true)
        self.complation!(contactDic)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contact = contacts[indexPath.row]
        
        cell.textLabel?.text = "\(contact.familyName)\(contact.givenName)"
        
        for ContctNumVar: CNLabeledValue in contact.phoneNumbers {
            cell.detailTextLabel?.text = (ContctNumVar.value ).value(forKey: "digits") as? String
        }

        return cell
    }
}

