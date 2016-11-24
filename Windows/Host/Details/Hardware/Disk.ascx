<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Disk.ascx.vb" Inherits="Windows_Host_Details_Windows_Disk" %>
<asp:Label runat="server" ID="lblHostname" Visible="false" />
<asp:Label runat="server" ID="lblDeviceID" Text="C:" Visible="false" />
<asp:Label runat="server" ID="lblIncludeHistory" Text="0" Visible="false" />

<telerik:RadGrid runat="server" ID="rgHostDisk" DataSourceID="HostDisk" AllowPaging="true" PageSize="25" AllowSorting="true" AllowFilteringByColumn="true">
    <ClientSettings Selecting-AllowRowSelect="true" EnablePostBackOnRowClick="true" />
    <MasterTableView runat="server" AutoGenerateColumns="false" AllowPaging="true" PageSize="25" IsFilterItemExpanded="false" DataKeyNames="DeviceID">
        <Columns>
            <telerik:GridBoundColumn DataField="DeviceID" HeaderText="Device" />
            <telerik:GridBoundColumn HeaderText="Name" DataField="VolumeName" />
            <telerik:GridBoundColumn HeaderText="Free" DataField="PCT" />
            <telerik:GridBoundColumn HeaderText="FreeSpace" DataField="Freespace" />
            <telerik:GridBoundColumn HeaderText="Size" DataField="Size" />
            <telerik:GridBoundColumn HeaderText="Updated" DataField="_lastUpdate" DataFormatString="{0:yyyy.MM.dd HH:mm}" />
        </Columns>
    </MasterTableView>
</telerik:RadGrid>

<asp:UpdatePanel runat="server" ID="ChartPanel" ChildrenAsTriggers="true">
    <ContentTemplate>
        <telerik:RadHtmlChart runat="server" ID="LineChart" Width="800" Height="500" Transitions="true" Skin="Windows7" DataSourceID="HostDiskHistory3">
            <Appearance>
                <FillStyle BackgroundColor="Transparent"></FillStyle>
            </Appearance>
            <ChartTitle Text="Disk usage history">
                <Appearance Align="Center" BackgroundColor="Transparent" Position="Top">
                </Appearance>
            </ChartTitle>
            <Legend>
                <Appearance BackgroundColor="Transparent" Position="Bottom">
                </Appearance>
            </Legend>
            <PlotArea>
                <Appearance>
                    <FillStyle BackgroundColor="Transparent"></FillStyle>
                </Appearance>
                <XAxis AxisCrossingValue="0" Color="black" MajorTickType="Outside" MinorTickType="Outside" Reversed="false" DataLabelsField="Dates" Type="Category" >
                    <LabelsAppearance DataFormatString="{0:yyyy.MM.dd}" RotationAngle="75" />
                    <TitleAppearance Position="Center" RotationAngle="0" Text="Date" />
                    <AxisCrossingPoints>
                        <telerik:AxisCrossingPoint Value="0" />
                        <telerik:AxisCrossingPoint Value="30" />
                    </AxisCrossingPoints>
                </XAxis>
                <YAxis AxisCrossingValue="0" Name="Used" Reversed="false"/>
                <YAxis AxisCrossingValue="0" Name="Total" Reversed="false" >
                    <TitleAppearance Text="Size (GB)" RotationAngle="270" />
                </YAxis>
                <AdditionalYAxes>
                    <telerik:AxisY AxisCrossingValue="0" Name="Percentage" Reversed="false" MaxValue="100" MinValue="0" Color="blue">
                        <TitleAppearance Text="Percent" RotationAngle="90" />
                    </telerik:AxisY>
                </AdditionalYAxes>
                <Series>
                    <telerik:LineSeries DataFieldY="Used" Name="Used">
                        <LabelsAppearance Visible="false" />
                        <MarkersAppearance MarkersType="Circle" />
                        <Appearance FillStyle-BackgroundColor="Red" />
                    </telerik:LineSeries>
                    <telerik:LineSeries DataFieldY="Size" Name="Total">
                        <LabelsAppearance Visible="false" />
                        <MarkersAppearance MarkersType="Circle" />
                        <Appearance FillStyle-BackgroundColor="Green" />
                    </telerik:LineSeries>
                    <telerik:LineSeries DataFieldY="PCT" Name="Percentage" AxisName="Percentage">
                        <LabelsAppearance Visible="false" />
                        <MarkersAppearance MarkersType="Triangle" />
                        <Appearance FillStyle-BackgroundColor="Blue" />
                    </telerik:LineSeries>
                </Series>
            </PlotArea>
        </telerik:RadHtmlChart>
        History: <telerik:RadComboBox runat="server" ID="GraphMethod" AutoPostBack="true">
            <Items>
                <telerik:RadComboBoxItem Text="Last Month" Value="1" />
                <telerik:RadComboBoxItem Text="Last 6 month by week" Value="3" Selected="true" />
                <telerik:RadComboBoxItem Text="Last Year by month" Value="2" />
            </Items>
        </telerik:RadComboBox>
    </ContentTemplate>
</asp:UpdatePanel>

<asp:SqlDataSource ID="HostDisk" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="False" 
    SelectCommand="SELECT DeviceID, VolumeName, Freespace / 1024 / 1024 / 2014  AS FreeSpace, Size / 1024 / 1024 / 2014  AS Size,_lastUpdate, ((FreeSpace)*100/(Size+1)) AS PCT FROM HostDisk WHERE Hostname = @Hostname AND (_Active=1 OR @IncludeHistory=1)">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:ControlParameter Name="IncludeHistory" ControlID="lblincludeHistory" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

<asp:SqlDataSource ID="HostDiskHistory1" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
    SelectCommand="SELECT FreeSpace / 1024 / 1024 / 2014 AS Freespace,Size / 1024 / 1024 / 2014 AS Size, (Size-FreeSpace) / 2014 / 1024 / 1024 AS Used,  _LastUpdate AS Dates, ((FreeSpace)*100/(Size+1)) AS PCT FROM HostDiskHistory WHERE Hostname = @Hostname AND DeviceID=@DeviceID AND _LastUpdate > DATEADD(Day,-30,GETDATE()) ORDER BY _lastUpdate">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:ControlParameter Name="DeviceID" ControlID="lblDeviceID" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

<asp:SqlDataSource ID="HostDiskHistory2" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
    SelectCommand="SELECT AVG(FreeSpace) / 1024 / 1024 / 2014 Freespace, AVG(Size) / 1024 / 1024 / 2014 Size, AVG((Size-FreeSpace) / 2014 / 1024 / 1024) AS Used, Min(_lastUpdate) AS Dates ,AVG(((FreeSpace)*100/(Size+1))) AS PCT FROM HostDiskHistory WHERE Hostname = @Hostname AND DeviceID=@DeviceID AND _LastUpdate > DATEADD(Month,-12,GETDATE()) GROUP BY DATEPART(Year,_LastUpdate), DATEPART(Month,_LastUpdate) ORDER BY MIN(_lastUpdate)">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:ControlParameter Name="DeviceID" ControlID="lblDeviceID" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>

<asp:SqlDataSource ID="HostDiskHistory3" runat="server" ConnectionString="<%$ ConnectionStrings:DSVAsset %>" CancelSelectOnNullParameter="true" 
    SelectCommand="SELECT AVG(FreeSpace) / 1024 / 1024 / 2014 Freespace, AVG(Size) / 1024 / 1024 / 2014 Size, AVG((Size-FreeSpace) / 2014 / 1024 / 1024) AS Used, Min(_lastUpdate) AS Dates ,AVG(((FreeSpace)*100/(Size+1))) AS PCT FROM HostDiskHistory WHERE Hostname = @Hostname AND DeviceID=@DeviceID AND _LastUpdate > DATEADD(Month,-6,GETDATE()) GROUP BY DATEPART(Week,_LastUpdate) ORDER BY MIN(_lastUpdate)">
    <SelectParameters>
        <asp:ControlParameter Name="Hostname" ControlID="lblHostname" PropertyName="text" ConvertEmptyStringToNull="true" />
        <asp:ControlParameter Name="DeviceID" ControlID="lblDeviceID" PropertyName="text" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>
