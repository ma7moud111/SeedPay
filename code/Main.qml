import QtQuick 6.5
import QtQuick.Controls 6.5

ApplicationWindow {
    id: root
    width: 960
    height: 640
    visibility: "Maximized"
    visible: true
    title: "SeedPay"
    color: "#0f1724"

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: Component { SplashScreen { anchors.fill: undefined } }
    }

    // --- Navigation helper functions ---
    function gotoLogin()     { stackView.replace(loginPage) }
    function gotoRegister()  { stackView.replace(registerPage) }
    function gotoDashboard() { stackView.replace(dashboardPage) }
    function gotoSplash()    { stackView.replace(splashPage) }

    // --- Predeclared components ---
    Component { id: splashPage;     SplashScreen {} }
    Component { id: loginPage;      LoginPage {} }
    Component { id: registerPage;   RegisterPage {} }
    Component { id: dashboardPage;  DashboardPage {} }
}
