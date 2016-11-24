<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ErrorPage.aspx.vb" Inherits="Windows_ErrorPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div >
        <table style="vertical-align:top;">
            <tr>
                <td rowspan="2">
                    <img src="/Images/Errorpage.png" style="width:80px;" />
                </td>
                <td>
                    We are sorry, the page you are looking for does not exists<br /> or you dont have access to view it.
                </td>
             </tr>
            <tr>
                <td>Page: <asp:Label runat="server" ID="pagename" Text="" /></td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
