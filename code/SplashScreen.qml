import QtQuick 6.5
import QtQuick.Controls 6.5

Page {
    id: splash
    anchors.fill: parent
    background: Rectangle { color: "#0f1724" }

    Image {
        id: logo
        source: "qrc:/qml/images/wallet.png"
        width: 180
        height: 180
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: title.top
        anchors.bottomMargin: 20
        fillMode: Image.PreserveAspectFit
        opacity: title.opacity
    }

    Component.onCompleted: {
        console.log("QML logo test → source:", logo.source)
        console.log("QML logo test → exists:", Qt.resolvedUrl(logo.source))
    }

    Text {
        id: title
        text: "SeedPay"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
        font.pixelSize: 90
        font.bold: true
        opacity: 0.0

        SequentialAnimation on opacity {
            running: true
            loops: 1
            NumberAnimation { from: 0.0; to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
            PauseAnimation { duration: 1000 }
            NumberAnimation { from: 1.0; to: 0.0; duration: 800; easing.type: Easing.InOutQuad }
            onStopped: root.gotoLogin()
        }
    }

    Text {
        text: "Secure Digital Wallet"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: title.bottom
        anchors.topMargin: 12
        color: "#bbbbbb"
        font.pixelSize: 22
        opacity: title.opacity
    }

    Text {
        text: "Created by: Mahmoud Sayed"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 70
        color: "#aaaaaa"
        font.pixelSize: 25
        opacity: title.opacity
    }

}
