cls
$uri = "http://ipplanv4.stj.dsv.com/ExtProviders/WSTest.asmx?WSDL"
$ns = "http://dsv.com/ipplan/ExtProviders/WSTest"
$proxy = New-WebServiceProxy -Uri $uri -UseDefaultCredential

## $proxy | Get-Member -MemberType Method 
#$items = Get-ChildItem c:\temp | select PSChildName,PSDrive,BaseName,Mode,Name,Parent,Exists,Root,FullName,Extension,CreationTime,CreationTimeUtc,LastAccessTime,LastAccessTimeUtc,LastWriteTime,LastWriteTimeUtc,Attributes 
$items = Get-ChildItem c:\temp

##$proxy.BulkInsertPSDir($items)
##$proxy.InsertPSDir([System.IO.FileSystemInfo]$items[0])

$PSDirectoyyType = $proxy.GetPSdirectoryType()
$a = New-Object $PSDirectoyyType.GetType()
$fi = [System.IO.FileSystemInfo]$items[0]
$proxy.test($fi)

