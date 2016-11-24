<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Contacts.ascx.vb" Inherits="UserControl_Contacts" %>
<%@ Register Src="/UserControl/ADComboBox.ascx" TagPrefix="UC" TagName="ADComboBox" %>

<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblEditMode" Visible="false" />
<telerik:RadGrid runat="server" ID="rgContacts" DataSourceID="HostContact" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true" >
    <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false" ShowFooter="true">
        <Columns>
            <telerik:GridTemplateColumn  HeaderText="Type" UniqueName="ContactTypeName">
                <ItemTemplate>
                    <asp:Label runat="server" ID="ContactTypeName" Text='<%#Eval("ContactTypeName")%>'/>
                </ItemTemplate>
                <FooterTemplate>
                    <telerik:RadButton runat="server" ID="Security" CommandName="Security" Text="Edit Security" />
                </FooterTemplate>
            </telerik:GridTemplateColumn>
            <telerik:GridTemplateColumn  HeaderText="Contact" UniqueName="Contact" >
                <ItemTemplate>
                    <asp:Label runat="server" ID="ContactTypeID" Text='<%#Bind("ContactTypeID")%>' Visible="false" />
                    <asp:Label runat="server" ID="Exists" Text='<%#Bind("Exists")%>' Visible="false" />
                    <asp:label runat="server" id="OriginalContact" Text='<%#Bind("Contact")%>' Visible="false" />
                    <telerik:RadComboBox runat="server" ID="Contact" EnableLoadOnDemand="true" OnClientItemsRequesting="OnADComboBoxItemsRequesting" OnClientItemDataBound="onADComboBoxItemDataBound" AllowCustomText="true"  >
                        <WebServiceSettings Method="Search"  Path="/Providers/ActiveDirectory.asmx" /> 
                    </telerik:RadComboBox>
                </ItemTemplate>
                <FooterTemplate>
                    <telerik:RadButton runat="server" ID="Update" CommandName="Update" Text="Update" />
                </FooterTemplate>
            </telerik:GridTemplateColumn>
            <telerik:GridTemplateColumn HeaderText="Security" UniqueName="Security">
                <ItemTemplate>
                    <asp:Image runat="server" ID="SecurityInfo" AlternateText="Security Info" ToolTip="" ImageUrl="/Images/infomation_16x16.png" />
                    <telerik:RadTextBox runat="server" ID="Security" Text='<%#Bind("EditGroups")%>' Visible="false" />
                    <asp:Label runat="server" ID="OriginalSecurity" Text='<%#Bind("EditGroups")%>' Visible="false" />
                </ItemTemplate>
                <FooterTemplate>
                    <telerik:RadButton runat="server" ID="UpdateSecurity" CommandName="UpdateSecurity" Text="Update Security" />
                </FooterTemplate>
            </telerik:GridTemplateColumn>
        </Columns>
    </MasterTableView>
</telerik:RadGrid>

<asp:SqlDataSource ID="HostContact" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT CT.*, HC.Contact, HC.ContactTypeID AS [Exists] FROM IPPlanV4ContactTypes AS CT LEFT OUTER JOIN HostContact AS HC ON HC.ContactTypeID = CT.ContactTypeID AND HC.Hostname = @Hostname WHERE isContact=1 ORDER BY SortOrder"
    InsertCommand="INSERT INTO HostContact(Hostname,ContactTypeID,Contact) VALUES(@Hostname,@ContactTypeID,@Contact)"
    UpdateCommand="UPDATE HostContact SET Contact=@Contact WHERE Hostname=@Hostname AND ContactTypeID=@ContactTypeID"
    DeleteCommand="DELETE FROM HostContact WHERE Hostname=@Hostname AND ContactTypeID=@ContactTypeID"
    >
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
    <DeleteParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="ContactTypeID" Type="Int32" ConvertEmptyStringToNull="true" />
    </DeleteParameters>
    <InsertParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="ContactTypeID" Type="Int32" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="Contact" Type="String" ConvertEmptyStringToNull="true" />
    </InsertParameters>
    <UpdateParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="ContactTypeID" Type="Int32" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="Contact" Type="String" ConvertEmptyStringToNull="true" />
    </UpdateParameters>
</asp:SqlDataSource>

<asp:SqlDataSource ID="IPPlanV4ContactTypes" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    UpdateCommand="UPDATE IPPlanV4ContactTypes SET EditGroups=@EditGroups WHERE ContactTypeID=@ContactTypeID"
    >
    <UpdateParameters>
        <asp:Parameter Name="ContactTypeID" Type="Int32" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="EditGroups" Type="String" ConvertEmptyStringToNull="true" />
    </UpdateParameters>
</asp:SqlDataSource>


<asp:SqlDataSource ID="HostExtraDataHistory" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    InsertCommand="INSERT INTO HostExtraDataHistory(Hostname,CreateDate,Description,who) VALUES(@Hostname,@When,@Description,@Who)"
    >
    <InsertParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:Parameter Name="Description" ConvertEmptyStringToNull="true" Type="String" />
        <asp:Parameter Name="Who" ConvertEmptyStringToNull="true" Type="String" />
        <asp:Parameter Name="When" ConvertEmptyStringToNull="true" Type="DateTime" />
    </InsertParameters>
</asp:SqlDataSource>
