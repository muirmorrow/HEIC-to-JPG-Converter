Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Define the path to ImageMagick Executable
$magickPath = "C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\magick.exe"

# Define the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "HEIC to JPG Converter"
$form.Size = New-Object System.Drawing.Size(400,220)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"

# Add a label
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(300,20)
$label.Text = "Select the .HEIC file to convert to .JPG:"
$form.Controls.Add($label)

# Add a file dialog
$fileDialog = New-Object System.Windows.Forms.OpenFileDialog
$fileDialog.InitialDirectory = "c:\"
$fileDialog.Filter = "HEIC files (*.heic)|*.heic|All files (*.*)|*.*"
$fileDialog.Multiselect = $false

# Add a button to select file
$buttonBrowse = New-Object System.Windows.Forms.Button
$buttonBrowse.Location = New-Object System.Drawing.Point(310,20)
$buttonBrowse.Size = New-Object System.Drawing.Size(70,20)
$buttonBrowse.Text = "Browse"
$buttonBrowse.Add_Click({
    [void]$fileDialog.ShowDialog()
    if ($fileDialog.FileName -ne "") {
        $textBox.Text = $fileDialog.FileName
    }
})
$form.Controls.Add($buttonBrowse)

# Add a text box to show selected file
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,50)
$textBox.Size = New-Object System.Drawing.Size(370,20)
$form.Controls.Add($textBox)

# Add a button to perform conversion
$buttonConvert = New-Object System.Windows.Forms.Button
$buttonConvert.Location = New-Object System.Drawing.Point(150,80)
$buttonConvert.Size = New-Object System.Drawing.Size(100,30)
$buttonConvert.Text = "Convert"
$buttonConvert.Add_Click({
    if ($fileDialog.FileName -ne "") {
        $heicFile = $fileDialog.FileName
        $jpgFile = [System.IO.Path]::ChangeExtension($heicFile, ".jpg")
        
        try {
            New-Item -ItemType Directory -Path "$env:USERPROFILE\Documents\HEIC to JPG Converter Logs" -Force
            & $magickPath convert $heicFile $jpgFile 2>&1 | Out-File -FilePath "$env:USERPROFILE\Documents\HEIC to JPG Converter Logs\conversion_log.txt" -Append
            [System.Windows.Forms.MessageBox]::Show("Conversion successful: File located in $heicFile has been converted and saved to $jpgFile", "Success", "OK", [System.Windows.Forms.MessageBoxIcon]::Information)
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error converting $heicFile to $jpgFile : $_", "Error", "OK", [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a .HEIC file to convert.", "Error", "OK", [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})
$form.Controls.Add($buttonConvert)

# Display the form
$form.ShowDialog() | Out-Null
