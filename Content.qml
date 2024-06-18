import QtQuick
import QtQuick.Layouts
import QtMultimedia
import QtQuick.Controls
import QtQuick.Dialogs

Item {
    property alias dialogs: _dialogs
    property alias audio: _audio
    property alias playmusic: _playmusic
    Text {
        id: text
        font.pointSize: 24
        width: 150
        height: 50
    }
    TapHandler {
        onTapped: {
            playMusic.play()
        }
    }
    Dialogs {
        id: _dialogs
    }
    MediaPlayer {
        id: _playmusic
        audioOutput: AudioOutput {
            id: _audio
        }
    }

    function openMusic(newFilepath: url) {
        let index = newFilepath.toString().lastIndexOf('/')
        if (index !== -1) {
            var data = playmusic.metaData
            text.text = newFilepath
            console.log("title:", text.text)
        }
        _playmusic.source = newFilepath.toString()
        _playmusic.play()
    }
}
