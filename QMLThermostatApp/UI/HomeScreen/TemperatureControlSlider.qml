import QtQuick 2.15
import QtQuick.Controls 2.12


Slider {
    id:temperatureControlSlider
    from:55
    to:85
    stepSize:1
    orientation: Qt.Vertical
    onValueChanged:systemController.setTargetTemp(value)
    background: Rectangle{
        height:parent.height
        width:3
        anchors.centerIn: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#f7dd57" }
            GradientStop { position: 0.5; color: "#b630db" }
            GradientStop { position: 1.0; color: "#52048a" }
        }

    }

    handle: Rectangle{
        y:temperatureControlSlider.visualPosition * (temperatureControlSlider.availableHeight - height)
        color:"#000000"
        border.color:"#ffffff"
        border.width:3
        anchors.horizontalCenter: parent.horizontalCenter
        width:76
        height:76
        radius: width / 2

        Text{

            anchors.centerIn:parent
            color:"#ffffff"
            font.pixelSize: 30
            text: temperatureControlSlider.value
        }
    }
}
