import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    width: parent.width
    height: 48
    color: index % 2 == 0 ? "#142731" : "#17313a"
    Text { text: model.display; anchors.verticalCenter: parent.verticalCenter; color: "white"; anchors.left: parent.left; anchors.leftMargin: 8 }
}
