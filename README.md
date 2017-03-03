AppDelegate-Firebase
============

Example of using Firebase PushMessages in iOS

## Instruction
Add these pods to your project

```ruby
pod 'Firebase/Core'
pod 'Firebase/Messaging'
```

Add ```GoogleService-Info.plist``` file to your project

Copy [AppDelegate+Firebase.swift](https://github.com/steelkiwi/AppDelegate-Firebase/blob/master/AppDelegate+Firebase.swift) file to your project

Add next code to your AppDelegate ```didFinishLaunchingWithOptions``` method:
```swift
initNotifications(application: application, mode: .sandbox) // unknown, sandbox, prod
```

And add this method to your AppDelegate file:
```swift
internal func openNotification(userData: PushNotification) {

    // Push handling here
}
```

[Example of AppDelegate](https://github.com/steelkiwi/AppDelegate-Firebase/blob/master/AppDelegate.swift)
