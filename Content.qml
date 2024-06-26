import QtQuick
import QtQuick.Layouts
import QtMultimedia
import QtQuick.Controls

import QtQuick.Dialogs

Frame {
    anchors.fill: parent

    property alias backgrondImage: _backgrondImage
    property alias multipics: _multipics
    property alias popupbackgrounde: _poppupbackground

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

    RowLayout {
        anchors.fill: parent

        ColumnLayout {
            id: _leftLayout
            width: 300
            height: 350
            Layout.fillWidth: true
            Layout.fillHeight: true

            // -----放置图片(换成Image)
            Image {
                id: _backgrondImage
                width: 200
                height: 150
            }

            Rectangle {
                width: 200
                height: 30
                color: "transparent"
                Text {
                    // text: "author"
                    anchors.centerIn: parent
                }
            }
            Rectangle {
                width: 200
                height: 30
                color: "transparent"
                Text {
                    //  text: "album"
                    anchors.centerIn: parent
                }
            }
        }

        ColumnLayout {
            Rectangle {
                width: 300
                height: 350
                color: "transparent"
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    id: _songRect
                    width: 200
                    height: 200
                    color: "transparent"
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right

                    // visible: false
                    // z: -1
                    ScrollView {
                        id: _scorllView
                        anchors.fill: parent
                        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                        ScrollBar.vertical.policy: ScrollBar.AsNeeded

                        ListView {
                            id: _songlist
                            anchors.fill: parent
                            clip: true

                            model: 100
                            ListModel {
                                id: filesModel
                            }
                        }

                        component MyDelegate: Rectangle {
                            id: songRoot

                            property url filePath: filePath
                            width: parent.width
                            height: 30
                        }
                    }
                }
            }
        }
    }

    //从指定的媒体文件路径（fp）中提取标题和作者信息
    function getTitle(fp, i) {
        var metaDataReader = Qt.createQmlObject(
                    'import QtMultimedia;MediaPlayer{audioOutput:AudioOutput{}}',
                    root, "")
        metaDataReader.source = fp

        function f() {
            //媒体的状态加载完成时
            if (metaDataReader.mediaStatus === MediaPlayer.LoadedMedia) {
                filesModel.setProperty(i, "title",
                                       metaDataReader.metaData.stringValue(
                                           MediaMetaData.Title))
                filesModel.setProperty(i, "author",
                                       metaDataReader.metaData.stringValue(
                                           MediaMetaData.ContributingArtist))
                metaDataReader.destroy()
            }
        }
        metaDataReader.mediaStatusChanged.connect(f)
    }
    MediaPlayer {
        id: _player
        audioOutput: AudioOutput {
            id: _audioOutput
        }
    }

    function setFilesModel(selectedFiles) {
        filesModel.clear()
        for (var i = 0; i < selectedFiles.length; i++) {
            var filePath = selectedFiles[i]
            var data = {
                "filePath": filePath,
                "title": "loading",
                "author": "loading"
            }
            filesModel.append(data)
            getTitle(filePath, i)
        }
    }
    Popup {
        id: _poppupbackground
        //浏览多张图片视图
        GridView {
            Layout.preferredWidth: 400
            Layout.preferredHeight: 200
            Layout.fillHeight: true
            Layout.fillWidth: true
            id: _multipics
            anchors.fill: parent
            property int fillMode: Image.PreserveAspectFit
            ListModel {
                id: _filesModel
            }
        }
    }
}
