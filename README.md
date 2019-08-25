# Maps

This is a sample project comparing MapKit and GoogleMaps SDK. It implements (almost) same functionalities in both frameworks.

## Features

* Displaying map
* Dark mode support (out of the box for MapKit, custom one for GoogleMaps - simple subclass of `GMSMapView` which reacts to `UITraitCollection` changes by updating map style)
* Displaying custom tiles over the map (from OpenStreetMaps)
* Displaying markers with given points of interest
* Marker clustering

## Google-Maps-iOS-Utils issues

[Google-Maps-iOS-Utils](https://github.com/googlemaps/google-maps-ios-utils) is utility library for GoogleMaps. It contains several helpers, e.g. for clustering. Unfortunately, it doesn't work well with Swift when using CocoaPods. Because of that, library is added by including its source code in the project. Some headers had to be altered to fix build errors (Solution found [here](https://github.com/googlemaps/google-maps-ios-utils/issues/86#issuecomment-310500599)). Source code was also stripped from unused features - Geometry and Heatmap.