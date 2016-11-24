
function _imageExists(image_url) {
    var http = new XMLHttpRequest();
    http.open('HEAD', image_url, false);
    http.send();
    return http.status != 404;
}

function _getFilename(url) {
    url = url.substring(0, (url.indexOf("#") == -1) ? url.length : url.indexOf("#"));
    url = url.substring(0, (url.indexOf("?") == -1) ? url.length : url.indexOf("?"));
    url = url.substring(url.lastIndexOf("/") + 1, url.length);
    return url;
}

function _SetIcon(window, tab, url) {
    filename = _getFilename(url);
    filename = filename.substring(0, filename.lastIndexOf('.'));
    if (_imageExists('/images/WindowIcons/Taskbar/' + filename + '.png')) {
        tab.set_imageUrl("/Images/WindowIcons/Taskbar/" + filename + ".png");
        window.set_iconUrl("/Images/WindowIcons/Window/" + filename + ".png")
    } else {
        tab.set_imageUrl("/Images/WindowIcons/Taskbar/Globe.png");
        window.set_iconUrl("/Images/WindowIcons/Window/Globe.png")
    }

}

function _OpenWindow(url, WindowTitle) {
    var oWnd = radopen(url, null);
    oWnd.set_title(WindowTitle);
    oWnd.set_restrictionZoneID("restrictionzone");
    tabStrip.trackChanges();
    var tab = new Telerik.Web.UI.RadTab();
    tab.set_text(WindowTitle);
    tab.set_cssClass("taskbar_tab");
    tab.set_selectedCssClass("taskbar_tab_selected");
    _SetIcon(oWnd, tab, url)
    tabStrip.get_tabs().add(tab);
    tabStrip.commitChanges();
    tab.select();
    return oWnd;
}

function GetRadWindow() {
    var oWindow = null;
    if (window.radWindow)
        oWindow = window.radWindow;
    else if (window.frameElement && window.frameElement.radWindow)
        oWindow = window.frameElement.radWindow;
    return oWindow;
}

function CloseModal(oWnd) {
    if (oWnd.radWindow) {
        setTimeout(function () {
            oWnd.close();
        }, 0);
    }
}
// None : 0,        
// Resize : 1,  
// Minimize : 2, 
// Close : 4,   
// Pin : 8, 
// Maximize : 16, 
// Move: 32, 
// Reload: 64,

function OpenWindowV1(url, WindowTitle) {
    oWnd = _OpenWindow(url, WindowTitle);
    oWnd.set_behaviors(1 + 2 + 4 + 16 + 32);
    oWnd.center();
    oWnd.set_autoSize(true);
    oWnd.show();
    return oWnd
}

function OpenWindowV2(url, WindowTitle, width, height) {
    oWnd = _OpenWindow(url, WindowTitle);
    oWnd.set_behaviors(1 + 2 + 4 + 16 + 32);
    oWnd.moveTo(0, 0);
    oWnd.setSize(width, height);
    oWnd.center();
    oWnd.show();
    return oWnd
}

function OpenWindowMaxWidthV1(url, WindowTitle) {
    oWnd = OpenWindowV1(url, WindowTitle);
    oWnd.set_autoSizeBehaviors(Telerik.Web.UI.WindowAutoSizeBehaviors.Height)
    oWnd.maximize()
    oWnd.moveTo(0, 0);
    oWnd.set_height(300);
    test = test;
    return oWnd
}

function OpenWindowMaxWidthV2(url, WindowTitle,height) {
    oWnd = OpenWindowV2(url, WindowTitle, 100, height);
    oWnd.set_autoSizeBehaviors(Telerik.Web.UI.WindowAutoSizeBehaviors.Height)
    oWnd.set_minWidth(oWnd.get_maxWidth());
    oWnd.set_width(oWnd.get_maxWidth());
    ownd.set_maxWidth(oWnd.get_maxWidth())
    oWnd.moveTo(0, 0);
    return oWnd
}

function OpenDialogV1(url, WindowTitle) {
    oWnd = _OpenWindow(url, WindowTitle);
    oWnd.set_behaviors(4 + 32);
    oWnd.center();
    oWnd.set_autoSize(true);
    oWnd.show();
    return oWnd
}

function OpenDialogV2(url, WindowTitle, width, height) {
    oWnd = _OpenWindow(url, WindowTitle);
    oWnd.set_behaviors(4 + 32);
    oWnd.moveTo(0, 0);
    oWnd.setSize(width, height);
    oWnd.center();
    oWnd.show();
    return oWnd
}