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
            ListElement { title: "Home"; icon: "home"; }
            ListElement { title: "Timesheet"; icon: "clock"; }
            ListElement { title: "Activities"; icon: "calendar"; }
            ListElement { title: "Tasks"; icon: "view-list-symbolic"; }
            ListElement { title: "Projects"; icon: "folder-symbolic"; }
            ListElement { title: "Settings"; icon: "settings"; }
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
                // anchors.centerIn: parent
                anchors.verticalCenter: parent.verticalCenter
                Rectangle {
                    width: units.gu(1)  // Adds left space
                    height: 1
                    color: "transparent"
                }
                Icon {
                    name: model.icon
                    width: units.gu(3)
                    height: units.gu(3)
                }
                Label {
                    text: model.title
                    font.bold: true
                }
            }
        }
    }
}
