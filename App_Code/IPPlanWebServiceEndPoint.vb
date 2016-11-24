Imports Microsoft.VisualBasic

' http://test.appfabric.dsv.com/fs.documentservice.pod/PODService.svc?WSDL

' Starting Runbook with HTTP Request
' https://blogs.technet.microsoft.com/orchestrator/2012/03/25/starting-runbooks-and-stopping-jobs-using-the-system-center-2012-orchestrator-web-service/

' http://www.laurierhodes.info/?q=node/101


' Basic auth method 1
'Dim Cred As Net.CredentialCache = New Net.CredentialCache()
'Cred.Add(New System.Uri(url), "Basic", New Net.NetworkCredential(Me.EndPoint.username, Me.EndPoint.Password))
'req.Credentials = New Net.CredentialCache()
'req.PreAuthenticate = True

' windows auth
'req.Credentials = System.Net.CredentialCache.DefaultCredentials


' basic auth method 2
'Dim usernamepassword As String = System.Convert.ToBase64String(System.Text.Encoding.GetEncoding("ISO-8859-1").GetBytes(Me.EndPoint.username + ":" + Me.EndPoint.Password))
'req.Headers.Add("Authorization", "Basic " + usernamepassword)

' basic auth method 3
'req.Headers("Authorization") = "Basic " + Convert.ToBase64String(Encoding.Default.GetBytes(String.Format("{0}:{1}", Me.EndPoint.username, Me.EndPoint.Password)))
'req.PreAuthenticate = True

'req.ContentType = "application/xml"
'req.Accept = "application/xml"
'req.MediaType = "application/xml"
'req.Accept = "text/html,application/xhtml+xml,application/xml"

Public Class EndPointMethod
    Public EndPointID As Integer
    Public EndPointTypeID As Integer
    Public EndPointName As String
    Public EnvironmentID As Integer
    Public Path As String
    Public ServerName As String
    Public Port As Integer
    Public AuthType As Integer
    Public Inventory As String
    Public Service As String
    Public username As String
    Public Password As String
    Public Method As String
    Public MethodID As String
    Public Published As Nullable(Of DateTime)
    Public Updated As Nullable(Of DateTime)
    Public Author As String
    Public URL As String
End Class

Public Class IPPlanWebServiceEndPoint

    Public Property EndPoint As EndPointMethod

    Private Function GetDBValue(val As Object) As Object
        If IsDBNull(val) Then Return Nothing Else Return val.ToString()
    End Function

    Private Function setDBValue(val As String) As Object
        If val.Length = 0 Then Return DBNull.Value Else Return val
    End Function

    Private Class WebServiceParameter
        Public Property ID As String
        Public Property Value As String
    End Class

    Private Function GetParameters(EndPointID As Integer, EnvironmentID As Integer, Name As String, Optional Output As Boolean = False) As Dictionary(Of String, WebServiceParameter)
        GetParameters = New Dictionary(Of String, WebServiceParameter)
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand(
                "SELECT * FROM WebServiceEndPointMethodParameters WHERE EndPointID=@EndPointID AND EnvironmentID=@EnvironmentID AND Name=@Name AND Direction=@Direction", Conn)
        cmd.Parameters.AddWithValue("EndPointID", EndPointID)
        cmd.Parameters.AddWithValue("EnvironmentID", EnvironmentID)
        cmd.Parameters.AddWithValue("Name", setDBValue(Name))
        If Output Then
            cmd.Parameters.AddWithValue("Direction", "Out")
        Else
            cmd.Parameters.AddWithValue("Direction", "In")
        End If
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        If reader.Read() Then
            GetParameters.Add(reader("ParameterName"), New WebServiceParameter With {.ID = reader("parameterID"), .Value = Nothing})
        End If
        reader.Close()
        Conn.Close()
        Conn.Dispose()
    End Function

    Private Function GetMethod(EndPointName As String, EnvironmentID As Integer, Method As String) As EndPointMethod
        GetMethod = Nothing
        Dim EndPointID As Integer
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand(
                "SELECT EP.EndPointID,EP.EndPointTypeID,EP.EndPointName, EPS.Path, EPS.ServerName, EPS.Service ,EPS.Username, EPS.password, EPME.Name AS Method, EPME.ID AS MethodID, EPME.Published, EPME.Updated, EPME.Author, EPS.Port, EPS.AuthType, EPT.Inventory, EPM.MappedEnvironmentID AS EnvironmentID, EPME.url" + _
                "  FROM WebServiceEndPoints AS EP" + _
                "  INNER JOIN WebServiceEndPointsMap AS EPM ON EPM.EndPointID = EP.EndPointID" + _
                "  INNER JOIN WebServiceEndPointsServers AS EPS ON EPS.EndPointID = EP.EndPointID AND EPS.EnvironmentID = EPM.MappedEnvironmentID" + _
                "  INNER JOIN WebServiceEndPointType AS EPT ON EPT.EndPointTypeID = EP.EndPointTypeID" + _
                "  LEFT OUTER JOIN WebServiceEndPointMethods AS EPME ON EPME.EndPointID = EP.EndPointID AND EPME.EnvironmentID = EPM.MappedEnvironmentID AND EPME.Name = @Method" + _
                " WHERE ((EP.EndPointName=@EndPointName AND @EndPointID IS NULL) OR (EP.EndPointID = @EndPointID AND @EndPointName IS NULL)) AND EPM.EnvironmentID = @EnvironmentID AND (@Method = '_refresh' OR EPME.Name IS NOT NULL)" _
                                               , Conn)
        If Integer.TryParse(EndPointName, EndPointID) Then
            cmd.Parameters.AddWithValue("EndPointName", DBNull.Value)
            cmd.Parameters.AddWithValue("EndPointID", EndPointID)
        Else
            cmd.Parameters.AddWithValue("EndPointName", setDBValue(EndPointName))
            cmd.Parameters.AddWithValue("EndPointID", DBNull.Value)
        End If
        cmd.Parameters.AddWithValue("EnvironmentID", setDBValue(EnvironmentID))
        cmd.Parameters.AddWithValue("Method", setDBValue(Method))
        Dim reader As SqlDataReader = cmd.ExecuteReader()
        If reader.Read() Then
            GetMethod = New EndPointMethod()
            GetMethod.EndPointID = reader("EndPointID")
            GetMethod.EndPointName = reader("EndPointName")
            GetMethod.EndPointTypeID = reader("EndPointTypeID")
            GetMethod.Method = GetDBValue(reader("Method"))
            GetMethod.MethodID = GetDBValue(reader("MethodID"))
            GetMethod.Password = GetDBValue(reader("Password"))
            GetMethod.Path = GetDBValue(reader("Path"))
            GetMethod.ServerName = GetDBValue(reader("Servername"))
            GetMethod.Service = GetDBValue(reader("Service"))
            GetMethod.username = GetDBValue(reader("Username"))
            GetMethod.Published = IIf(IsDBNull(reader("published")), Nothing, reader("published"))
            GetMethod.Updated = IIf(IsDBNull(reader("Updated")), Nothing, reader("Updated"))
            GetMethod.Author = GetDBValue(reader("Author"))
            GetMethod.Inventory = GetDBValue(reader("Inventory"))
            GetMethod.Port = GetDBValue(reader("port"))
            GetMethod.AuthType = GetDBValue(reader("AuthType"))
            GetMethod.EnvironmentID = GetDBValue(reader("EnvironmentID"))
            GetMethod.URL = GetDBValue(reader("url"))
        End If
        reader.Close()
        Conn.Close()
        Conn.Dispose()
    End Function

    Private Sub DeleteWebServiceEndPointMethods(EndPointID As Integer, EnvironmentID As Integer)
        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand()
        cmd.Connection = Conn
        cmd.CommandText = "DELETE FROM WebServiceEndPointMethodParameters WHERE EndPointID=@EndPointID AND EnvironmentID=@EnvironmentID"
        cmd.Parameters.AddWithValue("EndPointID", setDBValue(EndPointID))
        cmd.Parameters.AddWithValue("EnvironmentID", setDBValue(EnvironmentID))
        cmd.ExecuteNonQuery()
        cmd.CommandText = "DELETE FROM WebServiceEndPointMethods WHERE EndPointID=@EndPointID AND EnvironmentID=@EnvironmentID"
        cmd.ExecuteNonQuery()
        Conn.Close()
        Conn.Dispose()
    End Sub

    Private Function GetWebServiceXML(url As String, Method As String, Optional Envelope As String = "") As System.Xml.XmlDocument
        Dim req As System.Net.HttpWebRequest = Net.HttpWebRequest.Create(url)
        req.Method = Method.ToUpper()
        If Me.EndPoint.AuthType = 0 Then ' Basic Authentication
            Dim Sstr As System.Security.SecureString = New System.Security.SecureString()
            For Each c As Char In Me.EndPoint.Password
                Sstr.AppendChar(c)
            Next
            Sstr.MakeReadOnly()
            Dim cred As System.Net.NetworkCredential = New System.Net.NetworkCredential(Me.EndPoint.username, Sstr)
            Dim CredCache As System.Net.CredentialCache = New Net.CredentialCache()
            CredCache.Add(New Uri(url, UriKind.Absolute), "Basic", cred)
            req.Credentials = CredCache
            req.PreAuthenticate = True
        End If

        If Envelope <> "" Then
            req.ContentType = "application/atom+xml"
            Using stm As System.IO.Stream = req.GetRequestStream()
                Using stmw As New System.IO.StreamWriter(stm)
                    stmw.Write(Envelope)
                End Using
            End Using
        End If

        GetWebServiceXML = New System.Xml.XmlDocument()
        Try
            Dim response As Net.WebResponse = req.GetResponse()
            GetWebServiceXML.Load(response.GetResponseStream())
        Catch ex As System.Net.WebException
            Dim sr As System.IO.StreamReader = New IO.StreamReader(ex.Response.GetResponseStream())
            Dim test As String = sr.ReadToEnd()
            GetWebServiceXML.CreateAttribute("HTTPError").InnerText = ex.Message
            GetWebServiceXML.CreateAttribute("HTTPUrl").InnerText = req.RequestUri.AbsolutePath
            GetWebServiceXML.CreateAttribute("HTTPResponse").InnerText = test
        End Try
    End Function

    Private Sub ReFresh()
        Dim soap As String = "<?xml version=""1.0"" encoding=""utf-8""?>" + _
                             "<soap:Envelope xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""" + _
                             " xmlns:xsd=""http://www.w3.org/2001/XMLSchema""" + _
                             " xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">""" + _
                             "<soap:Body>" + _
                             "</soap:Body>" + _
                             "</soap:Envelope>"

        Dim url As String = String.Format("http://{0}:{1}/{2}/{3}", Me.EndPoint.ServerName, Me.EndPoint.Port, Me.EndPoint.Path, Me.EndPoint.Service)
        Dim XMLDoc As System.Xml.XmlDocument = GetWebServiceXML(String.Format("{0}{1}", url, Me.EndPoint.Inventory), "GET")

        Dim Conn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("DSVAsset").ConnectionString.ToString())
        Conn.Open()
        Dim cmd As SqlCommand = New SqlCommand(
                "INSERT INTO WebServiceEndPointMethods(EndPointID,EnvironmentID,ID,Name,Published,Updated,Author,url) VALUES(@EndPointID,@EnvironmentID,@ID,@Name,@Published,@Updated,@Author,@Url)", Conn)
        cmd.Parameters.AddWithValue("EndPointID", setDBValue(Me.EndPoint.EndPointID))
        cmd.Parameters.AddWithValue("EnvironmentID", setDBValue(Me.EndPoint.EnvironmentID))
        cmd.Parameters.Add("ID", SqlDbType.VarChar)
        cmd.Parameters.Add("Name", SqlDbType.VarChar)
        cmd.Parameters.Add("Published", SqlDbType.DateTime)
        cmd.Parameters.Add("Updated", SqlDbType.DateTime)
        cmd.Parameters.Add("Author", SqlDbType.VarChar)
        cmd.Parameters.Add("Url", SqlDbType.VarChar)

        Dim pcmd As SqlCommand = New SqlCommand(
                "INSERT INTO WebServiceEndPointMethodParameters(EndPointID,EnvironmentID,Name,ParameterName,ParameterType,Direction,Description,ParameterID) VALUES(@EndPointID,@EnvironmentID,@Name,@ParameterName,@ParameterType,@Direction,@Description,@ParameterID)", Conn)
        pcmd.Parameters.AddWithValue("EndPointID", setDBValue(Me.EndPoint.EndPointID))
        pcmd.Parameters.AddWithValue("EnvironmentID", setDBValue(Me.EndPoint.EnvironmentID))
        pcmd.Parameters.Add("name", SqlDbType.VarChar)
        pcmd.Parameters.Add("ParameterName", SqlDbType.VarChar)
        pcmd.Parameters.Add("ParameterType", SqlDbType.VarChar)
        pcmd.Parameters.Add("Direction", SqlDbType.VarChar)
        pcmd.Parameters.Add("Description", SqlDbType.VarChar)
        pcmd.Parameters.Add("ParameterID", SqlDbType.VarChar)

        Select Case Me.EndPoint.EndPointTypeID
            Case 1
                Dim List As System.Xml.XmlNodeList = DirectCast(XMLDoc.GetElementsByTagName("feed")(0), System.Xml.XmlElement).GetElementsByTagName("entry")
                If List.Count > 0 Then
                    DeleteWebServiceEndPointMethods(Me.EndPoint.EndPointID, Me.EndPoint.EnvironmentID)
                    For Each Node As System.Xml.XmlElement In List
                        Dim methodurl As String = Node.GetElementsByTagName("id")(0).InnerText()
                        cmd.Parameters("ID").Value = methodurl.Split("'")(1)
                        cmd.Parameters("name").Value = Node.GetElementsByTagName("title")(0).InnerText()
                        cmd.Parameters("published").Value = Node.GetElementsByTagName("published")(0).InnerText()
                        cmd.Parameters("Updated").Value = Node.GetElementsByTagName("updated")(0).InnerText()
                        cmd.Parameters("Author").Value = Node.GetElementsByTagName("author")(0).InnerText()
                        cmd.Parameters("url").Value = String.Format("{0}/{1}", url, "Jobs")
                        cmd.ExecuteNonQuery()

                        pcmd.Parameters("Name").Value = cmd.Parameters("name").Value
                        Dim XMLParameter = GetWebServiceXML(methodurl + "/Parameters", "GET")
                        Dim ParameterList As System.Xml.XmlNodeList = DirectCast(XMLParameter.GetElementsByTagName("feed")(0), System.Xml.XmlElement).GetElementsByTagName("entry")
                        If ParameterList.Count > 0 Then
                            For Each pNode As System.Xml.XmlElement In ParameterList
                                Dim t = pNode.GetElementsByTagName("content")(0).ChildNodes(0)

                                pcmd.Parameters("ParameterName").Value = DirectCast(pNode.GetElementsByTagName("content")(0).ChildNodes(0), System.Xml.XmlElement).GetElementsByTagName("d:Name")(0).InnerText
                                pcmd.Parameters("ParameterType").Value = DirectCast(pNode.GetElementsByTagName("content")(0).ChildNodes(0), System.Xml.XmlElement).GetElementsByTagName("d:Type")(0).InnerText
                                pcmd.Parameters("Direction").Value = DirectCast(pNode.GetElementsByTagName("content")(0).ChildNodes(0), System.Xml.XmlElement).GetElementsByTagName("d:Direction")(0).InnerText
                                pcmd.Parameters("Description").Value = DirectCast(pNode.GetElementsByTagName("content")(0).ChildNodes(0), System.Xml.XmlElement).GetElementsByTagName("d:Description")(0).InnerText
                                pcmd.Parameters("ParameterID").Value = DirectCast(pNode.GetElementsByTagName("content")(0).ChildNodes(0), System.Xml.XmlElement).GetElementsByTagName("d:Id")(0).InnerText
                                pcmd.ExecuteNonQuery()
                            Next
                        End If
                    Next
                End If
            Case 2
                cmd.Parameters("published").Value = Now
                cmd.Parameters("Updated").Value = Now

                'Dim List As System.Xml.XmlNodeList = DirectCast(DirectCast(DirectCast(XMLDoc.GetElementsByTagName("wsdl:definitions")(0), System.Xml.XmlElement).GetElementsByTagName("wsdl:types")(0), System.Xml.XmlElement).GetElementsByTagName("xs:schema")(0), System.Xml.XmlElement).GetElementsByTagName("xs:element")
                Dim nsmanager As System.Xml.XmlNamespaceManager = New System.Xml.XmlNamespaceManager(XMLDoc.NameTable)
                nsmanager.AddNamespace("wsdl", "http://schemas.xmlsoap.org/wsdl/")
                nsmanager.AddNamespace("xs", "http://www.w3.org/2001/XMLSchema")

                Dim TargetNamespace As String = DirectCast(XMLDoc.GetElementsByTagName("wsdl:definitions")(0), System.Xml.XmlElement).GetAttribute("xmlns:tns")

                Dim List As System.Xml.XmlNodeList = XMLDoc.SelectNodes("/wsdl:definitions/wsdl:types/xs:schema/xs:element", nsmanager)
                If List.Count > 0 Then
                    DeleteWebServiceEndPointMethods(Me.EndPoint.EndPointID, Me.EndPoint.EnvironmentID)
                    For Each node As System.Xml.XmlElement In List
                        If DirectCast(node.ParentNode, System.Xml.XmlElement).GetAttribute("targetNamespace") = TargetNamespace And node.HasChildNodes Then
                            cmd.Parameters("ID").Value = TargetNamespace
                            cmd.Parameters("name").Value = node.GetAttribute("name")
                            cmd.Parameters("Author").Value = DBNull.Value
                            cmd.Parameters("url").Value = String.Format("{0}/{1}.asmx", url, node.GetAttribute("name"))
                            cmd.ExecuteNonQuery()

                            pcmd.Parameters("Name").Value = cmd.Parameters("name").Value
                            pcmd.Parameters("ParameterID").Value = DBNull.Value
                            For Each pnode As System.Xml.XmlElement In node.ChildNodes(0).ChildNodes(0).ChildNodes()
                                pcmd.Parameters("ParameterName").Value = pnode.GetAttribute("name")
                                pcmd.Parameters("ParameterType").Value = pnode.GetAttribute("type")
                                If pcmd.Parameters("ParameterType").Value.ToString().StartsWith("xs:") Then pcmd.Parameters("ParameterType").Value = pcmd.Parameters("ParameterType").Value.ToString().Substring(3)
                                pcmd.Parameters("Direction").Value = DBNull.Value
                                pcmd.Parameters("Description").Value = DBNull.Value
                                pcmd.ExecuteNonQuery()
                            Next
                        End If
                    Next
                End If
        End Select
        Conn.Close()
        Conn.Dispose()
    End Sub


    Private Sub Test()
        Dim soap As String = "<?xml version=""1.0"" encoding=""utf-8""?>" + _
                             "<soap:Envelope xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""" + _
                             " xmlns:xsd=""http://www.w3.org/2001/XMLSchema""" + _
                             " xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">""" + _
                             "<soap:Body>" + _
                             "<Register xmlns=""http://tempuri.org/"">" + _
                             "<id>123</id>" + _
                             "<data1>string</data1>" + _
                             "</Register>" + _
                             "</soap:Body>" + _
                             "</soap:Envelope>"

        Dim url As String = String.Format("http://{0}/{1}/{2}", Me.EndPoint.ServerName, Me.EndPoint.Path, Me.EndPoint.Service)
        url = "http://i04250:81/Orchestrator2012/Orchestrator.svc//Runbooks"

        Dim req As System.Net.HttpWebRequest = Net.HttpWebRequest.Create(url)

        req.Headers.Add("SOAPAction", """http://tempuri.org/Register\""")
        req.ContentType = "text/xml;charset=\""utf-8\"""
        req.Accept = "text/xml"
        req.Method = "POST"

        Using stm As System.IO.Stream = req.GetRequestStream()
            Using stmw As New System.IO.StreamWriter(stm)
                stmw.Write(soap)
            End Using
        End Using

        Dim response As Net.WebResponse = req.GetResponse()
        Dim XMLDoc As System.Xml.XmlDocument = New System.Xml.XmlDocument()
        XMLDoc.LoadXml(response.ToString())
        response = Nothing
    End Sub

    '<Data><Parameter><ID><{guid}</ID><Value><Hello></Value></Parameter><Parameter><ID>{guid}</ID><Value>World</Value></Parameter></Data>
    Public Function Invoke(Params As Dictionary(Of String, String), Optional WaitForResult As Boolean = False) As Dictionary(Of String, String)
        Invoke = New Dictionary(Of String, String)
        If EndPoint.EndPointTypeID = 1 Then
            Dim ParmIDs As Dictionary(Of String, WebServiceParameter) = GetParameters(Me.EndPoint.EndPointID, Me.EndPoint.EnvironmentID, Me.EndPoint.Method)
            Dim soap As String = "<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?>" + _
                                 "<entry xmlns:d=""http://schemas.microsoft.com/ado/2007/08/dataservices""" + _
                                 " xmlns:m=""http://schemas.microsoft.com/ado/2007/08/dataservices/metadata""" + _
                                 " xmlns=""http://www.w3.org/2005/Atom"">" + _
                                 "<content type=""application/xml"">" + _
                                 "<m:properties>" + _
                                 "<d:RunbookId type=""Edm.Guid"">{{{0}}}</d:RunbookId>" + _
                                 "<d:Parameters>" + _
                                 "{1}" + _
                                 "</d:Parameters>" + _
                                 "</m:properties>" + _
                                 "</content>" + _
                                 "</entry>"
            Dim str As String = ""

            For Each Parm In Params
                str = String.Format("{0}&lt;Parameter&gt;&lt;ID&gt;{{{1}}}&lt;/ID&gt;&lt;Value&gt;{2}&lt;/Value&gt;&lt;/Parameter&gt;", str, ParmIDs.Item(Parm.Key).ID, Parm.Value)
            Next
            str = String.Format("&lt;Data&gt;{0}&lt;/Data&gt;", str)
            soap = String.Format(soap, Me.EndPoint.MethodID, str)

            Dim XMLDoc As System.Xml.XmlDocument = GetWebServiceXML(Me.EndPoint.URL, "POST", soap)
            Dim nsmanager As System.Xml.XmlNamespaceManager = New System.Xml.XmlNamespaceManager(XMLDoc.NameTable)
            nsmanager.AddNamespace("ipplan", XMLDoc.ChildNodes(1).GetNamespaceOfPrefix(""))
            nsmanager.AddNamespace("d", "http://schemas.microsoft.com/ado/2007/08/dataservices")
            nsmanager.AddNamespace("m", "http://schemas.microsoft.com/ado/2007/08/dataservices/metadata")
            While WaitForResult
                Dim joburl As String = XMLDoc.SelectSingleNode("ipplan:entry/ipplan:id", nsmanager).InnerText
                Dim jobid As String = XMLDoc.SelectSingleNode("ipplan:entry/ipplan:content/m:properties/d:Id", nsmanager).InnerText
                Dim status As String = XMLDoc.SelectSingleNode("ipplan:entry/ipplan:content/m:properties/d:Status", nsmanager).InnerText
                WaitForResult = (status = "Pending" Or status = "Running")
                If WaitForResult Then
                    Threading.Thread.Sleep(500)
                    XMLDoc = GetWebServiceXML(joburl, "GET")
                End If
                If Not WaitForResult Then
                    'Instances
                    XMLDoc = GetWebServiceXML(joburl + "/Instances", "GET")
                    Dim instanceLink As String = XMLDoc.SelectSingleNode("ipplan:feed/ipplan:entry/ipplan:id", nsmanager).InnerText + "/Parameters"
                    XMLDoc = GetWebServiceXML(instanceLink, "GET")
                    Dim resDoc As System.Xml.XmlDocument = New System.Xml.XmlDocument()
                    Dim docNode As System.Xml.XmlNode = resDoc.CreateXmlDeclaration("1.0", "UTF-8", Nothing)
                    resDoc.AppendChild(docNode)
                    Dim ListNode As System.Xml.XmlNode = resDoc.CreateElement("List")
                    resDoc.AppendChild(ListNode)
                    For Each Entry As System.Xml.XmlNode In XMLDoc.SelectNodes("ipplan:feed/ipplan:entry", nsmanager)
                        Dim Varname As String = Entry.SelectSingleNode("ipplan:content/m:properties/d:Name", nsmanager).InnerText
                        Dim VarValue As String = Entry.SelectSingleNode("ipplan:content/m:properties/d:Value", nsmanager).InnerText
                        Invoke.Add(Varname, VarValue)
                    Next
                End If
            End While
        Else
            Return Nothing
        End If
    End Function


    Public Sub New(EndPointNameOrID As String, EnvironmentID As Integer, Method As String)
        Me.EndPoint = GetMethod(EndPointNameOrID, EnvironmentID, Method)
        If Method.ToLower() = "_refresh" Then
            ReFresh()
        End If
    End Sub


End Class
