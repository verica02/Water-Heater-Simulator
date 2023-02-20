import QtQuick 2.15
import QtQuick.Window 2.15

import MyPackage 1.0

Window {
    width: 1040
    height: 480
    visible: true
    title: qsTr("Water Heater")

    SystemController{
        id:systemController

    }

    Loader{
        id:mainLoader
        source: "qrc:/UI/HomeScreen/HomeScreen.qml"
        anchors.fill:parent
    }
}
