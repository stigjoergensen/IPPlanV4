<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Contact.aspx.vb" Inherits="Windows_Host_Contact" %>
<%@ Register Src="/UserControl/Contacts.ascx"  TagName="Contacts" TagPrefix="UC" %>
<asp:Label runat="server" ID="Hostname" Visible="false" />
<asp:Label runat="server" ID="EditMode" Text="0" Visible="false" />
<UC:Contacts runat="server" ID="Contacts" HostnameID="Hostname" HostnameProperty="Text" EditMode="1" />
