function IPPlanSearch(sender, eventArgs) {
    var context = eventArgs.get_context();
    context["FilterString"] = eventArgs.get_text();
}
