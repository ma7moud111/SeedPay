import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Dialogs 6.5

Page {
    id: loginPage
    anchors.fill: parent
    background: Rectangle { color: "#0f1724" }

    Column {
        anchors.centerIn: parent
        spacing: 16
        width: parent.width * 0.5

        Text {
            text: "SeedPay"
            color: "white"
            font.pixelSize: 42
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            font.bold: true
        }

        TextField {
            id: username
            placeholderText: "Username"
            width: parent.width
            color: "black"
            background: Rectangle { color: "white"; radius: 6 }
        }

        TextField {
            id: password
            placeholderText: "Password"
            echoMode: TextInput.Password
            width: parent.width
            color: "black"
            background: Rectangle { color: "white"; radius: 6 }
        }

        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            // Login button
            Rectangle {
                id: loginBtn
                width: 140
                height: 42
                radius: 8
                color: "#00bcd4"

                Text {
                    text: "Login"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: loginBtn.color = "#26c6da"
                    onExited: loginBtn.color = "#00bcd4"
                    onClicked: {
                        var ok = AppBridgeInstance.login(username.text, password.text)
                        if (ok)
                            root.gotoDashboard()
                        else {
                            messageDialog.text = "Login failed: invalid credentials"
                            messageDialog.open()
                        }
                    }
                }
            }

            // Register button
            Rectangle {
                id: registerBtn
                width: 140
                height: 42
                radius: 8
                color: "#1e88e5"

                Text {
                    text: "Register"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: registerBtn.color = "#42a5f5"
                    onExited: registerBtn.color = "#1e88e5"
                    onClicked: root.gotoRegister()
                }
            }
        }

    MessageDialog {
        id: messageDialog
        title: "SeedPay"
        text: ""
        buttons: MessageDialog.Ok
    }
}
}
