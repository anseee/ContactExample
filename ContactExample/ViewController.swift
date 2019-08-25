//
//  ViewController.swift
//  ContactExample
//
//  Created by 박성원 on 25/08/2019.
//  Copyright © 2019 sungwon. All rights reserved.
//

import UIKit
import Contacts

struct Contact {
    var name: String
    var phoneNumber : String
    
    init(name: String, phoneNumber: String) {
        self.name = name
        self.phoneNumber = phoneNumber
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var complation: ((_ contact: Contact) -> ())?
    
    var contactModels = [Contact]()
    
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
        
        for contact in self.contacts {
            for contctNumVar: CNLabeledValue in contact.phoneNumbers {
                let contact = Contact(name: "\(contact.familyName)\(contact.givenName)",
                    phoneNumber: (contctNumVar.value).value(forKey: "digits") as? String ?? "")
                self.contactModels.append(contact)
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO : change your navigation Controller
        navigationController?.popViewController(animated: true)
        self.complation!(contactModels[indexPath.row])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contact = contactModels[indexPath.row]
        
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phoneNumber
        
        return cell
    }
}

