# Coffee

[![iOS Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://img.shields.io/badge/platform-ios-lightgrey.svg)

## Requirments

A demonstration app that allows the user to use their location and find and display nearby coffee venues using the FourSquare API

## Notes

This sample app has been built using MVVM architecture, UIKit for View Controllers/ Views & Combine for networking. 

The view passes in handlers via a protocol, alternatives could use completion handlers. `VenueResults` decodable structs have been kept similar to the JSON response, I find this helps add/ remove nested results easily, rather than flattening the results.

`UICollectionViewDiffableDataSource` and `UICollectionViewCompositionalLayout` have been used, so we can implement varying scroll directions, if they're needed at a later stage.

The Client ID and Client Secret can be updated in `Resources` -> `DebugConfig.xconfig` and `ReleaseConfig.xconfig` 

Unit and UI tests have been added.

## Author

Maninder Soor (http://manindersoor.com)
