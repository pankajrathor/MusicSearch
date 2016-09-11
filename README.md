# MusicSearch
MusicSearch application is a demo application for searching music and playing previews.

Overview
=========================
User can search using Song Name or Artist name from the search bar at the top of the screen. The search results will be listed in the form of list below the search bar.

Using the download button on the search results list, a particular preview song can be downloaded. As the download button is tapped, a progress bar appears below the artist label and on completion of the download it disappears. 

Preview songs downloaded once remain within the application directory. The search result will not show the "Download" button if the preview song has already been downloaded. On tapping the cell with downloaded preview, the preview song will be played. Tapping on a cell which does not have preview song downloaded, does not do anything.

Developement Enviroment
=========================

1) IDE - XCode v7.3
2) iOS SDK - v9.3
3) Minimum Deployment Target - iOS v8.0 and later.

Note: Testing was done on iPhone 6S simulator and iPhone 6S device. iPad orientation is also supported.

Functional Improvement
=========================
1) Store recent searches.
2) Making search as favorite.
3) Better control over the audio playback.

Areas of improvement
=========================

1) UI is very basic. It can be made attractive.
2) For unit testing, basic test cases have been written for demonstration purpose. Elaborated Unit testing is possible using other unit testing frameworks like OCMockito, Calabash etc.
3) Error handling can be improved and made more graceful.
4) Internet connectivity and reachability checking can be added before request the web service.

