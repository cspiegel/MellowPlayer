//DI.FM plugin

function getTitle() {
    try {
        return document.getElementsByClassName('track-name')[0].innerText.split('\n')[0];
    } catch(e) {
        return "";
    }
}

function getArtist() {
    try {
        return document.getElementsByClassName('artist-name')[0].innerText.replace(" - ","");
    } catch(e) {
        return "";
    }
}

function getArtUrl() {
	try {
        return document.getElementsByClassName('artwork')[1].children[0].children[0].src;
    } catch(e) {
        return "";
    }
}

function getSongId() {
	var songName = getTitle();
	if (songName != "") {
		return getHashCode(songName);
	}
	return ""
}

function getPosition() {
    try {
        position = document.querySelector("span[class*='timecode']").children[0].children[0].innerText;
    } catch(e) {
        return 0
    }
    return toSeconds(position)
}

function getDuration() {
    try {
        var time = document.querySelector("span[class*='timecode']").children[0].children[1].innerText;
    } catch(e) {
        return 0
    }
    return toSeconds(time)
}

function getPlaybackStatus() {
    if (document.querySelector('[data-state="playing"]'))
      return MellowPlayer.PlaybackStatus.PLAYING;
//    else if (document.querySelector('[data-state="paused"]'))
//  Di.FM has it different -> stopped="pause"
    else if (document.querySelector('[data-state="stopped"]'))
      return MellowPlayer.PlaybackStatus.PAUSED;
    else if (document.querySelector('[data-state="connecting"]'))
      return MellowPlayer.PlaybackStatus.BUFFERING;
    else
      return MellowPlayer.PlaybackStatus.STOPPED;
}

function update() {
    return {
        "playbackStatus": getPlaybackStatus(),
        "canSeek": false,
        "canGoNext": true,
        "canGoPrevious": false,
        "canAddToFavorites": false,
        "volume": 1,
        "duration": getDuration(),
        "position": getPosition(),
        "songId": getSongId,
        "songTitle": getTitle(),
        "artistName": getArtist(),
        "albumTitle": '',
        "artUrl": getArtUrl(),
        "isFavorite": false
    };
}

function play() {
    document.querySelector("a[class*='ico icon-play']").click();
}

function pause() {
   document.querySelector("a[class*='ico icon-pause']").click();
}

function goNext() {
    document.querySelector("a[class*='ico icon-skip']").click();
}

function goPrevious() {

}

function setVolume(volume) {

}

function addToFavorites() {
    //document.querySelector("a[class*='ico icon-star']").click();
}

function removeFromFavorites() {
    //document.querySelector("a[class*='ico icon-star']").click();
}

function seekToPosition(position) {

}
