//
//  ViewController.swift
//  I Am BoRedDd
//
//  Created by DarkBringer on 14.09.2021.
//

import SwiftSoup
import UIKit

class ViewController: UIViewController {
    @IBOutlet var titleText: UILabel!
    @IBOutlet var imageView: UIImageView!

    var htmlString = ""
    var imageLink = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // now lets create a two random letter and four random number to get a truly random image from the internet

        func unboreButtonPressAction() -> String {
            func randomString(length: Int) -> String {
                let letters = "abcdefghjklmnoprstuvwxyz"
                return String((0 ..< length).map { _ in letters.randomElement()! })
            }
            func randomNumber(length: Int) -> String {
                let numbers = "1234567890"
                return String((0 ..< length).map { _ in numbers.randomElement()! })
            }
            let randomLinkExtention = randomString(length: 2) + randomNumber(length: 4)
            titleText.text = "I am bored \(randomLinkExtention)"
            return randomLinkExtention
        }
        let myURLString = "https://prnt.sc/\(unboreButtonPressAction())" // random 2 letters and 4 numbers gives a random screenshot from this website...

        // handling the error if the link returns empty handed...
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        var htmlString = ""

        // lets take the link and try to parse it and find the actual image url inside the html code... (THIS TOOK ME EMBARASSING AMOUNT OF TIME TO COMPLETE)

        do { // lets take the link and make it html code
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            htmlString = myHTMLString
        } // catch if something goes wrong
        catch let error {
            print("Error: \(error)")
        }
        // check if there is a htmlString
        print(htmlString)

        // we need a pod to parse the html code, SwiftSoup (already installed via swift package manager)

        do {
            // of course we need to import it first
            let doc: Document = try SwiftSoup.parse(htmlString)
            let srcs: Elements = try doc.select("img[src]")
            let srcsStringArray: [String?] = srcs.array().map { try?
                $0.attr("src").description
            }
            // we actually know we need the first item on the image link array...
            imageLink = srcsStringArray[0] ?? "placeholder image link in case it is nil"
        } catch let Exception.Error(_, message) {
            print(message)
        } catch {
            print("error")
        }

        // now its time to show the image with the imageView and the link we got from above

        do {
            let url = URL(string: imageLink)
            let data = try Data(contentsOf: url!)
            imageView.image = UIImage(data: data)
        } catch {
            print(error)
        }
    }

    @IBAction func pressToBeUnbored(_ sender: UIButton) {
        viewWillAppear(true)
        viewDidLoad()
    }
}
