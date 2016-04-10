# Hacker News Reader for iOS

A very tiny hacker news reader for iOS (http://news.ycombinator.com)

### Features

##### Released

* Load the list of news from YCombinator APIs.
* Load the visible stories asynchronously
* Read any story with the SFSafariViewController from iOS 9 APIs

##### In progress

* Readed stories marked in gray
* Syncing readed stories through devices with iCloud storage

### Building

If you don't have Cocoapods already, install it with
`sudo gem install cocoapods`

Then, use `pod install` in the repository directory to install dependencies.

You can then build the app on either the simulator or a device.

Note that you won't be able to build a release version of the app without either
adding Fabrics Keys, or removing any Fabric integration codes.
