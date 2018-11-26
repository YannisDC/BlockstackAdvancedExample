# BlockstackAdvancedExample
This repository uses a Clean Architecture with an Application layer that uses MVVM, RxSwift and Coordinators. (Factories are being used to reuse viewcontrollers accross coordinators.)
The Blockstack SDK is seperated into a Platform layer to only **import Blockstack** in one place. 
In this app the **Domain layer is renamed to Core**.


## TODO
- [x] Convert Single<T?> to Maybe
- [ ] Add TabBarCoordinator to switch between different example screens
- [ ] Make a provider to easily make Networks/Repositories for different types (of Structs)
- [ ] Put the UI components into a seperate framework
- [ ] Add encryption on the cache by implementing a Cryptable protocol in the Structs
- [ ] Add unit tests
- [ ] Make seperate Blockstack app endpoint

## Final project goal
Seperate the Blockstack SDK into seperate platform layer and make it easily reusable for different types of structs. Work away the downsides of the Blockstack SDK compared to Firebase like offline first and realtime updates.
