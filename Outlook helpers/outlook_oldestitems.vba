Sub SetUp()
    Dim Ns As Outlook.NameSpace
    Dim objOwner As Outlook.Recipient
    
    Dim olInbox As Outlook.MAPIFolder
    Dim olRoot As Outlook.MAPIFolder
    Dim olTargetFolder As Outlook.MAPIFolder
    
    Set Ns = Application.GetNamespace("MAPI")
    
    Set objOwner = Ns.CreateRecipient("emailaddressplaceholder@domain.com")
    
    objOwner.Resolve
    
    If objOwner.Resolved Then
        Set olInbox = Ns.GetSharedDefaultFolder(objOwner, olFolderInbox)
        Set olRoot = olInbox.Parent
        
        Set olTargetFolder = olRoot.folders("TYÖKANSIOT")

        FolderCrawler olTargetFolder, 0
    End If
End Sub

Sub FolderCrawler(folders As MAPIFolder, level As Integer)
    Dim subFolder As Outlook.MAPIFolder

    For Each subFolder In folders.folders
        Set subFolderItems = subFolder.Items
        subFolderItems.Sort "[ReceivedTime]", False
        Set oldestMessage = subFolderItems.GetFirst
        
        oldestMessageType = TypeName(oldestMessage)
        'Debug.Print oldestMessageType
        
        If oldestMessageType = "MailItem" Then
            Debug.Print subFolder.FolderPath & ";" & oldestMessageType & ";" & oldestMessage.ReceivedTime
        End If
        
        If oldestMessageType = "MeetingItem" Then
            Debug.Print subFolder.FolderPath & ";" & oldestMessageType & ";" & oldestMessage.CreationTime
        End If
        
        If oldestMessageType = "PostItem" Then
            Debug.Print subFolder.FolderPath & ";" & oldestMessageType & ";" & oldestMessage.CreationTime & ";" & oldestMessage.LastModificationTime
        End If
        
        If oldestMessageType = "DocumentItem" Then
            Debug.Print subFolder.FolderPath & ";" & oldestMessageType & ";" & oldestMessage.CreationTime
        End If

        'Alikansioiden läpikäynti rekursiivisesti'
        c = subFolder.folders.Count
        If c <> 0 Then
            FolderCrawler subFolder, level + 1
        End If
    Next
End Sub

Sub OutputFormatter(ByVal indentation As Integer, ByVal text As String)
    Debug.Print Replace(Space(indentation), " ", ".") & text
End Sub
