Sub RemoveUglyInfo()
    Dim Ns As Outlook.NameSpace
    Dim currentExplorer As Explorer
    Dim selection As selection
    Dim obj As Object
    
    Set Ns = Application.GetNamespace("MAPI")
    Set currentExplorer = Application.ActiveExplorer
    Set selection = currentExplorer.selection
    
    For Each obj In selection
        obj.PropertyAccessor.SetProperty "http://schemas.microsoft.com/mapi/proptag/0x10810003", 0
    Next
End Sub