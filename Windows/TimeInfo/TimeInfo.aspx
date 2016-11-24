<%@ Page Language="VB" AutoEventWireup="false" CodeFile="TimeInfo.aspx.vb" Inherits="Windows_TimeInfo_TimeInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <telerik:RadScriptManager runat="server" ID="ScriptManager" />
        <telerik:RadSkinManager ID="RadSkinManager1" runat="server" Skin="Windows7" />

        <telerik:RadGrid runat="server" ID="rgTimeInfo" DataSourceID="TimeInfo" AutoGenerateColumns="False" PageSize="29" AllowPaging="true" AllowAutomaticUpdates="true" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" >
            <MasterTableView  DataKeyNames="TimeInfoID" AutoGenerateColumns="false" AllowSorting="true" EditMode="InPlace" >
                <Columns>
                    <telerik:GridBoundColumn DataField="TimeInfoID" HeaderText="ID" ReadOnly="true" />
                    <telerik:GridBoundColumn DataField="PlaceName" HeaderText="Location" />
                    <telerik:GridBoundColumn DataField="UTCOffset" HeaderText="UTC Offset" />
                    <telerik:GridBoundColumn DataField="DSTStartWeekNo" HeaderText="DST Start week" />
                    <telerik:GridBoundColumn DataField="DSTEndWeekNo" HeaderText="DST End Week" />
                    <telerik:GridCheckBoxColumn DataField="Visible" HeaderText="Visible" StringTrueValue="1" StringFalseValue="0" DataType="System.Int32" />
                    <telerik:GridEditCommandColumn />
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>

        <asp:SqlDataSource runat="server" ID="TimeInfo" ConnectionString="<%$ ConnectionStrings:DSVAsset%>" 
            SelectCommand="SELECT * FROM TimeInfo"
            InsertCommand="INSERT INTO TimeInfo(PlaceName,UTCOffset,DSTStartWeekNo,DSTEndWeekNo,Visible) VALUES (@PlaceName,@UTCOffset,@DSTStartWeekNo,@DSTEndWeekNo,@Visible)"
            DeleteCommand="DELETE FROM TimeInfo WHERE TimeInfoID=@TimeInfoID"
            UpdateCommand="UPDATE TimeInfo SET PlaceName=@PlaceName, UTCOffset=@UTCOffset,DSTStartWeekNo=@DSTStartWeekNo,DSTEndWeekNo=@DSTEndWeekNo,Visible=@Visible WHERE TimeInfoID=@TimeInfoID">
        <InsertParameters>
            <asp:Parameter Name="PlaceName" DbType="String" ConvertEmptyStringToNull="true" />
            <asp:Parameter Name="UTCOffset" DbType="Int32" ConvertEmptyStringToNull="true" />
            <asp:Parameter Name="DSTStartWeekNo"  DbType="Int32" ConvertEmptyStringToNull="true" />
            <asp:Parameter Name="DSTEndWeekNo" DbType="Int32" ConvertEmptyStringToNull="true"  />
            <asp:Parameter Name="Visible" DbType="Int32" ConvertEmptyStringToNull="true" />
        </InsertParameters>
        <DeleteParameters>
            <asp:Parameter Name="TimeInfoID" DbType="Int32" ConvertEmptyStringToNull="true" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="TimeInfoID" DbType="Int32" ConvertEmptyStringToNull="true" />
            <asp:Parameter Name="PlaceName" DbType="String" ConvertEmptyStringToNull="true" />
            <asp:Parameter Name="UTCOffset" DbType="Int32" ConvertEmptyStringToNull="true" />
            <asp:Parameter Name="DSTStartWeekNo"  DbType="Int32" ConvertEmptyStringToNull="true" />
            <asp:Parameter Name="DSTEndWeekNo" DbType="Int32" ConvertEmptyStringToNull="true"  />
            <asp:Parameter Name="Visible" DbType="Int32" ConvertEmptyStringToNull="true" />
        </UpdateParameters>
        </asp:SqlDataSource>
    
    </div>
    </form>
</body>
</html>
