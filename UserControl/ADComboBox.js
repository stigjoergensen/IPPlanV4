
function OnADComboBoxItemsRequesting(sender, eventArgs) {
    var context = eventArgs.get_context();
    context['FilterString'] = eventArgs.get_text();
    context['ReturnAttribute'] = sender.get_attributes().getAttribute('ReturnAttribute');
    context['SearchClasses'] = sender.get_attributes().getAttribute('SearchClasses');
}
function onADComboBoxItemDataBound(Sender, eventArgs) {
    var item = eventArgs.get_item();
    var dataItem = eventArgs.get_dataItem();
    var SearchText = Sender.get_text();
    var ItemText = item.get_text();
    if (ItemText.length > (SearchText.length + 4)) {
        item.set_text('...' + ItemText.substr(SearchText.length))
    }
    if (dataItem.Attributes.Type == 'person') {
        item.set_imageUrl('/Images/Person_16x16.png');
    } else {
        item.set_imageUrl('/Images/Group_16x16.png');
    }
}

// notify that the script has been loaded <-- new!
if (typeof (Sys) !== 'undefined') Sys.Application.notifyScriptLoaded();