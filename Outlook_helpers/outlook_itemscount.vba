Sub Test()
    Dim Ns As Outlook.NameSpace
    Dim objOwner As Outlook.Recipient
    
    Dim olInbox As Outlook.MAPIFolder
    Dim olRoot As Outlook.MAPIFolder
    Dim olTargetFolder As Outlook.MAPIFolder
    
    Set Ns = Application.GetNamespace("MAPI")
    
    'emailaddressplaceholder@domain.com
    Set objOwner = Ns.CreateRecipient("emailaddressplaceholder@domain.com")
    
    objOwner.Resolve
    
    If objOwner.Resolved Then
        Set olInbox = Ns.GetSharedDefaultFolder(objOwner, olFolderInbox)
        Set olRoot = olInbox.Parent
        
        'emailaddressplaceholder@domain.com
        Set olTargetFolder = olInbox

        FolderCrawler olTargetFolder
    End If
End Sub


Sub FolderCrawler(targetFolder As MAPIFolder)

    Dim subFolder As Outlook.MAPIFolder
    Dim linestr As String

    For Each subFolder In targetFolder.folders
        'WriteToFile subFolder.Name
        For Each mitem In subFolder.Items
            If TypeName(mitem) = "MailItem" Then
                linestr = subFolder.Name & ";" & mitem.SenderEmailAddress & ";" & mitem.ReceivedTime
                WriteToFile linestr
            End If
        Next
        
        c = subFolder.folders.Count
        If c <> 0 Then
            FolderCrawler subFolder
        End If
        
    Next
    
End Sub

Sub WriteToFile(line As String)

    Dim fso As Object
    Dim oFile As Object
    
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set oFile = fso.OpenTextFile("Y:\data.txt", 8, True)
    
    oFile.WriteLine line
    Debug.Print line
        
    oFile.Close
    Set fso = Nothing
    Set oFile = Nothing
End Sub
