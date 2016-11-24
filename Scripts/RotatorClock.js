

var TimeEntries = [];
var radrotator;

function LoadRadRotator(sender) {
    radrotator = sender;
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            TimeEntries = JSON.parse(xmlhttp.responseText);
        }
    };

    xmlhttp.open("POST", "/Providers/TimeInfo.asmx?op=GetTimeInfoJson", true)
    var sr = '<?xml version="1.0" encoding="utf-8"?>' +
             '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
             '<soap:Body>' +
             '<GetTimeInfoJson xmlns="http://tempuri.org/" />' +
             '</soap:Body>' +
             '</soap:Envelope>'

    xmlhttp.setRequestHeader('Content-Type', 'text/xml');
    xmlhttp.send(sr);
    //setInterval('CreateRotatorEntries()', 10000);
    setTimeout('CreateRotatorEntries()', 1000);
//    CreateRotatorEntries()
}

Date.prototype.getWeek = function () {
    var onejan = new Date(this.getFullYear(), 0, 1);
    return Math.ceil((((this - onejan) / 86400000) + onejan.getDay() + 1) / 7);
}

Date.prototype.addHours = function (h) {
    this.setHours(this.getHours() + h);
    return this;
}

Date.prototype.addMinutes = function (m) {
    this.setMinutes(this.getMinutes() + m);
    return this;
}

function RadRotatorItemShown(sender, args) {
    if (typeof args.get_item() != 'undefined') {
        if (args.get_item()._element.innerHTML == "") {
            CreateRotatorEntries()
        }
    }
}

function CreateRotatorEntries() {
    radrotator.stop();
    radrotator.clearItems();
    var i;
    for (i = 0; i < TimeEntries.length; i++) {
        var now = new Date();
        now.addMinutes(TimeEntries[i].UTCOffset);

        if ((now.getWeek() >= TimeEntries[i].DSTStartWeekNo) && (now.getWeek() <= TimeEntries[i].DSTEndWeekNo)) {
            now.addHours(1);
            dts = ' (DST)';
        }

        var dts = '';
        var UTChours = now.getUTCHours();
        var UTCminutes = now.getUTCMinutes();
        var UTCseconds = now.getUTCSeconds();
        var UTCmonth = (now.getUTCMonth() + 1);
        var UTCday = now.getUTCDate();

        radRotatorItemData = {
            Html: "<span style='white-space:nowrap;'>" + TimeEntries[i].PlaceName + ": " +
                             now.getFullYear() + "." +
                             ((UTCmonth > 9) ? UTCMonth : "0" + UTCmonth) + "." +
                             ((UTCday > 9) ? UTCday : "0" + UTCday) + " " +
                             ((UTChours > 9) ? UTChours : "0" + UTChours) + ":" +
                             ((UTCminutes > 9) ? UTCminutes : "0" + UTCminutes) +
                             dts + "</span>" +
                             ((TimeEntries.length -1 == i) ? " " : "")
        };
        radrotator.addRotatorItem(radRotatorItemData,i);
    }
    radRotatorItemData = {
        Html: ""
    };
    radrotator.addRotatorItem(radRotatorItemData, 99);

    radrotator.start();
}

