cls

[reflection.assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[reflection.assembly]::LoadWithPartialName("System.Drawing") | Out-Null
[System.Windows.Forms.Application]::EnableVisualStyles()

###from start###

$form = New-Object System.Windows.Forms.Form
$form.Text = "DR TEKST-TV"
$form.ClientSize = '535,800'
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'none'
$form.MaximizeBox = $false
$form.Icon = "C:\Users\cavol\Desktop\Powershell\Pictures\DR\favicon.ico"
$form.TopMost = $true
# $form.BackColor = '#ffc00101'

###global variables### 

$Box_Font = New-Object System.Drawing.Font('Lucida Console',16,[System.Drawing.FontStyle]::Regular)
$Exit_button_Font = New-Object System.Drawing.Font('Marlett',20,[System.Drawing.FontStyle]::Regular)

$g = @{}
$g.dragging = $false
$g.mouseDragX = 0
$g.mouseDragY = 0
$g.Left = 0
$g.Top = 0
$g.Width = 535
$g.Height = 60

$p = @{}
$p.AutoSize = $false
$p.Left = 180
$p.Top = 650
$p.Width = 200
$p.Height = 20
$p.TextAlign = 'MiddleCenter'
$p.Box_TextAlign = 'Center' 
$p.BorderStyle = 'FixedSingle'

###form top###

$Exit_button = New-Object System.Windows.Forms.Button
$Exit_button.AutoSize = $p.AutoSize
$Exit_button.Font = $Exit_button_Font
$Exit_button.Top = $g.Top + 10
$Exit_button.Left = $g.Left + $g.Width - 70
$Exit_button.Width = 60
$Exit_button.Height = $g.Height - 20
$Exit_button.BackColor = '#ffc00101'
$Exit_button.FlatStyle = 'Flat'
$Exit_button.FlatAppearance.BorderColor = 'black'
$Exit_button.Cursor = 'Hand'
$Exit_button.Text = "r" # "r" + 'Marlett' = x
$Exit_button.DialogResult = 'Cancel'
$form.CancelButton = $Exit_button
$form.Controls.Add($Exit_button)

$dr_PictureBox = New-Object System.Windows.Forms.PictureBox
$dr_PictureBox.ImageLocation = "https://www.dr.dk/toppen.gif"
$dr_PictureBox.SizeMode = 'StretchImage'
$dr_PictureBox.Left = $g.Left
$dr_PictureBox.Top = $g.Top
$dr_PictureBox.Width = $g.Width + 1
$dr_PictureBox.Height = $g.Height
$dr_PictureBox.Cursor = 'SizeAll'
$form.Controls.Add($dr_PictureBox)

###move the form###

# set the 'dragging' flag and capture the current mouse position
$dr_PictureBox.Add_MouseDown( { $g.dragging = $true
    $g.mouseDragX = [System.Windows.Forms.Cursor]::Position.X - $form.Left
    $g.mouseDragY = [System.Windows.Forms.Cursor]::Position.Y - $form.Top
})

# move the form while the mouse is depressed (i.e. $g.dragging -eq $true)
$dr_PictureBox.Add_MouseMove( { if($g.dragging) {
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
    $currentX = [System.Windows.Forms.Cursor]::Position.X
    $currentY = [System.Windows.Forms.Cursor]::Position.Y
    [int]$newX = [Math]::Min($currentX - $g.mouseDragX, $screen.Right - $form.Width)
    [int]$newY = [Math]::Min($currentY - $g.mouseDragY, $screen.Bottom - $form.Height)
    $form.Location = New-Object System.Drawing.Point($newX, $newY)
}})

# stop dragging the form
$dr_PictureBox.Add_MouseUp( { $g.dragging = $false })




$startpage_url = Invoke-WebRequest ("https://www.dr.dk/cgi-bin/fttx1.exe/100/")
$startpage = ($startpage_url.ParsedHtml.body.innerText).Trim()
$TV_TextBox = New-Object System.Windows.Forms.RichTextBox
$TV_TextBox.AutoSize = $false
$TV_TextBox.Font = $Box_Font
$TV_TextBox.Left = $g.Left
$TV_TextBox.Top = $dr_PictureBox.Top + $dr_PictureBox.Height
$TV_TextBox.Width = $g.Width
$TV_TextBox.Height = 520
$TV_TextBox.ReadOnly = $true
$TV_TextBox.BorderStyle = 0
$TV_TextBox.BackColor = 'Black'
$TV_TextBox.ForeColor = 'White'
$TV_TextBox.WordWrap = $false
$TV_TextBox.ScrollBars = 'None'
$TV_TextBox.Text = $startpage
$form.Controls.Add($TV_TextBox)

#region Page
$Page_Label = New-Object System.Windows.Forms.Label
$Page_Label.AutoSize = $p.AutoSize
$Page_Label.Left = $p.Left
$Page_Label.Top = $p.Top
$Page_Label.Width = $p.Width
$Page_Label.Height = $p.Height
$Page_Label.TextAlign = $p.TextAlign
$Page_Label.Text = "Side:"
$form.Controls.Add($Page_Label)



$Page_TextBox = New-Object System.Windows.Forms.TextBox
$Page_TextBox.AutoSize = $p.AutoSize
$Page_TextBox.Left = $p.Left
$Page_TextBox.Top = $Page_Label.Top + $p.Height
$Page_TextBox.Width = $p.Width
$Page_TextBox.Height = $p.Height
$Page_TextBox.TextAlign = $p.Box_TextAlign
$Page_TextBox.BorderStyle = $p.BorderStyle
$Page_TextBox.ReadOnly = $false

#Only allow 3 numbers and no letters in $Page_TextBox
$Page_TextBox.MaxLength = 3
$Page_TextBox.Add_TextChanged({
    if ($this.Text -match '[^0-9]') {
        $cursorPos = $this.SelectionStart
        $this.Text = $this.Text -replace '[^0-9]',''
        $this.SelectionStart = $cursorPos - 1
        $this.SelectionLength = 0
    }
})
$form.Add_Shown({$form.Activate(); $Page_TextBox.Focus()})
$form.Controls.Add($Page_TextBox)



$Page_Search_Button_Event = [System.EventHandler]{
    $page_number = $Page_TextBox.Text
    $TV_TextBox2 = Invoke-WebRequest ("https://www.dr.dk/cgi-bin/fttx1.exe/" + $page_Number)
    $TV_TextBox.Text = ($TV_TextBox2.ParsedHtml.body.innerText).trim()
}

$Page_Search_Button = New-Object System.Windows.Forms.Button
$Page_Search_Button.AutoSize = $p.AutoSize
$Page_Search_Button.Left = $p.Left
$Page_Search_Button.Top = $Page_TextBox.Top + $p.Height
$Page_Search_Button.Width = $p.Width
$Page_Search_Button.Height = $p.Height
$Page_Search_Button.Text = "Søg"
$Page_Search_Button.Add_Click($Page_Search_Button_Event)
$form.AcceptButton = $Page_Search_Button
$form.Controls.Add($Page_Search_Button)

#endregion

$result = $form.ShowDialog()