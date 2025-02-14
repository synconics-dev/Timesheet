/*
 * Copyright (C) 2024  Synconics Technologies Pvt. Ltd.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * odooprojecttimesheet is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */ 

import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.Pickers 1.0
import QtQuick.Window 2.2
import "../models/Timesheet.js" as Model
import "../models/DbInit.js" as DbInit


Page {
    visible: true
    width: units.gu(50)
    height: units.gu(110)
    title: "Add Timesheet"

    property bool isBottomEdge: false
    property var taskssmartBtn: null
    property int elapsedTime: 0
    property int selectedquadrantId: 4
    property int selectedProjectId: 0
    property int selectedTaskId: 0 
    property bool running: false
    property bool isManualTime: false
    property var currentTime: false
    property int storedElapsedTime: 0
    property bool workpersonaSwitchState: false
    property bool timestart: false 
    property int idstarttime: 0

    Timer {
        id: stopwatchTimer
        interval: 1000  
        repeat: true
        onTriggered: {
            elapsedTime += 1
        }
    }

    function formatTime(seconds) {
        var hours = Math.floor(seconds / 3600);  
        var minutes = Math.floor((seconds % 3600) / 60);  
        var secs = seconds % 60;

        return (hours < 10 ? "0" + hours : hours) + ":" +  
            (minutes < 10 ? "0" + minutes : minutes) + ":" +
            (secs < 10 ? "0" + secs : secs);
    }

    function isDesktop() {
        if (Screen.width > 1300) {
            if (Screen.width > 2000 && Screen.height < 1300) {
                return false;
            } else {
                return true;
            }
        } else {
            return false;
        }
    }

    function phoneLarg() {
        if (!isDesktop()) {
            if (Screen.width > 1300) {
                return true;
            } else {
                return false;
            }
        }
        return false;
    }

    function prepare_project_list() {
        var projects = Model.fetch_projects(false, workpersonaSwitchState)
        for (var project = 0; project < projects.length; project++) {
            projectModel.append({'id': projects[project].id, 'name': projects[project].name})
        }
    }

    function prepare_task_list(project_id) {
        var tasks = Model.fetch_tasks_list(project_id, false, workpersonaSwitchState)
        taskModel.clear();
        selectedTaskId = 0;
        task_field.text = "Select Task";
        for (var task = 0; task < tasks.length; task++) {
            taskModel.append({'id': tasks[task].id, 'name': tasks[task].name})
        }
    }

    function save_timesheet() {
        var timesheet_data = {
            'dateTime': date_field.text,
            'project': selectedProjectId,
            'task': selectedTaskId,
            'description': description_field.text,
            'manualSpentHours': spent_hours_manual_field.text,
            'spenthours': spent_hours_auto_field.text,
            'isManualTimeRecord': isManualTime
        }
        Model.create_timesheet(timesheet_data)
    }

    ListModel {
        id: projectModel
    }

    ListModel {
        id: taskModel
    }

    ListModel { 
     id: quadrantsListModel
        ListElement { itemId: 1; name: "Urgent and important tasks" }
        ListElement { itemId: 2; name: "Not urgent, yet important tasks" } 
        ListElement { itemId: 3; name: "Important but not urgent tasks" }
        ListElement { itemId: 4; name: "Not urgent and not important tasks" }
    }

    PageHeader {
        id: pageHeader
        leadingActionBar.actions: [
            Action {
                iconName: "down"
                visible: isBottomEdge && isBottomEdge.opened
                onTriggered: {
                    bottomEdge.collapse();
                }
            },
            Action {
                iconName: "navigation-menu"
                visible: !isBottomEdge
                onTriggered: {
                    navigationDialog.open();
                }
            }
        ]
        title: "Add Timesheet"
        trailingActionBar.actions: [
            Action {
                iconName: "ok"
                onTriggered: {
                    save_timesheet();
                    saveMessage.visible = true;
                    saveMessageTimer.start();
                }
            }
        ]
    }

    NavigationDialog {
        id: navigationDialog
    }

    Label {
        id: saveMessage
        text: "Saved Successfully!"
        color: "green"
        visible: false
        anchors.top: pageHeader.bottom
        anchors.margins: 60
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Timer {
        id: saveMessageTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            saveMessage.visible = false;
            bottomEdge.collapse();
        }
    }

    Rectangle {
        width: Screen.desktopAvailableWidth < units.gu(130) ? units.gu(45) : units.gu(130)
        height: parent.height
        anchors.top: pageHeader.bottom 
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#ffffff"
        anchors.margins: 100
        id: list_id
        Flickable {
            id: flickableContent
            anchors.fill: parent
            // height: date_selection.height
            height: parent.height - pageHeader.height
            anchors.top: pageHeader.bottom
            contentWidth: parent.width
            contentHeight: units.gu(130)
            clip: true
            flickableDirection: Flickable.VerticalFlick

            Rectangle {
                id: date_selection
                anchors.left: parent.left
                anchors.right: parent.right

                Label {
                    id: date_label
                    text: "Date"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 50
                }
                DatePicker {
                    id: date_field
                    anchors.top: date_label.bottom
                    width: Screen.desktopAvailableWidth < units.gu(250) ? units.gu(30) : units.gu(60)
                    height: units.gu(10)
                    anchors.horizontalCenter: parent.horizontalCenter
                    minimum: {
                        var d = new Date();
                        d.setFullYear(d.getFullYear() - 1);
                        return d;
                    }
                    maximum: Date.prototype.getInvalidDate.call()
                }

                Label {
                    id: project_label
                    text: "Project"
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: date_field.bottom
                }

                ComboButton {
                    id: project_field
                    text: "Select Project"
                    width: Screen.desktopAvailableWidth < units.gu(250) ? units.gu(30) : units.gu(60)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: project_label.bottom
                    ListView {
                        id: list

                        model: projectModel
                        delegate: ItemDelegate {
                            id: projectInfo 
                            width: parent.width
                            text: model.name
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    project_field.text = model.name
                                    selectedProjectId = model.id
                                    prepare_task_list(selectedProjectId)
                                }
                            }
                        }
                    }
                }

                Label {
                    id: task_label
                    text: "Task"
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: project_field.bottom
                }
                ComboButton {
                    id: task_field
                    text: "Select Task"
                    width: Screen.desktopAvailableWidth < units.gu(250) ? units.gu(30) : units.gu(60)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: task_label.bottom
                    ListView {
                        id: task_list
                        // width: 18

                        model: taskModel
                        delegate: ItemDelegate {
                            id: taskInfo
                            width: parent.width 
                            text: model.name
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    task_field.text = model.name
                                    selectedTaskId = model.id
                                }
                            }
                        }
                    }
                }

                Label {
                    id: description_label
                    text: "Description"
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: task_field.bottom
                }
                TextField {
                    id: description_field
                    width: Screen.desktopAvailableWidth < units.gu(250) ? units.gu(30) : units.gu(60)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: description_label.bottom
                }

                Label {
                    id: spent_hours_label
                    text: "Spent Hours"
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: description_field.bottom
                }

                TextField {
                    id: spent_hours_auto_field
                    width: Screen.desktopAvailableWidth < units.gu(250) ? units.gu(30) : units.gu(60)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: spent_hours_label.bottom
                    text: formatTime(elapsedTime)
                    readOnly: true
                    visible: !isManualTime
                    validator: RegExpValidator { regExp: /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/ }
                }

                TextField {
                    id: spent_hours_manual_field
                    width: Screen.desktopAvailableWidth < units.gu(250) ? units.gu(30) : units.gu(60)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: spent_hours_label.bottom
                    text: formatTime(elapsedTime)
                    visible: isManualTime
                    validator: RegExpValidator { regExp: /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/ }
                }

                Rectangle {
                    id: buttons
                    anchors.top: spent_hours_manual_field.bottom
                    width: Screen.desktopAvailableWidth < units.gu(250) ? units.gu(18) : units.gu(60)
                    height: units.gu(5)
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    Button {
                        id: start_stop_id
                        width: units.gu(5)   // Set explicit button size
                        height: units.gu(5)

                        background: Rectangle {
                            color: "transparent"  // Remove the grey background
                        }

                        contentItem: Item {
                            width: parent.width
                            height: parent.height

                            Icon {
                                anchors.centerIn: parent
                                name: running ? "media-playback-pause" : "media-playback-start"
                                width: units.gu(5)  // Adjust icon size
                                height: units.gu(5)
                            }
                        }

                        visible: !isManualTime

                        onClicked: {
                            if (running) {
                                currentTime = false;
                                storedElapsedTime = elapsedTime;
                                stopwatchTimer.stop();
                            } else {
                                currentTime = new Date()
                                
                                stopwatchTimer.start();
                            }
                            running = !running
                            if (taskssmartBtn != null) {
                                timestart = true
                                idstarttime = selectedTaskId
                            }
                        }
                    }

                    Button {
                        anchors.left: start_stop_id.right
                        anchors.leftMargin: 30
                        id: reset_button
                        width: units.gu(5)   // Set explicit button size
                        height: units.gu(5)

                        background: Rectangle {
                            color: "transparent"  // Remove the grey background
                        }


                        contentItem: Item {
                            width: parent.width
                            height: parent.height

                            Icon {
                                anchors.centerIn: parent
                                name: "reset"
                                width: units.gu(5)  // Adjust icon size
                                height: units.gu(5)
                            }
                        }
                        visible: isManualTime? false : true

                        text: "Reset"
                        onClicked: {
                            currentTime = false;
                            stopwatchTimer.stop();
                            elapsedTime = 0;
                            storedElapsedTime = 0;
                            running = false;
                            if (timestart) {
                                timestart = false
                                idstarttime = 0
                            }
                        }
                    }
                    Button {
                        anchors.left: reset_button.right
                        anchors.leftMargin: 30
                        width: units.gu(5)   // Set explicit button size
                        height: units.gu(5)

                        background: Rectangle {
                            color: "transparent"  // Remove the grey background
                        }

                        contentItem: Item {
                            width: parent.width
                            height: parent.height

                            Icon {
                                anchors.centerIn: parent
                                name: isManualTime ? "reset" : "edit"
                                width: units.gu(5)  // Adjust icon size
                                height: units.gu(5)
                            }
                        }


                        text: "Reset"
                        onClicked: {
                            stopwatchTimer.stop();
                            elapsedTime = 0;
                            running = false;
                            storedElapsedTime = 0
                            spent_hours_manual_field.text = ""
                            isManualTime = !isManualTime
                            if (timestart) {
                                timestart = false
                                idstarttime = 0
                            }
                        }
                    }
                }
                Label {
                    id: quadrant_label
                    text: "Select Priority Quadrant"
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: buttons.bottom
                }
                Rectangle {
                    id: quadrant_selection
                    anchors.top: quadrant_label.bottom
                    Rectangle {
                        id: first_panel_quadrant
                        RadioButton {
                            checked: selectedquadrantId === 1
                            onClicked: selectedquadrantId = 1
                        }
                        Text {
                            text: "Important, Urgent (1)"
                            // font.pixelSize: isDesktop() ? 18 : phoneLarg() ? 30 : 30
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
    }
    
    Component.onCompleted: {
        prepare_project_list()
    }
}
