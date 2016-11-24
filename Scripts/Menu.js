function MenuItemClicked(Sender, args) {
    var script = args.get_item().get_value();
    if (script.match("^Menu:")) {
        var test = /^Menu:(\d+):(.*)/.exec(script);
        if (test.length > 2) {
            eval(test[2].substring(1));
        }
    } else {
        eval(script);
    }
    return false;
}
