<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- Page should accept  ?Page=  or ?Search=&Type=[APPID|Hostname] -->
<html xmlns="http://www.w3.org/1999/xhtml" style="overflow:hidden;">
<head runat="server">
    <title></title>
	<link href="styles/Default.css" rel="stylesheet" />
	<link href="styles/Menu.css" rel="stylesheet" />
    <script type="text/javascript" src="/Scripts/Menu.js" ></script>
    <script type="text/javascript" src="/Scripts/IPPlanSearch.js" ></script>
    <script type="text/javascript" src="/Scripts/Clock.js"></script>
    <script type="text/javascript" src="/Scripts/json2/json2.js"></script>
    <script type="text/javascript" src="/Scripts/RotatorClock.js"></script>
</head>
<body onresize="onWindowResize()">
    <form id="form1" runat="server" class="full">
        <telerik:RadScriptManager runat="server" ID="ScriptManager1" />
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />
        <telerik:radwindowmanager ID="RadWindowManager" runat="server"
                                    EnableShadow="True" DestroyOnClose="True" VisibleStatusbar="False" Opacity="99"
								    RestrictionZoneID="RestrictionZone" RenderMode="Lightweight" />
        <script type="text/javascript">
            // Function is copied to windows.js, and must exists in both places.
            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow) oWindow = window.radWindow;
                else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow;

                return oWindow;
            }


            function onWindowLoad(oWnd, args) {
                oWnd.autoSize();
                oWnd.center();
            }

            function onClientPageResize(oWnd, args) {
                var newheight = desktop.clientHeight - searchzone.clientHeight - taskbar.clientHeight;
                RestrictionZone.style.height = newheight;
                RestrictionZone.setAttribute("style", "height:" + newheight + "px");

                if (!(typeof oWnd === 'undefined' || oWnd === null)) {
                    var windows = GetRadWindowManager().get_windows();
                    for (var i = 0; i < windows.length; i++) {
                        windows[i].set_restrictionZoneID("restrictionzone");
                    }
                }
            }

            function onWindowResize() {
                onClientPageResize(null, null);
            }

            // this event is called when window is closed
            // sender: the window
            function onWindowClose(sender, args) {
                if ((sender.tabhandle) && (sender.tabhandle != null)) {
                    var tabStrip = $find("<%= RadTabStrip1.ClientID %>");
                    tabStrip.trackChanges();
                    tabStrip.get_tabs().remove(sender.tabhandle);
                    tabStrip.commitChanges();
                    sender.tabhandle = null;
                }
                sender.remove_activate(onWindowActivate);
                sender.remove_pageLoad(onWindowLoad);
                sender.remove_close(onWindowClose);
                sender.remove_command(onClientCommand);
            }

            // this event is called when window becomes activated
            // sender: the window
            function onWindowActivate(sender, args) {
                if (sender.tabhandle) {
                    sender.tabhandle.select();
                }
            }

            function onClientCommand(sender, args) {
                var cmdname = args.get_commandName()
                if (cmdname == 'Minimize') {
                    sender.hide();
                    sender.tabhandle.unselect();
                }
            }

            // This event is called when a Tab on the Tabstrip have been pressed and thereby made active
            // sender: the tabstrip
            function onTabActivate(sender, args) {
                var oWin = sender.get_selectedTab().windowhandle;
                oWin.Show();
                oWin.restore();
            }

            // Test if url exists
            // url: the url to be tested
            function urlExists(url) {
                var http = new XMLHttpRequest();
                http.open('HEAD', url, false);
                http.send();
                return http.status != 404;
            }

            // Find the image filename for a given url
            // url: 
            function getIconFilename(url) {
                url = url.substring(0, (url.indexOf("#") == -1) ? url.length : url.indexOf("#"));
                url = url.substring(0, (url.indexOf("?") == -1) ? url.length : url.indexOf("?"));
                var filename = url.substring(url.lastIndexOf("/") + 1, url.length);
                filename = filename.substring(0, filename.lastIndexOf('.'));
                if (urlExists('/images/WindowIcons/Taskbar/' + filename + '.png')) {
                    return filename + '.png'
                } else {
                    return 'Globe.png'
                }
            }


            // url: the url for the page to be shown in the window
            // title: the title of the window
            // wwidth: optional width of the window (0 if full width, -number = size with no auto expansion)
            // wheight: optional the height of the window (0 is full height, -number = size with no auto expansion)
            // windowid: optional window id, so window can be reused
            // icons: ( None : 0,  Resize : 1, Minimize : 2, Close : 4, Pin : 8, Maximize : 16, Move: 32, Reload: 64)
            function OpenNewWindow(url, title, wwidth, wheight, windowid, icons) {
                if (typeof windowid === 'undefined' || windowid === null) {
                    windowid = null
                }
                var iconFilename = getIconFilename(url);

                if (windowid != null) {
                    var oWin = GetRadWindowManager().open(url, windowid);
                    oWin.set_destroyOnClose(false);
                } else {
                    var oWin = GetRadWindowManager().open(url);
                    oWin.set_destroyOnClose(true);
                }

                oWin.set_iconUrl("/Images/WindowIcons/Window/" + iconFilename);
                oWin.set_visibleStatusbar(false);
                oWin.set_title(title);

                // calculate icons
                oWin.set_modal(false);
                if (typeof icons === 'undefined' || icons === null || icons === 0) {
                    icons = 1 + 2 + 4 + 16 + 32;  // Standard icons Resize, Minimize, Maximize, Close, Move
                } else {
                    if (icons === 99) {  // if icons is 99 then we make it a Modal dialog with only Close icon
                        icons = 4
                        oWin.set_modal(true);
                    } else {
                        if (icons < 0) {
                            icons = (1 + 2 + 4 + 16 + 32) ^ (icons * -1);  // xor standard icons with new value (eg caller can add or remove icons if suplied value is negative)
                        }
                    }
                }
                oWin.set_behaviors(icons);

                // calculate autosize behaviors (0 full witdh/height)
                var autosize = Telerik.Web.UI.WindowAutoSizeBehaviors.Height + Telerik.Web.UI.WindowAutoSizeBehaviors.Width
                if (!((typeof wheight === 'undefined' || wheight === null))) {  // calculate height
                    if (wheight < 0) {
                        autosize = autosize - Telerik.Web.UI.WindowAutoSizeBehaviors.Height;
                        oWin.set_height(wheight);
                    } else if (wheight == 0) {
                        wheight = document.getElementById(oWin.get_restrictionZoneID()).clientHeight;
                        oWin.set_height(wheight);
                        oWin.set_minHeight(wheight);
                        oWin.set_maxHeight(wheight);
                        oWin.maximize();
                        oWin.restore();
                        oWin.MoveTo(oWin.getWindowBounds().x, 0);
                    } else {
                        oWin.set_height(wheight);
                    }
                }
                if (!((typeof wwidth === 'undefined' || wwidth === null))) {  // Calculate witdh
                    if (wwidth < 0) {
                        autosize = autosize - Telerik.Web.UI.WindowAutoSizeBehaviors.Width;
                        oWin.set_width(wwidth * -1);
                    } else if (wwidth == 0) {
                        wwidth = document.getElementById(oWin.get_restrictionZoneID()).clientWidth;
                        oWin.set_minWidth(wwidth);
                        oWin.set_maxWidth(wwidth);
                        oWin.set_width(wwidth);
                        oWin.maximize();
                        oWin.restore();
                        oWin.MoveTo(0, oWin.getWindowBounds().y);
                    } else {
                        oWin.set_width(wwidth);
                    }
                }
                oWin.set_autoSizeBehaviors(autosize);

                if (!oWin.Exists) {  // this is the first time the window is opened
                    oWin.add_close(onWindowClose);
                    oWin.add_activate(onWindowActivate);
                    oWin.add_pageLoad(onWindowLoad);
                    oWin.add_command(onClientCommand);

                    if (!oWin.isModal()) { // if we are not modal then add a tab to the tabstrip
                        var tabStrip = $find("<%= RadTabStrip1.ClientID %>");
                            var oTab = new Telerik.Web.UI.RadTab();
                            oTab.set_cssClass("taskbar_tab");
                            oTab.set_selectedCssClass("taskbar_tab_selected");
                            oTab.set_text(title);
                            oTab.set_imageUrl("/Images/WindowIcons/Taskbar/" + iconFilename);

                            tabStrip.trackChanges();
                            tabStrip.get_tabs().add(oTab);
                            tabStrip.commitChanges();

                            oTab.windowhandle = oWin;
                            oWin.tabhandle = oTab;
                        }
                        oWin.Exists = true;
                    }


                    if (oWin.tabhandle) { // if we have a tab on the tabstrip then select it
                        oWin.tabhandle.select();
                    }
                    return oWin;
                }

                // alternate way of calling OpenNewWindow, will make the window modal and only show the close button
                // url: the url for the page to be shown in the window
                // title: the title of the window
                // wwidth: optional width of the window (0 if full width)
                // wheight: optional the height of the window (0 is full height)
                // windowid: optional window id, so window can be reused
                function OpenNewDialog(url, title, wwidth, wheight, windowid) {
                    return OpenNewWindow(url, title, wwidth, wheight, windowid, 99);
                }

                // alternate way of calling OpenNewWindow
                // url: the url for the page to be shown in the window
                // title: the title of the window
                // wwidth: optional width of the window (0 if full width)
                // wheight: optional the height of the window (0 is full height)
                // windowid: optional window id, so window can be reused
                // icons: ( None : 0,  Resize : 1, Minimize : 2, Close : 4, Pin : 8, Maximize : 16, Move: 32, Reload: 64)
                function OpenNewWindowSpecialIcons(url, title, Icons, wwidth, wheight, windowid) {
                    return OpenNewWindow(url, title, wwidth, wheight, windowid, Icons);
                }

                // oWnd: should be the window to be closed
                function CloseWindow(oWnd) {
                    //alert("test");
                    if (((typeof oWnd === 'undefined' || oWnd === null))) {  // No window given, find my self
                        oWnd = GetRadWindow()
                    }
                    if (oWnd.radWindow) {
                        //setTimeout(function () { oWnd.close(); }, 200);
                        oWnd.close();
                    } else {
                        oWnd.close();
                    }

                }

        </script>
        <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
            <script type="text/javascript">
                //<![CDATA[
                function OpenPageWindow(url) {
                    alert(url);
                }

                function KeySearch(sender, eventArgs) {
                    if (eventArgs.get_domEvent().keyCode == 13) {
                        var defaultButton = $telerik.findButton("<%= ipplanFind.ClientID%>");
                        defaultButton.click();

                        //if (typeof (defaultButton.click) != "undefined") {
                        //    __defaultFired = true;
                        //    defaultButton.click();
                        //    event.cancelBubble = true;
                        //
                        //    if (event.stopPropagation) event.stopPropagation();
                        //    return false;
                        //}

                        //if (typeof (defaultButton.href) != "undefined") {
                        //    __defaultFired = true;
                        //    eval(defaultButton.href.substr(11));
                        //    event.cancelBubble = true;
                        //
                        //    if (event.stopPropagation) event.stopPropagation();
                        //    return false;
                        //}

                    }
                    return true;
                }

                function IPPlanSearchButtonClick(sender, eventArgs) {
                    var Hostname = $find("<%= Hostname.ClientID %>")._text;
                    if (Hostname == 'cyberdyne') {
                        document.getElementById('desktop').className = 'desktop2';
                    } else {
                        var func = $find("<%= Func.ClientID%>")._text;
                        var ApplicationID = $find("<%= ApplicationId.ClientID%>")._text;
                        var IPAddress = $find("<%= IPAddress.ClientID%>")._text;
                        var Terminated = $find("<%= Terminated.ClientID%>")._selectedValue;
                        var url = "/Windows/IPPlanSearch.aspx?hostname=" + Hostname + "&function=" + func + "&EnvironmentID=&Application=" + ApplicationID + "&IPAddress=" + IPAddress + "&MACAddress=&AssignedIP=&ManagementIP=&CountryID=&SerialNumber=&Asset=&OSName=&DateID=&CertificateName=&Terminated=" + Terminated;
                        OpenNewWindow(url, "Search IPPlan");
                    }
                    return false;
                }

                function IPPlanFindButtonClick(sender, eventArgs) {
                    var Hostname = $find("<%= Hostname.ClientID %>")._text;
                    if (Hostname == 'cyberdyne') {
                        document.getElementById('desktop').className = 'desktop2';
                    } else {
                        var func = $find("<%= Func.ClientID%>")._text;
                        var ApplicationID = $find("<%= ApplicationId.ClientID%>")._text;
                        var IPAddress = $find("<%= IPAddress.ClientID%>")._text;
                        var Terminated = $find("<%= Terminated.ClientID%>")._selectedValue;
                        var url = "/Windows/IPPlan.aspx?OnlyMyList=false&Hostname=" + Hostname + "&Function=" + func + "&AppSearch=" + ApplicationID + "&IPAddress=" + IPAddress + "&Terminated=" + Terminated;
                        OpenNewWindow(url, "IPPlan",0,0);
                    }
                    return false;
                }
                //]]>            
            </script>
        </telerik:RadCodeBlock>
        <div id="desktop" class="desktop">
            <div id="searchzone" class="SearchZone" >
                <table width="100%" border="0" style="border-collapse:collapse;">
                    <tr>
                        <td width="*">
                            <asp:Panel runat="server" ID="SearchPanel" >
                                <span class="searchItem">
                                    <telerik:RadComboBox ID="Hostname" AllowCustomText="true" runat="server" EmptyMessage="Hostname" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true" OnClientKeyPressing="KeySearch" AccessKey="h" ToolTip="ALT + H to active the field">
                                        <WebServiceSettings Method="GetHostnames" Path="Providers/IPPlanSearch.asmx" />
                                    </telerik:RadComboBox>
                                </span>
                                <span class="searchItem">
                                    <telerik:RadComboBox ID="Func" AllowCustomText="true" runat="server" EmptyMessage="Function" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true" OnClientKeyPressing="KeySearch" AccessKey="f" ToolTip="ALT + F to active the field">
                                        <WebServiceSettings Method="GetFunctions" Path="Providers/IPPlanSearch.asmx" />
                                    </telerik:RadComboBox>
                                </span>
                                <span class="searchItem">
                                    <telerik:RadComboBox ID="ApplicationID" AllowCustomText="true" runat="server" EmptyMessage="Application" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true" OnClientKeyPressing="KeySearch" AccessKey="a" ToolTip="ALT + A to activate the field">
                                        <WebServiceSettings Method="GetApplications" Path="Providers/IPPlanSearch.asmx" />
                                    </telerik:RadComboBox>
                                </span>
                                <span class="searchItem">
                                    <telerik:RadComboBox ID="IPAddress" AllowCustomText="true" runat="server" EmptyMessage="IP Address" OnClientItemsRequesting="IPPlanSearch" EnableLoadOnDemand="true" OnClientKeyPressing="KeySearch" AccessKey="i" ToolTip="ALT + I to activate the field">
                                        <WebServiceSettings Method="GetIPAddresses" Path="Providers/IPPlanSearch.asmx" />
                                    </telerik:RadComboBox>
                                </span>
                                <span class="searchItem">
                                    <telerik:RadDropDownList ID="Terminated" runat="server">
                                        <Items>
                                            <telerik:DropDownListItem Text="Terminated" Value="1" />
                                            <telerik:DropDownListItem Text="Running" Value="0" Selected="true" />
                                        </Items>
                                    </telerik:RadDropDownList>
                                </span>
                                <span class="searchItem">
                                    <telerik:RadButton ID="ipplanFind" runat="server" ButtonType="LinkButton" CssClass="imageButton_75" Text="Find" OnClientClicked="IPPlanFindButtonClick" AutoPostBack="false" ToolTip="Use enter to perform Find">
                                        <Icon PrimaryIconUrl="Images/search_16x16.png" />
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="ipplanSearch" runat="server" ButtonType="LinkButton" CssClass="imageButton_75" Text="Search" OnClientClicked="IPPlanSearchButtonClick" AutoPostBack="false" AccessKey="s" ToolTip="ALT + S to activate the button" >
                                        <Icon PrimaryIconUrl="Images/Find_16x16.png" />
                                    </telerik:RadButton>
                                </span>
                            </asp:Panel>
                        </td>
                        <td>
                            <span class="TimeZoneInfo">
                                <telerik:RadRotator ClientIDMode="Static" runat="server" ID="TimeZoneRotator" RenderMode="Lightweight" FrameDuration="4000" ScrollDirection="Up" ScrollDuration="500" Height="22" OnClientLoad="LoadRadRotator" OnClientItemShown="RadRotatorItemShown" >
                                </telerik:RadRotator>
                            </span>
                            <telerik:RadContextMenu ID="TimeZoneInfo" CssClass="mainMenu" runat="server" EnableRoundedCorners="true" EnableShadows="true" OnClientItemClicked="MenuItemClicked" >
                                <Targets>
                                    <telerik:ContextMenuElementTarget ElementID="TimeZoneRotator" />
                                </Targets>
                                <WebServiceSettings Method="GetMenu" Path="Providers/MenuProvider.asmx" />
                                <Items>
                                    <telerik:RadMenuItem Text="Time Info" ExpandMode="WebService" Value="Menu:60" />
                                </Items>
                            </telerik:RadContextMenu>
                        </td>
                        <td width="25">
                            <telerik:RadMenu ID="RadMenu1" runat="server" OnClientItemClicked="MenuItemClicked" CssClass="HelpMenu">
                                <WebServiceSettings Method="GetMenu" Path="Providers/MenuProvider.asmx" />
                                <Items>
                                    <telerik:RadMenuItem Text="" Height="22" Width="22" ExpandMode="WebService" Value="Menu:55" ImageUrl="/Images/infomation_16x16.png" />
                                </Items>
                            </telerik:RadMenu>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="RestrictionZone" class="RestrictionZone" style="overflow:hidden"></div>
            <div id="taskbar" class="taskbar" style="z-index:999999;">
                <table width="100%">
                    <tr>
                        <td class="taskbar_start" style="width:112px;">
                            <telerik:RadMenu ID="StartMenu" CssClass="mainMenu" runat="server" OnClientItemClicked="MenuItemClicked" >
                                <WebServiceSettings Method="GetMenu" Path="Providers/MenuProvider.asmx" />
                                <Items>
                                    <telerik:RadMenuItem Text="" Height="40" Width="112" ExpandMode="WebService" Value="Menu:1" ImageUrl="/Images/DSVMenu_blue.png" CssClass="mainMenu" ExpandedCssClass="mainMenu"/>
                                </Items>
                            </telerik:RadMenu>
                        </td>
                        <td style="width:100%;">
                            <div class="taskbar_tabs" >
                                <telerik:radtabstrip ID="RadTabStrip1" Orientation="HorizontalBottom" runat="server" OnClientTabSelected="onTabActivate" Skin="" EnableEmbeddedSkins="false">
			                        <Tabs>
			                        </Tabs>
		                        </telerik:radtabstrip>
                            </div>
                        </td>
                        <td class="taskbar_notification" style="width:150px;">
                            <span id="ConfigMenuArea">
                                <asp:label id="Username" Text="" runat="server" />
                                <br /><span id="clock" style="white-space:nowrap;"></span>
                            </span>
                            <telerik:RadContextMenu ID="ConfigMenu" CssClass="mainMenu" runat="server" EnableRoundedCorners="true" EnableShadows="true" OnClientItemClicked="MenuItemClicked" >
                                <Targets>
                                    <telerik:ContextMenuElementTarget ElementID="ConfigMenuArea" />
                                </Targets>
                                <WebServiceSettings Method="GetMenu" Path="Providers/MenuProvider.asmx" />
                                <Items>
                                    <telerik:RadMenuItem Text="Configuration" ExpandMode="WebService" Value="Menu:2" />
                                </Items>
                            </telerik:RadContextMenu>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <script type="text/javascript" language="javascript">
            onWindowResize();
            setInterval('updateClock()', 200);

        </script>
    </form>
</body>
</html>
