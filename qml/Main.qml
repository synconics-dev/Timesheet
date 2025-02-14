/*
 * Copyright (C) 2025  Girish Mohan
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * tsnocpp is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/* Main Dashboard Screen
*  This screen wouold show a piechart of the time spent on each of the four 
*  quadrants. In the second half of the screen, the grid shows the tasks for 
*  the next six days 
*/

import QtQuick 2.0
import Lomiri.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import Qt.labs.settings 1.0
import QtCharts 2.0
import QtQuick.Layouts 1.11
import "../models/Main.js" as Model
import "../models/DbInit.js" as DbInit
import "../models/DemoData.js" as DemoData


MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'tsnocpp.girish'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)
    // width: Screen.width
    // height: Screen.height

    function formatTime(seconds) {
        var hours = Math.floor(seconds / 3600);  
        var minutes = Math.floor((seconds % 3600) / 60);  
        var secs = seconds % 60; 

        return (hours < 10 ? "0" + hours : hours) + ":" +  
            (minutes < 10 ? "0" + minutes : minutes) + ":" +
            (secs < 10 ? "0" + secs : secs);
        }

    function isDesktop() {
        if(Screen.width > 1300 ){
            if(Screen.width > 2000 && Screen.height < 1300){
                return false;
            }else{
                return true;
            }
        }else{
            return false;
        }
    }
    function phoneLarg(){
        if(!isDesktop()){
            if(Screen.width > 1300){
                return true;
            }else{
                return false;
            }
        }
        return false;
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: dashboard

        Component {
            id: timesheet
            Timesheet {
                isBottomEdge: false
            }
        }

        Component {
            id: dashboard
            Item {
                Page {
                    anchors.fill: parent

                    PageHeader {
                        id: header
                        leadingActionBar.actions: [
                            Action {
                                iconName: "navigation-menu"
                                onTriggered: {
                                    navigationDialog.open()
                                }
                            }
                        ]
                        title: i18n.tr('TimeSheet')
                    }

                    NavigationDialog {
                        id: navigationDialog
                    }

                    Rectangle {
                        id: rect1
                        width: units.gu(45)
                        height: units.gu(40)
                        border.color: "black"
                        border.width: 1
                        anchors.top: header.bottom
                        anchors.topMargin: 50

                        ChartView {
                            id: chart
                            title: "Time Spent this week"
                            x: -10
                            y: -10
                            margins { top: 50; bottom: 0; left: 0; right: 0 }
                            backgroundRoundness: 0
                            anchors { fill: parent; margins: 0; top: header.bottom }
                            antialiasing: true
                            legend.visible: false
             
                            property variant othersSlice: 0
                            property variant timecat: []
                            

                            PieSeries {
                                id: pieSeries
                                size: 0.7
                                PieSlice { label: "Important, Urgent"; value: chart.timecat[0] } //  Data from Js
                                PieSlice { label: "Important, Not Urgent"; value: chart.timecat[1] }
                                PieSlice { label: "Not Important, Urgent"; value: chart.timecat[2]}
                                PieSlice { label: "Not Important, Not Urgent"; value: chart.timecat[3]}
                            }
                            Component.onCompleted: {
                                // You can also manipulate slices dynamically, like append a slice or set a slice exploded
                                //othersSlice = pieSeries.append("Others", 42.0);
                                //Any animation or labels to be addeed header

                              pieSeries.find("Important, Urgent").exploded = true;
                            }
                        }
                        Component.onCompleted: {
                            DbInit.initializeDatabase();
                            DemoData.record_demo_data();
                            // var quadrant_data = Model.get_quadrant_difference();
                            var quadrant_data = Model.get_quadrant_current_week()
                            console.log('\n\n quadrant_data', quadrant_data)
                            chart.timecat = quadrant_data;
                        }
                    } 
                    Rectangle {
                        id: rect2
                        anchors.top: rect1.bottom
                        width: units.gu(45)
                        height: units.gu(35)
             

                        GridLayout
                        {
                            columns: 3
                            rows: 2
                            anchors.centerIn: parent

                            Rectangle //Day 1
                            {
                                id:myRect_1
                                Layout.preferredWidth: units.gu(12)
                                Layout.preferredHeight: units.gu(12)
                                border.color: "black"
                                border.width: 1
                                
                                Text {
                                    id: myText_11
                                    property var mystring1: Date().toString()
                                    property var mystring2: mystring1.slice(8,10)
                                    text: mystring2
                                    anchors.top: parent.top
                                }
                                Text {
                                    id: myText_1
                                    text: qsTr("No Tasks")
                                    anchors.centerIn: parent
                                }
                            }

                            Rectangle //Day 2
                            {
                                id:myRect_2
                                Layout.preferredWidth: units.gu(12)
                                Layout.preferredHeight: units.gu(12)
                                 border.color: "black"
                                border.width: 1

                               Text {
                                    id: myText_21
                                    property var mystring1: Date().toString()
                                    property var mystring2: mystring1.slice(8,10)
                                    text: mystring2*1+1
                                    anchors.top: parent.top
                                }
                                 Text {
                                    id: myText_2
                                    text: qsTr("Meeting")
                                    anchors.centerIn: parent
                                }
                            }

                            Rectangle //Day 3
                            {
                                id:myRect_3
                                Layout.preferredWidth: units.gu(12)
                                Layout.preferredHeight: units.gu(12)
                                border.color: "black"
                                border.width: 1
                                Layout.alignment: Qt.AlignCenter

                               Text {
                                    id: myText_31
                                    property var mystring1: Date().toString()
                                    property var mystring2: mystring1.slice(8,10)
                                    text: mystring2*1+2
                                    anchors.top: parent.top
                                }
                                 Text {
                                    id: myText_3
                                    text: qsTr("Travel")
                                    anchors.centerIn: parent
                                }
                            }

                            Rectangle  //Day 4
                            {
                                id:myRect_4
                                Layout.preferredWidth: units.gu(12)
                                Layout.preferredHeight: units.gu(12)
                                 border.color: "black"
                                border.width: 1
                                Layout.alignment: Qt.AlignCenter

                                Text {
                                    id: myText_41
                                    property var mystring1: Date().toString()
                                    property var mystring2: mystring1.slice(8,10)
                                    text: mystring2*1+3
                                    anchors.top: parent.top
                                }
                                Text {
                                    id: myText_4
                                    text: qsTr("Meeting")
                                    anchors.centerIn: parent
                                }
                            }

                            Rectangle //Day 5
                            {
                                id:myRect_5
                                Layout.preferredWidth: units.gu(12)
                                Layout.preferredHeight: units.gu(12)
                                 border.color: "black"
                                border.width: 1

                               Text {
                                    id: myText_51
                                    property var mystring1: Date().toString()
                                    property var mystring2: mystring1.slice(8,10)
                                    text: mystring2*1+4
                                    anchors.top: parent.top
                                }
                                 Text {
                                    id: myText_5
                                    text: qsTr("Release")
                                    anchors.centerIn: parent
                                }
                            }

                            Rectangle //Day 6
                            {
                                id:myRect_6
                                Layout.preferredWidth: units.gu(12)
                                Layout.preferredHeight: units.gu(12)
                                 border.color: "black"
                                border.width: 1

                               Text {
                                    id: myText_61
                                    property var mystring1: Date().toString()
                                    property var mystring2: mystring1.slice(8,10)
                                    text: mystring2*1+5
                                    anchors.top: parent.top
                                }
                                 Text {
                                    id: myText_6
                                    text: qsTr("No Activity")
                                    anchors.centerIn: parent
                                }
                            }

                        }
                    }     
            /* Splash Screen. We cann add text as well with App name */

                    Rectangle{
                        id: splashrect
                        anchors.fill: parent
                        width: units.gu(45)
                        height: units.gu(75)
                        color: "#ffffff"
                        border.color: "black"
                        border.width: 1
                        Image {
                            id: image
                            anchors.centerIn: parent
                            width: units.gu(45)
                            height: units.gu(40)
                            source: "time_management_logo_4_3.jpg"
                        }
                        Timer {
                            interval: 5000; running: true; repeat: false
                            onTriggered: {
                                splashrect.visible = false
            //                    window.timeout()
                            }
                        }

                    }
                    // Button {
                    //     onClicked: {
                    //         // var component = Qt.createComponent("Timesheet.qml");
                    //         // var window = component.createObject(null);
                    //         // window.show();
                    //         stackView.push(timesheet)
                    //     }
                    // }
    /***************************************/
                    BottomEdge {
                        id: bottomEdge
                        height: units.gu(110)
                        hint.text: "Add Timesheet"
                        contentComponent: Timesheet {
                            isBottomEdge: true
                        }
                    }

                }
            }
        }
    }

}
