<%@ Page Language="VB" AutoEventWireup="false" CodeFile="MyList.aspx.vb" Inherits="Windows_Host_MyList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="/Scripts/Windows.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label runat="server" ID="Hostname" />
        <asp:Label runat="server" ID="AddHost" Text=" have been added to 'My List'" Visible="false" />
        <asp:Label runat="server" ID="RemoveHost" Text=" have been removed from 'My List'" Visible="false" />
        <script type="text/javascript" >
            setTimeout("CloseWindow();", 5000);
        </script>

        <asp:SqlDataSource ID="MyHostList" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
            InsertCommand="INSERT INTO PersonalSetting (Username,GroupName,Keyname,Value) VALUES(@Username,'MyList','Hostname',@Hostname)"
            DeleteCommand="DELETE FROM PersonalSetting WHERE Username=@Username AND GroupName='MyList' AND KeyName='Hostname' AND Value=@Hostname"
            >
            <InsertParameters>
                <asp:ControlParameter ControlID="Hostname" PropertyName="Text" Name="Hostname" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Username" ConvertEmptyStringToNull="true" />
            </InsertParameters>
            <DeleteParameters>
                <asp:ControlParameter ControlID="Hostname" PropertyName="Text" Name="Hostname" ConvertEmptyStringToNull="true" />
                <asp:Parameter Name="Username" ConvertEmptyStringToNull="true" />
            </DeleteParameters>
        </asp:SqlDataSource>

    </div>
    </form>
</body>
</html>
