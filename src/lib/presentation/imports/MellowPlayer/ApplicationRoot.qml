import QtQuick 2.9
import QtWebEngine 1.5

import MellowPlayer 3.0

QtObject {
    id: root

    property Component browserDialogComponent: BrowserDialog {
        // @disable-check M16
        onClosing: destroy();
    }

    function createDialog() {
        return browserDialogComponent.createObject(root);
    }
}
