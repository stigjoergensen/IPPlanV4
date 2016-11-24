
function GetRadWindow() {
    return top.GetRadWindow();
}

function CloseModal(oWnd) {
    top.CloseModal(oWnd);
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
    return top.OpenWindowV1(url, WindowTitle);
}

function OpenWindowV2(url, WindowTitle, width, height) {
    return top.OpenWindowV2(url, WindowTitle, width, height);
}

function OpenWindowMaxWidthV1(url, WindowTitle) {
    return top.OpenWindowMaxWidthV1(url, WindowTitle);
}

function OpenWindowMaxWidthV2(url, WindowTitle, height) {
    return top.OpenWindowMaxWidthV2(url, WindowTitle, height);
}

function OpenDialogV1(url, WindowTitle) {
    return top.OpenDialogV1(url, WindowTitle);
}

function OpenDialogV2(url, WindowTitle, width, height) {
    return top.OpenDialogV2(url, WindowTitle, width, height);
}