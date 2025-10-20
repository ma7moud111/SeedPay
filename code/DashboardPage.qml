import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Dialogs 6.5

Page {
    id: dashboardPage
    anchors.fill: parent
    background: Rectangle { color: "#0f1724" }

    // --- Main vertical layout ---
    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 40
        anchors.horizontalCenter: parent.horizontalCenter

        // --- Header card: Username + Balance ---
        Rectangle {
            id: headerCard
            width: parent.width * 0.9
            height: 130
            radius: 16
            color: "#1e293b"
            border.color: "#334155"
            Column {
                anchors.centerIn: parent
                spacing: 6

                Text {
                    id: userLabel
                    text: "Welcome, " + AppBridgeInstance.currentUser()
                    color: "#00bcd4"
                    font.pixelSize: 28
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    id: balanceLabel
                    text: "Balance: " + AppBridgeInstance.getBalance().toFixed(2) + " EGP"
                    color: "white"
                    font.pixelSize: 26
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // --- Action buttons grid ---
        GridLayout {
            id: actions
            columns: 2
            rowSpacing: 20
            columnSpacing: 30
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: [
                       { text: "Deposit", action: function() {
                           openAmountDialog("Deposit Amount", function(a) {
                               AppBridgeInstance.deposit(a);
                               updateDashboard();
                           })
                       } },
                       { text: "Withdraw", action: function() {
                           openAmountDialog("Withdraw Amount", function(a) {
                               AppBridgeInstance.withdraw(a);
                               updateDashboard();
                           })
                       } },
                       { text: "Pay Bill", action: openBillTypeDialog },
                       { text: "Send Money", action: function() {
                           openSendMoneyDialog();
                       } },
                       { text: "View Balance", action: function() {
                           balanceDialog.balanceValue = AppBridgeInstance.getBalance();
                           balanceDialog.open();
                       } }
                ]

                delegate: Rectangle {
                    width: 200
                    height: 80
                    radius: 10
                    color: "#1e293b"
                    border.color: "#334155"
                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = "#263445"
                        onExited: parent.color = "#1e293b"
                        onClicked: modelData.action()
                    }

                    Text {
                        text: modelData.text
                        anchors.centerIn: parent
                        color: "white"
                        font.pixelSize: 18
                        font.bold: true
                    }
                }
            }
        }

        // --- Transaction list card ---
        Rectangle {
            width: parent.width * 0.9
            height: parent.height * 0.35
            radius: 12
            color: "#1e293b"
            border.color: "#334155"

            Column {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8

                Text {
                    text: "Recent Transactions"
                    color: "#00bcd4"
                    font.pixelSize: 20
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                ScrollView {
                    anchors.fill: parent
                    anchors.topMargin: 30
                    ListView {
                        id: txList
                        width: parent.width
                        height: parent.height
                        clip: true
                        model: ListModel {}

                        delegate: Rectangle {
                            width: parent.width
                            height: 42
                            radius: 6
                            color: index % 2 === 0 ? "#142731" : "#17313a"
                            border.color: "#1e293b"

                            Text {
                                id: txText
                                text: model.display
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                color: "white"
                                font.pixelSize: 15
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: parent.color = "#1f3b47"
                                onExited: parent.color = index % 2 === 0 ? "#142731" : "#17313a"
                                onClicked: {
                                    // Example format: "Sun Oct 19 11:13:19 2025 | Deposit | 20000 EGP | Deposit transaction"
                                    var parts = model.display.split(" | ")
                                    transactionDetailDialog.txDate = parts.length > 0 ? parts[0] : "N/A"
                                    transactionDetailDialog.txType = parts.length > 1 ? parts[1] : "Unknown"
                                    transactionDetailDialog.txAmount = parts.length > 2 ? parts[2] : "N/A"
                                    transactionDetailDialog.txDescription = parts.length > 3 ? parts[3] : "No description"
                                    transactionDetailDialog.open()
                                }

                            }
                        }
                    }
                }
            }
        }

        // --- Bottom controls row ---
        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            // Logout button (teal)
            Rectangle {
                id: logoutBtn
                width: 140
                height: 42
                radius: 8
                color: "#00bcd4"

                Text {
                    text: "Logout"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: logoutBtn.color = "#26c6da"
                    onExited: logoutBtn.color = "#00bcd4"
                    onClicked: root.gotoLogin()
                }
            }

            // Quit button (red)
            Rectangle {
                id: quitBtn
                width: 140
                height: 42
                radius: 8
                color: "#d32f2f"

                Text {
                    text: "Quit"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: quitBtn.color = "#ef5350"
                    onExited: quitBtn.color = "#d32f2f"
                    onClicked: quitConfirmDialog.open()
                }
            }
        }
    }

    // --- Dialogs ---
    MessageDialog {
        id: messageDialog
        title: "SeedPay"
        buttons: MessageDialog.Ok
    }

    MessageDialog {
        id: quitConfirmDialog
        title: "Confirm Exit"
        text: "Are you sure you want to quit?"
        buttons: MessageDialog.Yes | MessageDialog.No
        onButtonClicked: function(button, role) {
            if (button === MessageDialog.Yes) Qt.quit()
        }
    }

    // --- Fixed and Scoped Enter Amount Dialog ---
    Dialog {
        id: amountDialog
        title: ""
        modal: true
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        width: 420
        height: 280
        background: Rectangle {
            color: "#1e293b"
            radius: 12
            border.color: "#334155"
        }

        // --- Custom properties ---
        property string dialogTitle: ""
        property var confirmHandler: null

        contentItem: Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            // --- Title ---
            Text {
                id: amountTitle
                text: amountDialog.dialogTitle
                color: "#00bcd4"
                font.pixelSize: 22
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // --- Input Field ---
            Rectangle {
                width: parent.width * 0.8
                height: 48
                radius: 8
                color: "white"
                border.color: amountField.activeFocus ? "#00bcd4" : "#cccccc"
                anchors.horizontalCenter: parent.horizontalCenter

                TextField {
                    id: amountField
                    anchors.fill: parent
                    anchors.margins: 6
                    text: "100"
                    color: "black"
                    font.pixelSize: 18
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    placeholderText: "Enter amount"
                    placeholderTextColor: "#888"
                    background: null
                }
            }

            // --- Buttons ---
            Row {
                spacing: 20
                anchors.horizontalCenter: parent.horizontalCenter

                // Confirm
                Rectangle {
                    id: okBtn
                    width: 120; height: 40
                    radius: 8
                    color: "#00bcd4"
                    Text {
                        text: "Confirm"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 16
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: okBtn.color = "#26c6da"
                        onExited: okBtn.color = "#00bcd4"
                        onClicked: {
                            var value = parseFloat(amountField.text)
                            if (!isNaN(value) && amountDialog.confirmHandler) {
                                amountDialog.close()
                                amountDialog.confirmHandler(value) // Scoped reference
                            } else {
                                console.log("⚠️ Invalid amount or missing handler")
                            }
                        }
                    }
                }

                // Cancel
                Rectangle {
                    id: cancelBtn
                    width: 120; height: 40
                    radius: 8
                    color: "#d32f2f"
                    Text {
                        text: "Cancel"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 16
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: cancelBtn.color = "#ef5350"
                        onExited: cancelBtn.color = "#d32f2f"
                        onClicked: amountDialog.close()
                    }
                }
            }
        }
    }


    // --- Beautiful Bill Type Selection Dialog ---
    Dialog {
        id: billTypeDialog
        title: ""
        modal: true
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        width: 420
        height: 340
        background: Rectangle {
            color: "#1e293b"
            radius: 12
            border.color: "#334155"
        }

        contentItem: Column {
            spacing: 20
            anchors.fill: parent
            anchors.margins: 20

            Text {
                text: "Select Bill Type"
                color: "#00bcd4"
                font.pixelSize: 22
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            GridLayout {
                id: billGrid
                columns: 2
                rowSpacing: 20
                columnSpacing: 20
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: [
                        { name: "Electricity", color: "#ffb300", icon: "💡" },
                        { name: "Water",       color: "#2196f3", icon: "💧" },
                        { name: "Gas",         color: "#ff7043", icon: "🔥" },
                        { name: "Internet",    color: "#9c27b0", icon: "🌐" }
                    ]

                    delegate: Rectangle {
                        width: 160
                        height: 100
                        radius: 12
                        color: "#0f1724"
                        border.color: "#334155"
                        Behavior on color { ColorAnimation { duration: 120 } }

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                text: modelData.icon
                                font.pixelSize: 26
                                horizontalAlignment: Text.AlignHCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: modelData.name
                                color: "white"
                                font.pixelSize: 18
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = Qt.lighter("#1e293b", 1.3)
                            onExited: parent.color = "#0f1724"
                            onClicked: payBillType(modelData.name)
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#334155"
            }

            Row {
                spacing: 16
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: 100; height: 36; radius: 8; color: "#d32f2f"
                    Text { text: "Cancel"; anchors.centerIn: parent; color: "white"; font.bold: true }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = "#ef5350"
                        onExited: parent.color = "#d32f2f"
                        onClicked: billTypeDialog.close()
                    }
                }
            }
        }
    }

    // --- Modern View Balance Dialog ---
    Dialog {
        id: balanceDialog
        title: ""
        modal: true
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        width: 420
        height: 260
        property double balanceValue: 0

        background: Rectangle {
            color: "#1e293b"
            radius: 12
            border.color: "#334155"
            border.width: 1
        }

        contentItem: Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 20

            // --- Title ---
            Text {
                text: "Your Wallet Balance"
                color: "#00bcd4"
                font.pixelSize: 22
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // --- Balance display area ---
            Rectangle {
                width: parent.width
                height: 100
                radius: 12
                color: "#0f1724"
                border.color: "#00bcd4"
                border.width: 1.5
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: balanceDialog.balanceValue.toFixed(2) + " EGP"
                    color: "white"
                    font.pixelSize: 34
                    font.bold: true
                    anchors.centerIn: parent
                }
            }

            // --- Close button ---
            Rectangle {
                id: closeBtn
                width: 120
                height: 40
                radius: 8
                color: "#00bcd4"
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: "Close"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: closeBtn.color = "#26c6da"
                    onExited: closeBtn.color = "#00bcd4"
                    onClicked: balanceDialog.close()
                }
            }
        }

        // --- Smooth fade-in and scale animation ---
        enter: Transition {
            NumberAnimation { properties: "opacity, scale"; from: 0.8; to: 1.0; duration: 200; easing.type: Easing.OutQuad }
        }
        exit: Transition {
            NumberAnimation { properties: "opacity, scale"; from: 1.0; to: 0.8; duration: 150; easing.type: Easing.InQuad }
        }
    }


    // --- Transaction Detail Dialog ---
    Dialog {
        id: transactionDetailDialog
        title: ""
        modal: true
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        width: 460
        height: 340

        property string txType: ""
        property string txAmount: ""
        property string txDate: ""
        property string txDescription: ""

        background: Rectangle {
            color: "#1e293b"
            radius: 12
            border.color: "#334155"
            border.width: 1
        }

        contentItem: Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 20

            Text {
                text: "Transaction Details"
                color: "#00bcd4"
                font.pixelSize: 22
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Column {
                spacing: 12
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.9

                Row {
                    spacing: 8
                    Text { text: "Date:"; color: "#9ca3af"; font.pixelSize: 17; width: 100 }
                    Text { text: transactionDetailDialog.txDate; color: "white"; font.pixelSize: 17 }
                }

                Row {
                    spacing: 8
                    Text { text: "Type:"; color: "#9ca3af"; font.pixelSize: 17; width: 100 }
                    Text {
                        text: transactionDetailDialog.txType
                        color: transactionDetailDialog.txType === "Deposit" ? "#4caf50"
                               : transactionDetailDialog.txType === "Withdraw" ? "#ef5350"
                               : "#ffa726"
                        font.pixelSize: 17
                        font.bold: true
                    }
                }

                Row {
                    spacing: 8
                    Text { text: "Amount:"; color: "#9ca3af"; font.pixelSize: 17; width: 100 }
                    Text { text: transactionDetailDialog.txAmount; color: "white"; font.pixelSize: 17 }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: "#334155"
                }

                Column {
                    spacing: 4
                    Text { text: "Description:"; color: "#9ca3af"; font.pixelSize: 17 }
                    Text {
                        text: transactionDetailDialog.txDescription
                        color: "white"
                        font.pixelSize: 16
                        wrapMode: Text.Wrap
                        width: parent.width
                    }
                }
            }

            Rectangle {
                id: closeTxBtn
                width: 120
                height: 40
                radius: 8
                color: "#00bcd4"
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: "Close"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: closeTxBtn.color = "#26c6da"
                    onExited: closeTxBtn.color = "#00bcd4"
                    onClicked: transactionDetailDialog.close()
                }
            }
        }

        enter: Transition {
            NumberAnimation { properties: "opacity, scale"; from: 0.8; to: 1.0; duration: 200; easing.type: Easing.OutQuad }
        }
        exit: Transition {
            NumberAnimation { properties: "opacity, scale"; from: 1.0; to: 0.8; duration: 150; easing.type: Easing.InQuad }
        }
    }


    Dialog {
        id: sendMoneyDialog
        title: "Send Money"
        modal: true
        width: 420
        height: 260
        background: Rectangle {
            color: "#1e293b"
            radius: 12
        }

        contentItem: Column {
            spacing: 16
            anchors.centerIn: parent
            width: parent.width * 0.8

            Label {
                text: "Enter recipient username and amount:"
                color: "white"
                font.pixelSize: 17
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }

            TextField {
                id: recipientField
                placeholderText: "Recipient username"
                color: "black"
                background: Rectangle { color: "white"; radius: 6 }
            }

            TextField {
                id: amountFieldSend
                placeholderText: "Amount"
                color: "black"
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                background: Rectangle { color: "white"; radius: 6 }
            }

            Row {
                spacing: 16
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: "Send"
                    background: Rectangle { color: "#00bcd4"; radius: 6 }
                    contentItem: Text { text: parent.text; color: "white"; anchors.centerIn: parent }
                    onClicked: {
                        var recipient = recipientField.text.trim()
                        var amount = parseFloat(amountFieldSend.text)
                        if (!recipient || isNaN(amount) || amount <= 0) {
                            messageDialog.text = "Please enter valid recipient and amount."
                            messageDialog.open()
                            return
                        }

                        var ok = AppBridgeInstance.sendMoney(recipient, amount)
                        if (ok) {
                            messageDialog.text = "Successfully sent " + amount.toFixed(2) + " EGP to " + recipient + "."
                            messageDialog.open()
                            updateDashboard()
                            sendMoneyDialog.close()
                        } else {
                            messageDialog.text = "Failed to send money. Check recipient name or balance."
                            messageDialog.open()
                        }
                    }
                }

                Button {
                    text: "Cancel"
                    background: Rectangle { color: "#ef5350"; radius: 6 }
                    contentItem: Text { text: parent.text; color: "white"; anchors.centerIn: parent }
                    onClicked: sendMoneyDialog.close()
                }
            }
        }
    }

    function openSendMoneyDialog() {
        sendMoneyDialog.open()
    }




    // --- Logic helpers ---
    function openAmountDialog(title, handler) {
        amountDialog.dialogTitle = title
        amountDialog.confirmHandler = handler
        amountField.text = "100"
        amountDialog.open()
    }

    function openBillTypeDialog() { billTypeDialog.open() }

    function payBillType(type) {
        billTypeDialog.close()
        openAmountDialog("Enter " + type + " Bill Amount", function(amount) {
            AppBridgeInstance.payBill(amount, type)
            updateDashboard()
        })
    }

    function updateDashboard() {
        // Update balance and transactions
        balanceLabel.text = "Balance: " + AppBridgeInstance.getBalance().toFixed(2) + " EGP"
        updateList()
    }

    function updateList() {
        var items = AppBridgeInstance.getTransactions()
        txList.model.clear()
        for (var i = 0; i < items.length; ++i)
            txList.model.append({ "display": items[i] })
    }

    Component.onCompleted: updateDashboard()
    onVisibleChanged: if (visible) updateDashboard()
}
