# MusicSearch
MusicSearch application is a demo application for searching music and playing previews.

Overview
=========================
User can search using Song Name or Artist name from the search bar at the top of the screen. The search results will be listed in the form of list below the search bar.

Using the download button on the search results list, a particular preview song can be downloaded. As the download button is tapped, a progress bar appears below the artist label and on completion of the download it disappears. On tapping the cell with downloaded preview, the preview song will be played. Tapping on a cell which does not have preview song downloaded, does not do anything.

Developement Enviroment
=========================

1. IDE - XCode v7.3
2. iOS SDK - v9.3
3. Minimum Deployment Target - iOS v8.0 and later.

Note: Testing was done on iPhone 6S simulator and iPhone 6S device. iPad orientation is also supported.

Functional Improvement
=========================
1. Store recent searches.
2. Making search as favorite.
3. Better control over the audio playback.

Areas of improvement
=========================

1. Currently the app does not checks for connectivity. While making a API call connectivity should be checked and the error should be handled elegantly.
2. Currently the app does not handles displaying the error returned from the API call if it fails.
3. SearchMusicViewController uses AVPlayerViewController. A custom viewcontroller can be created which as an instance of AVPlayer in it. By doing that the app can check if the playback was succesful.
4. Unit Testing can be improved by using a Mocking Framework.
5. UI Testing can be used.
6. On iOS simulator, there is a memory leak due to AVPlayer. However, this leak is not present on device. This seems to be an issue with framework for simulator. Here is the link: http://crosbymichael.com/avaudioplayer-memory-leak.html
7. There is room for improvement in the app design too. Example: TrackListActivity can be moved inside TrackManager instead of SearchMusicViewController.
