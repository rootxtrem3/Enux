import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    anchors.fill: parent
    color: "#0f172a"

    Column {
        anchors.centerIn: parent
        width: parent.width * 0.74
        spacing: 18

        Text {
            text: "Enux"
            color: "#f8fafc"
            font.pixelSize: 42
            font.bold: true
        }

        Text {
            text: "A focused educational desktop with GNOME, Hyprland, developer tooling, and a guided installer."
            color: "#cbd5e1"
            wrapMode: Text.WordWrap
            font.pixelSize: 22
        }

        Text {
            text: "Included by default: Firefox, LibreOffice, Docker, Node.js, PostgreSQL, Python, Java, and a modern Wayland-capable desktop stack."
            color: "#94a3b8"
            wrapMode: Text.WordWrap
            font.pixelSize: 17
        }
    }
}
