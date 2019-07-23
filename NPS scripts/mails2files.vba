' Tallentaa jokaisen valitun sähköpostiviestin tiedostoksi
Sub mails2files()
    Dim currentExplorer As Explorer
    Dim selection As selection
    Dim oMail As Outlook.MailItem
    Dim obj As Object
    Dim sName As String
    Dim oMailBody As String
    
    Dim regEx As New RegExp
    Dim strPattern As String
    
    Set regEx = CreateObject("VBScript.RegExp")
    strPattern = "^Tilausvahvistus no. (\d*)"
    
    With regEx
        .Pattern = strPattern
        .Global = True
    End With
    
    Set currentExplorer = Application.ActiveExplorer
    Set selection = currentExplorer.selection
    
    For Each obj In selection
        Set oMail = obj
        oMailBody = oMail.Body
        
        Set matches = regEx.Execute(oMail.Subject)
        sName = matches(0).SubMatches(0)
        
        Set fs = CreateObject("Scripting.FileSystemObject")
        Set a = fs.CreateTextFile("Y:\npstemp\" & sName, True)
        a.Write (oMail.ReceivedTime & vbNewLine & oMailBody)
        a.Close
    Next
End Sub