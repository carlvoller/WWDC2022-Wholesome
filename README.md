# WWDC22 Swift Student Challenge (Accepted)

Wholesome is my 2022 Swift Student Challenge Submission (Accepted).

To run this project, please airdrop it to an iPad running iPadOS 15 with Swift Playgrounds 4 installed.

## Information on my submission

### What is the app about?
Wholesome SSC is my attempt at making use of the various Apple Development Kits to enact small positive change regarding mental health. The idea is to recognise the importance or impact of even small acts of kindness such as giving compliments, and encourage them through this app.

### How does it work?
When you enter the first actually interactable part of the app, you are given a canvas. Using your Apple Pencil, you can write notes of kindness onto this canvas. The app will detect text written into the canvas, then run that text through a sentiment analyser. If your note or compliment passes the vibe check, you will be allowed to add it as a compliment to an overarching list of compliments.

Once you have your list of compliments, you will then be brought to a Camera view. Your goal now is to roam around and search for people to use your compliments on! When the app detects that a person is within the view of the iPad's camera, you can tap on a compliment and the iPad will annouce the compliment our loud to the receiving party.

Do this as many times as you like, and rack up more and more points each time you do so!

## Technology Used

**SwiftUI and UIKit** was used for the User Interface, with SwiftUI handling the bulk of it, and UIKit used for compatibility with certain protocols in the Vision, NaturalLanguage or CoreML framework that required to be hooked onto a View/ViewController.

**Vision** was used for text recognition in the canvas, as well as Person recognition in the camera view.

**CoreML** was used for recognising objects within the view of the camera and tagging objects once recognised. In this app, I used the free YOLOv3TinyInt8LUT model provided by Apple and ignored all tags except for Persons.

**PencilKit** was used for the canvas creation and all Apple Pencil related tools.

**NaturalLanguage** was used to detect textual sentiment within compliments written into the canvas.

**AVFoundation** was used for the camera view as well as the audio that is played when a compliment is tapped on.
