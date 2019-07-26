Sub ChangeCurrentView()

    Dim oNs As Outlook.NameSpace
    Dim olInbox As Outlook.Folder

    Dim objOwner As Outlook.Recipient
    
    Dim objView As Outlook.View
    Dim objViews As Outlook.Views
    Dim srtView As String
    
    Set oNs = Application.Session
    'Add a valid email address
    Set objOwner = oNs.CreateRecipient("INSERT CORRECT EMAIL ADDRESS")

    objOwner.Resolve
    
    If objOwner.Resolved Then
        Set olInbox = oNs.GetSharedDefaultFolder(objOwner, olFolderInbox)
        Set objViews = olInbox.Views
        Set objView = olInbox.CurrentView

        v.Reset

        'Add a name of the saved view'
        Set objView = vs.Item("NAME_OF_THE_SAVED_VIEW")

        v.Apply
    End If
End Sub