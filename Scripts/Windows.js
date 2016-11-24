
// copy of function in default.aspx and must exists in both places.
function GetRadWindow() {
    var oWindow = null;
    if (window.radWindow) oWindow = window.radWindow;
    else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow;

    return oWindow;
}

function OpenNewWindow(url, title, wwidth, wheight, windowid, icons) {
    return top.OpenNewWindow(url, title, wwidth, wheight, windowid, icons);
}

function OpenNewDialog(url, title, wwidth, wheight, windowid) {
    return top.OpenNewDialog(url, title, wwidth, wheight, windowid);
}

function OpenNewWindowSpecialIcons(url, title, Icons, wwidth, wheight, windowid) {
    return top.OpenNewWindowSpecialIcons(url, title, Icons, wwidth, wheight, windowid);
}

function CloseWindow(oWnd) {
    if (((typeof oWnd === 'undefined' || oWnd === null))) {  // No window given, close my self
        oWnd = GetRadWindow();
    }
    top.CloseWindow(oWnd);
}

