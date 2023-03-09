import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.0

Item {
    id: homeScreen

    property var heatSelectDialogHolder: null
    property var time: 0

    function createHeatSelectDialog(){
        if(heatSelectDialogHolder === null){
            var component = Qt.createComponent("HeatSelectDialog.qml");
            heatSelectDialogHolder = component.createObject(homeScreen, {"x":0, "y":0})
            if(heatSelectDialogHolder)
                heatSelectDialogHolder.anchors.fill = homeScreen
            heatSelectDialogHolder.destroyMe.connect(destroyHeatSelectDialog)
        }
    }

    function destroyHeatSelectDialog(){
        if(heatSelectDialogHolder !== null){
            heatSelectDialogHolder.destroy()
            heatSelectDialogHolder = null
        }
    }


    Rectangle{
        id: mainBackgroud
        anchors.fill: parent
        color: "#000000"
    }

    TextInput {
        id: currentTempText
        text: "20"
        font.pixelSize: 100
        width: 40
        color: "#ffffff"
        //anchors.centerIn: parent
        anchors.left: parent.left
        anchors.leftMargin: window.width * .2
        anchors{
            verticalCenter: parent.verticalCenter
        }
        cursorVisible: true
        onTextChanged: {
            systemController.initialTemp = parseInt(currentTempText.text);

        }
    }

    Text{
        id: systemStatus
        anchors{
            verticalCenter: parent.verticalCenter
            top: currentTempText.bottom
            topMargin: 20
            horizontalCenter: currentTempText.horizontalCenter
        }

        text: systemController.systemStatusMessage
        color: "#0E86D4"
        font.pixelSize: 20
    }

    Text{
        id: initialTemp
        anchors{
            //verticalCenter: parent.verticalCenter
            bottom: currentTempText.top
            bottomMargin: 30
            horizontalCenter: currentTempText.horizontalCenter
        }

        text: "Initial Temperature"
        color: "#0E86D4"
        font.pixelSize: 16
    }


    Button{
        id: offButton
        anchors{
            top:temperatureSlider.top
            right:currentTempText.left
            rightMargin:120
        }

        text: "OFF"
        MouseArea{
            anchors.fill:parent
            onClicked: {

                systemController.systemState = 1
                console.log("State: " + systemController.systemState)
                timer1.running = false;
                timer2.running = true;

            }
        }

    }

    Button{
        id: onButton
        anchors{
            bottom: temperatureSlider.bottom
            right: currentTempText.left
            rightMargin: 120
        }

        text: "ON"
        MouseArea{
            anchors.fill:parent
            onClicked: {
                systemController.systemState = 0
                console.log("State: " + systemController.systemState)
                timer2.running = false;
                timer1.running = true;
            }
        }
    }

    Timer {
        id: timer1
        interval: 500; running: false; repeat: true
        onTriggered:
        {
            time = time + 20
            console.log("The timer is: " + time);
            systemController.initialTemp = parseInt(currentTempText.text);
            if(systemController.currentSystemTemperature === systemController.targetTemp)
            {
                systemController.checkSystemStatus();
            }

            if(systemController.tState === 0)
            {
                 // after some time and contamination the boiler takes longer to reach the target temp
                if(time >= 5000)
                {
                    time = time + 100;
                }

                interval = 500
                systemController.increaseTemp(systemController.currentSystemTemperature)
                systemController.initialTemp = parseInt(currentTempText.text);
                series1.append(time, systemController.currentSystemTemperature)
            }

            if(systemController.tState === 1)
            {
                interval = 1500              
                systemController.decreaseTemp(systemController.currentSystemTemperature)
                series1.append(time, systemController.currentSystemTemperature)
                if(systemController.currentSystemTemperature === systemController.targetTemp - 5)
                {
                    systemController.checkSystemStatus();
                }
            }
            console.log(systemController.currentSystemTemperature)
        }
    }


    Timer {
        id: timer2
        interval: 500; running: false; repeat: true
        onTriggered:
        {
            time = time + 20
            systemController.checkSystemStatus();
            if(systemController.tState === 1 && systemController.currentSystemTemperature > systemController.initialTemp)
            {
                systemController.decreaseTemp(systemController.currentSystemTemperature)
                series1.append(time, systemController.currentSystemTemperature)
            }

            console.log(systemController.currentSystemTemperature)
        }
    }

    ChartView {
        title: "Temperature-Time Graph"
        anchors{
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: 20
        }

        width: 600
        height: 400

        legend.visible: false
        antialiasing: true

        ValueAxis {
            id: axisX
            min: 0
            max: 10000
            tickCount: 5
            titleText: "Time (ms)"
        }

        ValueAxis {
            id: axisY1
            min: 0
            max: 100
            titleText: "Temperature (°C)"
        }

        SplineSeries {
            id: series1
            axisX: axisX
            axisY: axisY1
        }
    }

    Text{
        id:targetTemp
        anchors{
            //verticalCenter: parent.verticalCenter
            bottom: temperatureSlider.top
            bottomMargin: 10
            horizontalCenter: temperatureSlider.horizontalCenter
        }

        text: "Target"
        color: "#0E86D4"
        font.pixelSize: 16
    }


    TemperatureControlSlider{
        id: temperatureSlider
        z: 10
        value: systemController.targetTemp
        anchors{
            top: parent.top
            bottom: parent.bottom
            left: currentTempText.right
            leftMargin: 120
            topMargin: 80
            bottomMargin: 80
        }
    }
}
