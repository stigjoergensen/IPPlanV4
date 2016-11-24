<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Contact.ascx.vb" Inherits="Windows_Host_Details_Host_Contact" %>
<%@ Register Src="/UserControl/Contacts.ascx"  TagName="Contacts" TagPrefix="UC" %>
<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />
<UC:Contacts runat="server" ID="Contacts" HostnameID="lblHostname" HostnameProperty="Text" EditMode="1" />
