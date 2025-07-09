' VBScript to retrieve the DisplayName of a user from Active Directory

Dim SRV_NAME
SRV_NAME = "dc1.INTRANET.SCHMETTERLING.DE" 

Dim result
Set result = SearchDistinguishedName("bianca gerstl")
If Not result Is Nothing Then
    WScript.Echo "sAMAccountName: " & result("sAMAccountName")
    WScript.Echo "objectSID: " & result("objectSID")
Else
    WScript.Echo "User not found in AD."
End If


Function SearchDistinguishedName(ByVal vSAN)
    Dim oRootDSE, oConnection, oCommand, oRecordSet, dict
    Set oRootDSE = GetObject("LDAP://rootDSE")
    
    Set oConnection = CreateObject("ADODB.Connection")
    oConnection.Open "Provider=ADsDSOObject;"
    
    Set oCommand = CreateObject("ADODB.Command")
    oCommand.ActiveConnection = oConnection
    oCommand.CommandText = "<LDAP://" & oRootDSE.Get("defaultNamingContext") & ">;" & _
        "(&(objectCategory=User)(|(Name=" & vSAN & ")(sAMAccountName=" & vSAN & ")));sAMAccountName,objectSID;subtree"
    
    Set oRecordSet = oCommand.Execute
    On Error Resume Next
    If Not oRecordSet.EOF Then
        Set dict = CreateObject("Scripting.Dictionary")
        dict.Add "sAMAccountName", oRecordSet.Fields("sAMAccountName").Value
        dict.Add "objectSID", SIDtoString(oRecordSet.Fields("objectSID").Value)
        Set SearchDistinguishedName = dict
    Else
        Set SearchDistinguishedName = Nothing
    End If
    On Error GoTo 0
    
    oConnection.Close
    Set oRecordSet = Nothing
    Set oCommand = Nothing
    Set oConnection = Nothing
    Set oRootDSE = Nothing
End Function

' Convert binary SID to string format
Function SIDtoString(ByVal arrSID)
    Dim strSID, i, subAuthorityCount, subAuth, identifierAuthority
    If IsNull(arrSID) Then
        SIDtoString = ""
        Exit Function
    End If
    strSID = "S-"
    strSID = strSID & CStr(AscB(MidB(arrSID, 1, 1))) ' Revision
    subAuthorityCount = AscB(MidB(arrSID, 2, 1))
    identifierAuthority = 0
    For i = 3 To 8
        identifierAuthority = identifierAuthority * 256 + AscB(MidB(arrSID, i, 1))
    Next
    strSID = strSID & "-" & CStr(identifierAuthority)
    For i = 1 To subAuthorityCount
        subAuth = 0
        subAuth = subAuth + AscB(MidB(arrSID, 8 + (i - 1) * 4 + 1, 1))
        subAuth = subAuth + AscB(MidB(arrSID, 8 + (i - 1) * 4 + 2, 1)) * 256
        subAuth = subAuth + AscB(MidB(arrSID, 8 + (i - 1) * 4 + 3, 1)) * 65536
        subAuth = subAuth + AscB(MidB(arrSID, 8 + (i - 1) * 4 + 4, 1)) * 16777216
        strSID = strSID & "-" & CStr(subAuth)
    Next
    SIDtoString = strSID
End Function