(function(global, undefined) {
    var windowOverview = {};

	function tabStrip_load(sender, args) {
		tabStrip = sender;
	}

	function KeyDownHandler(event, args) {
		var keyCode = args.get_keyCode();

		// process only the Enter key
		if (keyCode == 13) {
			openNewWindow();
		}
	}

	//
	function OnClientTabSelected(sender, args) {
		//get the current windows collection
		var selIndex = tabStrip.get_selectedIndex();
		OpenWindowByIndex(selIndex);
	}

	function OpenWindowByIndex(index) {
	    var windows = windowOverview.manager.get_windows();
		for (var i = 0; i < windows.length; i++) {
			var win = windows[i];
			if (i == index) {
				//Only show window if it is not currently visible to prevent recursion of RadWindow OnClientShow calling RadTabStrip OnClientTabSelected 
				if (!win.isVisible()) {
					win.show();
					win.center();
				}
			}
			else {
				win.hide();
			}
		}
	}

	function SetWindowBehavior(oWnd) {
		configureUI(oWnd);
	}

	function configureUI(oWnd) {
		//var bounds = oWnd.getWindowBounds();
		//var winHeight = bounds.height;
		//var winWidth = bounds.width;

		//Configure height 
		//winHeight = winHeight < 100 ? 100 : winHeight;
		//winHeight = winHeight > 400 ? 400 : winHeight;

		//Configure width 
		//winWidth = winWidth < 100 ? 100 : winWidth;
	    //winWidth = winWidth > 700 ? 700 : winWidth;

		//Set the transparency slider to the current transparency level for the active RadWindow
		var initialTransp = oWnd.get_opacity();

		//Make sure the window's corresponding tab is selected
		var windows = windowOverview.manager.get_windows();
		for (var i = 0; i < windows.length; i++) {
			if (windows[i] == oWnd) {
				var tab = tabStrip.get_allTabs()[i];
				//Avoid recursion if tab already selected
				if (tab && !tab.get_selected()) {
					tab.select();
				}
			}
		}
	}

	function OnClientClose(oWnd) {
		//Get the title of the active RadWindow
		var title = oWnd.get_title();
		var tab = tabStrip.findTabByText(title);
		if (tab) {
			tabStrip.trackChanges();
			tabStrip.get_tabs().remove(tab);
			tabStrip.commitChanges();
		}

		var selIndex = tabStrip.get_selectedIndex();
		if (selIndex > -1)
			OpenWindowByIndex(selIndex)
	}

	function OnClientValueChangedHeight(sender, args) {
		//get a reference to the window and set its height
	    var oWnd = windowOverview.manager.getActiveWindow();
		if (!oWnd) return;
		var newHeight = sender.get_value();
		oWnd.set_height(newHeight);
		//Update the label, showing the current value of the slider.
		//updateLabel(sender, demo.lblHeight);
	}

	function OnClientValueChangedWidth(sender, args) {
		//get a reference to the window and set its width
	    var oWnd = windowOverview.manager.getActiveWindow();
		if (!oWnd) return;
		oWnd.set_width(sender.get_value());
		//updateLabel(sender, demo.lblWidth);
	}

	function OnClientPageResize(oWnd) {
	    var newheight = desktop.clientHeight - searchzone.clientHeight - taskbar.clientHeight;
	    restrictionzone.style.height = newheight;
	    restrictionzone.setAttribute("style", "height:" + newheight + "px");
	    var windows = windowOverview.manager.get_windows();
	    for (var i = 0; i < windows.length; i++) {
	        windows[i].set_restrictionZoneID("restrictionzone");
	    }
    }

	function OnLoad(ownd) {
	    OnClientPageResize(ownd);
	}

	function OnClientPageLoad(oWnd) {
        /*
		var originalUrl = oWnd.get_navigateUrl();
		var websiteName = getWebsiteName(originalUrl);
		oWnd.set_title(websiteName);
		tabStrip.trackChanges();
		var tab = tabStrip.get_selectedTab();
		//check if tab exists - if it doesn't this is a newly created window and
		//its text will be set in the openNewWindow() function
		if (tab) {
			tab.set_text(websiteName);
		}
		var iconUrl = originalUrl + "/favicon.ico";
		if (originalUrl.indexOf("converter.telerik.com") > 0) iconUrl = "codeConverterFavicon.ico";
		if (originalUrl.indexOf("www.telerik.com") > 0) iconUrl = "telerikFavicon.ico";
		if (originalUrl.indexOf("www.w3.org") > 0) iconUrl = "w3Favicon.png";
		//Change RadWindow icon to the favicon.ico icon of the opened site
		oWnd.set_iconUrl(iconUrl);
        */
	}


	global.tabStrip_load = tabStrip_load;
	//global.openNewWindow = openNewWindow;
	global.OnClientPageLoad = OnClientPageLoad;
	global.OnClientClose = OnClientClose;
	global.SetWindowBehavior = SetWindowBehavior;
	global.OnClientTabSelected = OnClientTabSelected;

	global.windowOverview = windowOverview;
	global.KeyDownHandler = KeyDownHandler;
	global.onresize = OnClientPageResize;
	global.onload = OnLoad;

	//global.IPPlanSearchButtonClick = IPPlanSearchButtonClick
    //global.IPPlanFindButtonClick = IPPlanFindButtonClick
})(window);
