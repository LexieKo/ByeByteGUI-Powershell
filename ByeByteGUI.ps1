#----------[Initialisations]----------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


#----------[Variables]--------


#----------[Form]----------

$form = New-Object System.Windows.Forms.Form

$form.ClientSize = "500, 350"
$form.text = "ByeByteGUI"


#----------[Elements]--------

# Label for text box - File path

$filePathLabel = New-Object System.Windows.Forms.Label

$filePathLabel.Text = "File path:"
$filePathLabel.Location = New-Object System.Drawing.Point(20,10)
$filePathLabel.Size = New-Object System.Drawing.size(280,20)


# Text box for inputting file path

$filePathBox = New-Object System.Windows.Forms.TextBox

$filePathBox.AutoSize = $true
$filePathBox.Width = 250
$filePathBox.Height = 10
$filePathBox.Location = New-Object System.Drawing.Point(20,30)


# Browse files button

$browseFilesButton = New-Object System.Windows.Forms.Button
$browseFilesButton.AutoSize = $true
$browseFilesButton.Height = 10
$browseFilesButton.Text = "Browse"
$browseFilesButton.Location = New-Object System.Drawing.Point(280,30)


# Label for text box - New file name

$newFileLabel = New-Object System.Windows.Forms.Label

$newFileLabel.text = "New file name:"
$newFileLabel.Location = New-Object System.Drawing.Point(20,70)
$newFileLabel.Size = New-Object System.Drawing.size(280,20)


# Text box for inputting new file name

$newFileBox = New-Object System.Windows.Forms.TextBox

$newFileBox.AutoSize = $true
$newFileBox.Text = "mosh.jpg"
$newFileBox.Width = 250
$newFileBox.Height = 10
$newFileBox.Location = New-Object System.Drawing.Point(20,90)

# Checkobox for opening new file after running script

$openFileCheckBox = New-Object System.Windows.Forms.CheckBox

$openFileCheckBox.text = "Open new file"
$openFileCheckBox.Location = New-Object System.Drawing.Point(20, 120)


# Radio buttons for selecting method

$destroyRadio = New-Object System.Windows.Forms.RadioButton

$destroyRadio.Text = "Destroy"
$destroyRadio.Width = 75
$destroyRadio.Checked = $true
$destroyRadio.Location = New-Object System.Drawing.Point(20,150)


$shuffleRadio = New-Object System.Windows.Forms.RadioButton

$shuffleRadio.Text = "Shuffle"
$shuffleRadio.Width = 75
$shuffleRadio.Location = New-Object System.Drawing.Point(100,150)


# Label for text box - Minimum and maximum

$minLabel = New-Object System.Windows.Forms.Label

$minLabel.Text = "Minimum:"
$minLabel.Width = 60
$minLabel.Location = New-Object System.Drawing.Point(20,182)


$maxLabel = New-Object System.Windows.Forms.Label

$maxLabel.Text = "Maximum:"
$maxLabel.Width = 60
$maxLabel.Location = New-Object System.Drawing.Point(20,212)


# Text boxes for inputting minimum and maximum values

$minBox = New-Object System.Windows.Forms.TextBox

$minBox.AutoSize = $true
$minBox.Width = 50
$minBox.Height = 10
$minBox.Location = New-Object System.Drawing.Point(80,180)


$maxBox = New-Object System.Windows.Forms.TextBox

$maxBox.AutoSize = $true
$maxBox.Width = 50
$maxBox.Height = 10
$maxBox.Location = New-Object System.Drawing.Point(80,210)


# Label for text box - Minimum and maximum chunk

$minChunkLabel = New-Object System.Windows.Forms.Label

$minChunkLabel.Text = "Minimum chunk:"
$minChunkLabel.Width = 100
$minChunkLabel.Location = New-Object System.Drawing.Point(150,182)
$minChunkLabel.Hide()


$maxChunkLabel = New-Object System.Windows.Forms.Label

$maxChunkLabel.Text = "Maximum chunk:"
$maxChunkLabel.Width = 100
$maxChunkLabel.Location = New-Object System.Drawing.Point(150,212)
$maxChunkLabel.Hide()


# Text boxes for inputting minimum and maximum chunk size values

$minChunkBox = New-Object System.Windows.Forms.TextBox

$minChunkBox.AutoSize = $true
$minChunkBox.Width = 50
$minChunkBox.Height = 10
$minChunkBox.Location = New-Object System.Drawing.Point(250,180)
$minChunkBox.Hide()


$maxChunkBox = New-Object System.Windows.Forms.TextBox

$maxChunkBox.AutoSize = $true
$maxChunkBox.Width = 50
$maxChunkBox.Height = 10
$maxChunkBox.Location = New-Object System.Drawing.Point(250,210)
$maxChunkBox.Hide()


# Apply button

$apply = New-Object System.Windows.Forms.Button

$apply.AutoSize = $true
$apply.Text = "Apply"
$apply.Location = New-Object System.Drawing.Point(20,300)

$form.controls.AddRange(@(
$filePathlabel,
$filePathBox,
$browseFilesButton,
$newFileLabel,
$newFileBox,
$openFileCheckBox,
$destroyRadio,
$shuffleRadio,
$minLabel,
$minBox,
$maxLabel,
$maxBox,
$minChunkLabel,
$minChunkBox,
$maxChunkLabel,
$maxChunkBox,
$apply
))


#----------[Functions]----------

$browseFiles = {

    $folderSelection = New-Object System.Windows.Forms.OpenFileDialog -Property @{  
        InitialDirectory = [Environment]::GetFolderPath('Desktop')  
        CheckFileExists = 0  
        ValidateNames = 0  
        FileName = "Choose Folder"  
    }  

    $folderSelection.ShowDialog()   

    $filePathBox.Text = $folderSelection.Filename  
}

$selectMethod = {
    
    if($destroyRadio.Checked){
   
        $minChunkLabel.Hide()
        $minChunkBox.Hide()
        $maxChunkLabel.Hide()
        $maxChunkBox.Hide()

    }elseif($shuffleRadio.Checked){
        
        $minChunkLabel.Show()
        $minChunkBox.Show()
        $maxChunkLabel.Show()
        $maxChunkBox.Show()
    }
}

$mosh = {

    $valid = $true

    # Check if valid path is inputted
    
    $filePath = $filePathBox.Text

    # Check if empty string / catch error from Test-Path when string is empty

    if(!(Test-Path -Path $filePath) -or $filePath -eq ""){
        [System.Windows.Forms.MessageBox]::Show("Couldn't find file!")
        $valid = $false
    }

    # Check minimum and maximum values

    [int]$min = $minBox.Text
    [int]$max = $maxBox.Text
    
    if($max -gt 1 -or $max -lt 0 -or $max -lt $min -or $max -eq $min -or $min -gt 1 -or $min -lt 0 -or $min -gt $max){
        [System.Windows.Forms.MessageBox]::Show("Invalid minimum and maximum values!")
        $valid = $false
    }

    # Check chunk size values

    if($method -eq "shuffle"){
        [int]$chunkSizeMin = $minChunkBox.Text
        [int]$chunkSizeMax = $maxChunkBox.Text

        if($chunkSizeMax -lt $chunkSizeMin -or $chunkSizeMax -eq $chunkSizeMin -or $chunkSizeMin -lt 1){
            [System.Windows.Forms.MessageBox]::Show("Invalid chunk size values!")
            $valid = $false
        }
    }

    # Check if all settings are correct and run ByeByte    

    if($valid -eq $true){
        if($destroyRadio.Checked){
            byebyte destroy --input $filePath --output $newFileBox.Text --min $min --max $max
        }elseif($method -eq "shuffle"){
           byebyte shuffle --input $filePath --output $newFileBox.Text --min $min --max $max --chunk-min $chunkSizeMin --chunk-max $chunkSizeMax
        }
    }else{
        [System.Windows.Forms.MessageBox]::Show("An error has occured. Please try again.")
    }

    if($openFileCheckBox.Checked){
        Invoke-Item $newFileBox.Text
    }

}


#----------[Script]----------

$browseFilesButton.Add_Click($browseFiles)
$destroyRadio.Add_Click($selectMethod)
$shuffleRadio.Add_Click($selectMethod)
$apply.Add_Click($mosh)


#----------[Show form]----------

[void]$form.ShowDialog()