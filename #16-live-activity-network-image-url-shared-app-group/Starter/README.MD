# Live Activity Broadcast Election Results iOS SwiftUI App

![alt text](https://i.ibb.co.com/BfxRWv8/Screenshot-2024-11-08-at-18-23-49.jpg)

The app provides features where users can listen to realtime updates from the firestore elections collection

It also supports the new iOS Live Activity Broadcast feature using APNS Channel to display real time election activity from Lock Screen and Dynamic Island. Stacks used: iOS with SwiftUI for client, Firestore Database, Google Cloud Function with nodeJS 18 runtime.

## Requirements
- Xcode 16 & iOS 18
- Replace the bundleID for the App with your own.
- Firebase iOS Project, download `GoogleService-info.plist` to your Xcode project target.
- Provide your Apple AuthKey.p8 with Apple Push Notification support in `firebase/functions` folder.
- Navigate to index.js in `firebase/functions` folder. Provide your Apple account teamID, p8 filePath, bundleID of your app.
- Update `.firebaserc` in `firebase`` folder to use your Firebase App projectID

## Flow
1. Store the election using firestore inside elections collection.
2. Attach cloud functions to listen to create, update, and delete document to run server side code
3. on create document will trigger code to create channelId using APNS channel management API, then it will write back the channelID to the document.
4. On update document, will trigger code to broadcast live activity updates to all subscribed client devices
5. On delete document, will trigger code to delete channelID using channel management API
6. The iOS App listens to firestore collections for elections.
7. The document contains channelId which user can use to start live activity with pushType Channel

## YouTube Tutorial
You can check the full video tutorial on building this from scratch.

[YouTube](https://youtu.be/MnPvg2rO-Cw)