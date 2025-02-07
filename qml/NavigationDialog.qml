import QtQuick 2.0
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Dialog {
    id: navigationDialog
    width: parent.width * 0.75
    height: parent.height
    property alias listView: menuListView

    contentItem: ListView {
        id: menuListView
        anchors.fill: parent
        anchors.topMargin: units.gu(5)
        model: ListModel {
            ListElement { title: "Home"; icon: "view-dashboard"; }
            ListElement { title: "Timesheet"; icon: "clock"; }
            ListElement { title: "Projects"; icon: "folder"; }
            ListElement { title: "Tasks"; icon: "format-list-bulleted"; }
            ListElement { title: "Activities"; icon: "calendar"; }
        }

        delegate: Item {
            width: parent.width
            height: units.gu(6)

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Navigating to:", model.title);
                    navigationDialog.close();

                    if (model.title === "Home") {
                        stackView.push(dashboard);
                    } else if (model.title === "Timesheet") {
                        stackView.push(timesheet);
                    }
                }
            }

            Row {
                spacing: units.gu(2)
                anchors.centerIn: parent
                Label {
                    text: model.title
                    font.bold: true
                }
            }
        }
    }
}
