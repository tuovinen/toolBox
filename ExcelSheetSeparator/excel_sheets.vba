Dim customerCollection As Collection

Function HandleCustomerName(c) As String
    'Korvaa ei-halutut merkit merkit. Lisää tarvittaessa uusia syntaksilla:
    'c = Replace(c, "[korvattava teksti]", "[uusi teksti]")
    'HUOM! Lisäys viimeisimmän "c = Replace( ..." -rivin alle ennen " LCase(c)-metodin käyttöä.
    
    c = Replace(c, "(", "")
    c = Replace(c, ")", "")
    c = Replace(c, "/", "")
    c = Replace(c, "\", "")
    c = Replace(c, "0", "")
    c = Replace(c, "%", "")
    c = Replace(c, "ALV", "")
    c = Replace(c, "  ", " ")
    c = Replace(c, "   ", " ")
    c = Trim(c)
    
    'UUDET SÄÄNNÖT TÄNNE
    
    c = LCase(c)
    HandleCustomerName = c
End Function

Function HandlePeriod(p) As String
    'Muokkaa laskutuskauden formaatista kenoviivan pois
    p = Replace(p, "/", "_")
    HandlePeriod = p
End Function

Function BuildFileName(path, period, customerName, Optional dc) As String
    'Muodostaa tiedostonimen
     If dc > 1 Then
        c = customerName & dc
        'Debug.Print customerName
    Else
        c = customerName
    End If
    BuildFileName = path & "liikenneraportti_" & period & "_" & c
End Function

Function BuildSheetName(customerName, period, Optional dc) As String
    'Excelin välilehden nimen pituus rajattu. Funktio lyhentää palveluntuottajan nimeä tarpeeksi säilyttäen laskutuskauden.
    If dc > 1 Then
        c = customerName & "_" & dc
        'Debug.Print customerName
    Else
        c = customerName
    End If
    
    If Len(c) + Len(period) > 30 Then
        c = Left(c, 30 - Len(period))
    End If
    
    BuildSheetName = c & "_" & period
    
End Function

Sub MoveSheets()
    'Asiakkaat ja tiedostot talteen (@GDPR handler!)
    
    Set customerCollection = New Collection
    
    Dim source_file_name As String
    Dim source_file_path As String
    Dim destination_file_name As String
    Dim destination_file_path As String
    Dim period As String
    Dim customer As String
    Dim fname As String
    Dim sheetname As String
    Dim wb As Workbook
    Dim lastRowIndex As Integer
    Dim duplicateCounter As Integer
     
    source_file_path = "Z:\ROOT\Raportit\WHEEL\"
    source_file_name = Dir$(source_file_path & "SMSX_*.xlsx")
    Set wb = Workbooks.Open(source_file_path & source_file_name)
    destination_file_path = "Z:\ROOT\Raportit\WHEEL\dest\"
    output_file_path = "Z:\ROOT\Raportit\WHEEL\log\"

    Application.DisplayAlerts = False
    Application.ScreenUpdating = False
    
    'Progress bar
    UserForm1.ProgressBar1.Value = UserForm1.ProgressBar1.Min
    UserForm1.ProgressBar1.Max = wb.Worksheets.Count
    UserForm1.Show vbModeless
    
    For Each xWs In wb.Sheets
        duplicateCounter = 1
        
        '-------Sivunumerorivin poisto 12.5.2017-------
        'Viimeinen rivi, jossa dataa sarakkeessa H
        With xWs
            lastRowIndex = .Cells(.Rows.Count, "H").End(xlUp).Row
        End With
        
        'Poistaa "sivunumerorivit"
        xWs.Rows(lastRowIndex).EntireRow.Delete
        xWs.Rows(lastRowIndex).EntireRow.Delete
        '-----------------------------------------------
        
        'Poistaa giffin
        xWs.Shapes(1).Delete
               
        'Nimi ja kausi
        customer = HandleCustomerName(xWs.Range("A5").Value)
        period = HandlePeriod(xWs.Range("I5").Value)
        
        On Error GoTo NameErrorHandler:
            'Sheetin nimi
            xWs.Name = BuildSheetName(customer, period, duplicateCounter)
           
            'Uuden tiedoston nimi
            fname = BuildFileName(destination_file_path, period, customer, duplicateCounter)
        On Error GoTo 0

        
        'Valitsee sheetistä solun A1 asiantuntijan toivomuksesta (@backlog 1.4.2019)
        xWs.Select
        xWs.Range("A1").Select
        
        'Kopio sheetistä ja tallennus kohteeseen
        xWs.Copy
        Application.ActiveWorkbook.SaveAs Filename:=fname & ".xlsx"
        Application.ActiveWorkbook.Close False
        
        'ProgressBar update
        UserForm1.ProgressBar1.Value = UserForm1.ProgressBar1.Value + 1
        
        '----------------------------------------------------------------
        'Add to collection
        timeStamp = Format(Now(), "yyyymmddhhmmss")
        
        createString = fname & ".xlsx" & ";" & customer & ";" & period & ";" & timeStamp
        Debug.Print createString
        customerCollection.Add createString
        '----------------------------------------------------------------
        
    Next
    
    '----------------------------------------------------------------
    Close #1
    Open output_file_path & "output.csv" For Output As #1
    For i = 1 To customerCollection.Count
        Print #1, customerCollection.Item(i)
    Next i
    Close #1
    '----------------------------------------------------------------
    

    Application.DisplayAlerts = True
    Application.ScreenUpdating = True
    wb.Close False
    
    UserForm1.Hide
    'Unload Me
    
    Exit Sub
NameErrorHandler:
    duplicateCounter = duplicateCounter + 1
    Resume

    
End Sub
