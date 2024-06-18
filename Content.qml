import QtQuick
import QtQuick.Layouts
import QtMultimedia
// import QtQuick.Layouts
import QtQuick.Controls

Item {

    property alias multipics:multiPics
    property alias popupbackgrounde:_poppupbackground
    RowLayout{
        ColumnLayout{

        }
    }

    //从指定的媒体文件路径（fp）中提取标题和作者信息
    function getTitle(fp,i){
        var metaDataReader=Qt.createQmlObject(
                    'import QtMultimedia;MediaPlayer{audioOutput:AudioOutput{}}',
                    root,"")
        metaDataReader.source=fp;

        function f(){
            //媒体的状态加载完成时
            if(metaDataReader.mediaStatus===MediaPlayer.LoadedMedia){
            filesModel.setProperty(i,"title",
                                   metaDataReader.metaData.stringValue(MediaMetaData.Title))
            filesModel.setProperty(i,"author",
                                   metaDataReader.metaData.stringValue(MediaMetaData.ContributingArtist))
                                  metaDataReader.destroy()
            }
        }
        metaDataReader.mediaStatusChanged.connect(f);
    }
    MediaPlayer{
        id:_player
        audioOutput: AudioOutput{
            id:_audioOutput
        }
    }

    function setFilesModel (selectedFiles){
        filesModel.clear();
        for(var i=0;i<selectedFiles.length;i++){
            var filePath=selectedFiles[i]
            var data={
                "filePath":filePath,
                "title":"loading",
                "author":"loading"
            };
            filesModel.append(data);
            getTitle(filePath,i);
        }
    }
Popup{
    id:_poppupbackground
        //浏览多张图片视图
        GridView {
            Layout.preferredWidth: 400
            Layout.preferredHeight: 200
            Layout.fillHeight: true
            Layout.fillWidth: true
            id:multiPics
            anchors.fill: parent
            property int fillMode: Image.PreserveAspectFit
            ListModel{
                id:_filesModel
            }

            delegate: imageDelegate
        }
        Component {
            id: imageDelegate
            Image {
                id:image
                width: multiPics.cellWidth - 10;
                height: multiPics.cellHeight - 10
                fillMode: multiPics.fillMode
                asynchronous: true
                source: filePath
                //            Text {
                //                id: name
                //                text: qsTr("index:"+index)
                //            }

                TapHandler{
                    id:mouseArea
                    onTapped:{
                                  multiPics.currentIndex=index
                                  console.currentIndex=index
                                  console.log("currentIndex in multiPics:",multiPics.currentIndex)
                              }
                }
            }
        }

}
}
