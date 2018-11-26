# BlockstackAdvancedExample
This repository uses a Clean Architecture with MVVM, RxSwift and Coordinators. The Blockstack SDK is seperated into a platform layer to only **import Blockstack** in one place. In this app the **Domain is renamed to Core**.

## TODO
- [ ] Convert Single<T?> to Maybe
- [ ] Add TabBarCoordinator to switch between different example screens
- [ ] Make a provider to easily make Networks/Repositories for different types (of Structs)
- [ ] Put the UI components into a seperate framework
- [ ] Add encryption on the cache by implementing a Cryptable protocol in the Structs

## Final project goal
Seperate the Blockstack SDK into seperate platform layer and make it easily reusable for different types of structs. Work away the downsides of the Blockstack SDK compared to Firebase like offline first and realtime updates.
