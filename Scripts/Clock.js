Date.prototype.getWeek = function () {
    var onejan = new Date(this.getFullYear(), 0, 1);
    return Math.ceil((((this - onejan) / 86400000) + onejan.getDay() + 1) / 7);
}

function updateClock() {

    // Gets the current time
    var now = new Date();

    // Get the hours, minutes and seconds from the current time
    var Lhours = now.getHours();
    var Lminutes = now.getMinutes();
    var Lseconds = now.getSeconds();
    var Lmonth = (now.getMonth() + 1);
    var Lday = now.getDate()

    var UTChours = now.getUTCHours();
    var UTCminutes = now.getUTCMinutes();
    var UTCseconds = now.getUTCSeconds();
    var UTCmonth = (now.getUTCMonth() + 1);
    var UTCday = now.getUTCDate()

    // Gets the element we want to inject the clock into
    var elem = document.getElementById('clock');

    elem.innerHTML = now.getFullYear() + '.' +
                    (Lmonth > 9 ? Lmonth : "0" + Lmonth) + '.' +
                    (Lday > 9 ? Lday : "0" + Lday) + ' ' +
                    (Lhours > 9 ? Lhours : "0" + Lhours) + ':' +
                    (Lminutes > 9 ? Lminutes : "0" + Lminutes) + ':' +
                    (Lseconds > 9 ? Lseconds : "0" + Lseconds) + " (" +
                    (now.getWeek()) + ")";

    // Sets the elements inner HTML value to our clock data
    //elem.innerHTML = now.getFullYear() + '.' + month + '.' + day + ' ' + hours + ':' + minutes + ':' + seconds;
}
