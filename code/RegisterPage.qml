import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Dialogs 6.5

Page {
    id: registerPage
    anchors.fill: parent
    background: Rectangle { color: "#0f1724" }

    Column {
        anchors.centerIn: parent
        spacing: 16
        width: parent.width * 0.5

        Text {
            text: "Create Account"
            color: "white"
            font.pixelSize: 36
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
        }

        TextField {
            id: username
            placeholderText: "Username"
            color: "black"
            width: parent.width
            background: Rectangle { color: "white"; radius: 6 }
        }

        TextField {
            id: password
            placeholderText: "Password"
            echoMode: TextInput.Password
            color: "black"
            width: parent.width
            background: Rectangle { color: "white"; radius: 6 }
        }

        Row {
            spacing: 12
            width: parent.width

            Button {
                text: "Register"
                width: (parent.width - 12) / 2
                onClicked: {
                    if (username.text === "" || password.text === "") {
                        messageDialog.text = "Please fill in all fields."
                        messageDialog.open()
                        return
                    }

                    var ok = AppBridgeInstance.registerUser(username.text, password.text)
                    if (ok) {
                        messageDialog.text = "Registration successful! Please log in."
                        messageDialog.open()
                        root.gotoLogin()
                    } else {
                        messageDialog.text = "Registration failed: username already exists."
                        messageDialog.open()
                    }
                }
            }

            Button {
                text: "Back"
                width: (parent.width - 12) / 2
                onClicked: root.gotoLogin()
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
