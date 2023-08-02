/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
import QtQuick 2.4
import QtPositioning 5.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0

import QGroundControl 1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.Controls 1.0
import QGroundControl.Palette 1.0
import QGroundControl.Vehicle 1.0
import QGroundControl.Controllers 1.0
import QGroundControl.FactSystem 1.0
import QGroundControl.FactControls 1.0

/// Flir page for controlling a Duo Pro R
Column {
    width: 45 //contentHeight //pageWidth
    spacing: ScreenTools.defaultFontPixelHeight * 0.25

    property bool _recording: false
    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    GridLayout {
        columns: 2
        columnSpacing: ScreenTools.defaultFontPixelWidth * 2
        rowSpacing: ScreenTools.defaultFontPixelHeight
        anchors.horizontalCenter: parent.horizontalCenter

        /*QGCLabel {
            text: qsTr("Camera Mode")
        }
        QGCComboBox {
            //id: displayMode
            model: [qsTr("PIP"), qsTr("IR"), qsTr("RGB")]
            onActivated: {
                _activeVehicle.sendCommand(_activeVehicle, //ID
                                           183, //MAV_CMD
                                           true, //showError
                                           13, //servo instance
                                           index * 500 + 1000) //servo value in us
            }
        }*/

        QGCLabel {
            text: qsTr("photo/Video")
        }
        QGCSwitch {
            id: videoMode
            onCheckedChanged: {
                if (checked) {
                    //Video mode
                    _activeVehicle.sendCommand(_activeVehicle, //ID
                                               183, //MAV_CMD
                                               true, //showError
                                               12, //servo instance
                                               2000) //servo value in us
                } else {
                    //Photo mode & stop recording video
                    _activeVehicle.sendCommand(_activeVehicle, //ID
                                               183, //MAV_CMD
                                               true, //showError
                                               11, //servo instance
                                               1001) //servo value in us
                    _recording = false
                    _activeVehicle.sendCommand(_activeVehicle, //ID
                                               183, //MAV_CMD
                                               true, //showError
                                               12, //servo instance
                                               1000) //servo value in us
                }
            }
        }

        QGCLabel {
            text: qsTr("REC")
        }
        Item {
            anchors.margins: ScreenTools.defaultFontPixelHeight / 2
            height: ScreenTools.defaultFontPixelHeight * 2
            width: height
            Layout.alignment: Qt.AlignHCenter
            Rectangle {
                id: recordBtnBackground
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: height
                radius: height
                color: "red"
                SequentialAnimation on opacity {
                    running: videoMode.checked
                             && _recording //change this to video recording running
                    loops: Animation.Infinite
                    PropertyAnimation {
                        to: 0.5
                        duration: 500
                    }
                    PropertyAnimation {
                        to: 1.0
                        duration: 500
                    }
                }
            }
            QGCColoredImage {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: height * 0.625
                sourceSize.width: width
                source: "/qmlimages/CameraIcon.svg"
                //visible:                    recordBtnBackground.visible
                fillMode: Image.PreserveAspectFit
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: if (videoMode.checked) {
                               if (_recording) {
                                   //stop recording
                                   _activeVehicle.sendCommand(_activeVehicle,
                                                              //ID
                                                              183, //MAV_CMD
                                                              true, //showError
                                                              11,
                                                              //servo instance
                                                              1000) //servo value in us
                                   _recording = false
                               } else {
                                   //start recording
                                   _activeVehicle.sendCommand(_activeVehicle,
                                                              //ID
                                                              183, //MAV_CMD
                                                              true, //showError
                                                              11,
                                                              //servo instance
                                                              2000) //servo value in us
                                   _recording = true
                               }
                           } else {
                               //take photo
                               //_activeVehicle.sendCommand(_activeVehicle,203,true,0,0,0,0,1,0,0);
                               _activeVehicle.sendCommand(_activeVehicle, //ID
                                                          184, //repeat servo
                                                          true, //showError
                                                          11, //servo instance
                                                          2000,
                                                          //servo value in us
                                                          1, //count
                                                          1) //time
                           }
            }
        }

    /*    QGCLabel {
            text: qsTr("Gimbal °")
        }
        QGCButton {
            text: qsTr("Zentr.")
            onClicked: {
                _activeVehicle.sendCommand(_activeVehicle, //ID
                                           184, //repeat servo
                                           true, //showError
                                           7, //servo instance
                                           2100, //servo value in us
                                           1, //count
                                           4) //time
            }
        }*/
    }
    /*
    QGCButton {
        //anchors.horizontalCenter: parent.horizontalCenter
        //anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.top:    parent.top
        //anchors.bottom: parent.bottom
        //id:             _root
        text: qsTr("Gimbal Camera")
        onClicked: {
            displayText.text = "Button Clicked"
            _activeVehicle.sendCommand(1,//_activeVehicle, //ID
                                       184, //repeat servo
                                       true, //showError
                                       11, //servo instance
                                       2100, //servo value in us
                                       1, //count
                                       4) //time
        }

    }*/
    GridLayout {
        columns: 4
        columnSpacing: ScreenTools.defaultFontPixelWidth*2
        ///
        rowSpacing: ScreenTools.defaultFontPixelHeight
        anchors.horizontalCenter: parent.horizontalCenter

        QGCLabel {
            text: qsTr("xOut")
            font.pixelSize: 30
        }
        QGCComboBox {
            id: joyXAxis
            implicitWidth:  ScreenTools.implicitComboBoxWidth*0.6
            implicitHeight: ScreenTools.implicitComboBoxHeight*0.6
            font.pixelSize: 30
            //spacing:        ScreenTools.defaultFontPixelWidth*0.5
            model: [qsTr("0"), qsTr("1"), qsTr("2"), qsTr("3"),qsTr("4"), qsTr("5"), qsTr("6"), qsTr("7"),qsTr("8"), qsTr("9"), qsTr("10")]
            property real   joyX: 6
            //onActivated: joyXAxis=5
            onCurrentIndexChanged: {
                //displayText.text = "index left Changed"
                joyX=currentIndex
            }
        }
        QGCLabel {
            text: qsTr("yOut")
            font.pixelSize: 30
        }
        QGCComboBox {
            id: joyYAxis
            implicitWidth:  ScreenTools.implicitComboBoxWidth*0.6
            implicitHeight: ScreenTools.implicitComboBoxHeight*0.6
            font.pixelSize: 30
            model: [qsTr("0"), qsTr("1"), qsTr("2"), qsTr("3"),qsTr("4"), qsTr("5"), qsTr("6"), qsTr("7"),qsTr("8"), qsTr("9"), qsTr("10")]
            property real   joyY: 6
            onCurrentIndexChanged: {
                //displayText.text = "index right Changed"
                joyY=currentIndex
            }
        }
    }
    JoystickThumbPad {
        id:                     leftStick
        anchors.leftMargin:     xPositionDelta
        anchors.bottomMargin:   -yPositionDelta
        //anchors.left:           parent.left
        //anchors.bottom:         parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width:                  parent.height*0.3
        height:                 parent.height*0.3
        yAxisPositiveRangeOnly: _activeVehicle && !_activeVehicle.rover
        yAxisReCenter:          autoCenterThrottle
        property real   pwmxAxis:               1500
        //property real   outxAxis:               6
        property real   pwmyAxis:               1500
        //property real   xdir:               xAxis
        onXAxisChanged: {
            //displayText.text = "X Changed"
            if (Math.abs(xAxis) > 0.1) {
                pwmxAxis = 1500 + xAxis * 500 // Transform the X-axis value to a PWM value (adjust multiplier as needed)
            }
            else {
                pwmxAxis = 1500
            }
            _activeVehicle.sendCommand(1,//_activeVehicle, //ID
                                       183, //repeat servo
                                       true, //showError
                                       joyXAxis.joyX,//11, //servo instance
                                       pwmxAxis, //servo value in us
                                       ) //time

        }
        onYAxisChanged: {
            //displayText.text = "Y Changed"
            if (Math.abs(yAxis) > 0.1) {
                pwmyAxis = 1500 + yAxis * 500 // Transform the X-axis value to a PWM value (adjust multiplier as needed)
            }
            else {
                pwmyAxis = 1500
            }
            _activeVehicle.sendCommand(1,//_activeVehicle, //ID
                                       183, //repeat servo
                                       true, //showError
                                       joyYAxis.joyY,//11, //servo instance
                                       pwmyAxis, //servo value in us
                                       ) //time

        }

    }

    //Column {
    //    QGCLabel { displayText.text : xAxis }
        //QGCLabel { displayText.text = yAxis }
    //}
    Text {
        id: displayText
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 30
        font.bold: true
        color: "black"
        text: "pwmX= " +  leftStick.pwmxAxis.toFixed(2)  + "// Out of X Axis= " +joyXAxis.joyX + " \npwmY= " +  leftStick.pwmyAxis.toFixed(2) + "// Out of Y Axis = " +joyYAxis.joyY
    }
}
