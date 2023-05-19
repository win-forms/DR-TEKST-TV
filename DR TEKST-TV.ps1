cls

[reflection.assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[reflection.assembly]::LoadWithPartialName("System.Drawing") | Out-Null
[reflection.assembly]::LoadWithPartialName("System.Globalization") | Out-Null
[System.Windows.Forms.Application]::EnableVisualStyles()

#region - global variables
$ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
Import-Module -Force "$ScriptPath\Modules\Hide-Console.ps1"
$Img_Back = [System.Drawing.Image]::Fromfile("$ScriptPath\Pictures\TEKST-TV-BACK.gif")

$Box_Font = New-Object System.Drawing.Font("Courier New",16,[System.Drawing.FontStyle]::Bold)
$Number_Font = New-Object System.Drawing.Font("Courier New",10.5,[System.Drawing.FontStyle]::Bold)
$Exit_button_Font = New-Object System.Drawing.Font("Marlett",20,[System.Drawing.FontStyle]::Regular)
$Minimize_button_Font = New-Object System.Drawing.Font("Microsoft YaHei Light",35,[System.Drawing.FontStyle]::Regular)
$page_font = New-Object System.Drawing.Font("MS Sans Serif",15,[System.Drawing.FontStyle]::Bold)
$sub_page_font = New-Object System.Drawing.Font("MS Sans Serif",30,[System.Drawing.FontStyle]::Bold)
$Label_font = New-Object System.Drawing.Font("MS Sans Serif",14,[System.Drawing.FontStyle]::Bold)

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
    $p.Left = 212
    $p.Top = 625
    $p.Width = 111
    $p.Height = 25
    $p.TextAlign = "MiddleCenter"
    $p.Box_TextAlign = "Center" 
    $p.BorderStyle = "FixedSingle"
    $p.FlatStyle = "Flat"
    $p.BorderSize = 1
    $p.BackColor = "#ffffff"
    $p.Label_BackColor = [System.Drawing.Color]::Transparent
    $p.Label_ForeColor = "#ffffff"
    $p.page_previous = "899"
    $p.page_next = "101"
    $p.page_number = "100"
    $p.sub_page_previous = ""
    $p.sub_page_next = ""
    $p.Sub_page_number = ""
    $p.Sub_page_max = ""

#endregion

#region - from start
$form = New-Object System.Windows.Forms.Form
    $form.Text = "DR TEKST-TV"
    $form.ClientSize = "535,800"
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "none"
    $form.MaximizeBox = $false
    $form.TopMost = $true
    Try {
        $form.BackgroundImage = $Img_Back
        $Icon = New-Object system.drawing.icon ("$ScriptPath\Pictures\Icons\DR TEKST-TV.ico")
        $Form.Icon = $Icon
    } catch {}
#endregion

#region - form top
$Exit_button = New-Object System.Windows.Forms.Button
    $Exit_button.AutoSize = $p.AutoSize
    $Exit_button.Font = $Exit_button_Font
    $Exit_button.Top = $g.Top + 10
    $Exit_button.Left = $g.Left + $g.Width - 70
    $Exit_button.Width = 60
    $Exit_button.Height = $g.Height - 20
    $Exit_button.BackColor = "#ffc00101"
    $Exit_button.FlatStyle = $p.FlatStyle
    $Exit_button.FlatAppearance.BorderSize = 2
    $Exit_button.Cursor = "Hand"
    $Exit_button.Text = "r" # "r" + "Marlett" = x
    #$Exit_button.DialogResult = "Cancel"
    $Exit_button.TabStop = $false
$form.CancelButton = $Exit_button
$form.Controls.Add($Exit_button)

$Minimize_button = New-Object System.Windows.Forms.Button
    $Minimize_button.AutoSize = $p.AutoSize
    $Minimize_button.Font = $Minimize_button_Font
    $Minimize_button.Top = $g.Top + 10
    $Minimize_button.Left = $Exit_button.Left - 65
    $Minimize_button.Width = 60
    $Minimize_button.Height = $g.Height - 20
    $Minimize_button.BackColor = "#ffffff"
    $Minimize_button.FlatStyle = $p.FlatStyle
    $Minimize_button.FlatAppearance.BorderSize = 2
    $Minimize_button.Cursor = "Hand"
    $Minimize_button.Text = "-"
    $Minimize_button.TabStop = $false
    $Minimize_button.Add_Click([System.EventHandler]{$form.WindowState = "Minimized"})
$form.Controls.Add($Minimize_button)

$dr_PictureBox = New-Object System.Windows.Forms.PictureBox
    $dr_PictureBox.ImageLocation = "https://www.dr.dk/toppen.gif"
    $dr_PictureBox.SizeMode = "StretchImage"
    $dr_PictureBox.Left = $g.Left
    $dr_PictureBox.Top = $g.Top
    $dr_PictureBox.Width = $g.Width + 1
    $dr_PictureBox.Height = $g.Height
    $dr_PictureBox.Cursor = "SizeAll"
$form.Controls.Add($dr_PictureBox)

#endregion

#region - move the form
# set the "dragging" flag and capture the current mouse position
$dr_PictureBox.Add_MouseDown( { $g.dragging = $true
    $g.mouseDragX = [System.Windows.Forms.Cursor]::Position.X - $form.Left
    $g.mouseDragY = [System.Windows.Forms.Cursor]::Position.Y - $form.Top
})

# move the form while the mouse is depressed (i.e. $g.dragging -eq $true)
$dr_PictureBox.Add_MouseMove( { if($g.dragging) {
    $currentX = [System.Windows.Forms.Cursor]::Position.X
    $currentY = [System.Windows.Forms.Cursor]::Position.Y
    $newX = $currentX - $g.mouseDragX
    $newY = $currentY - $g.mouseDragY
    $form.Location = New-Object System.Drawing.Point($newX, $newY)
}})

# stop dragging the form
$dr_PictureBox.Add_MouseUp( { $g.dragging = $false } )
#endregion

#region - RichTextBox
$TV_TextBox = New-Object System.Windows.Forms.RichTextBox
    $TV_TextBox.AutoSize = $false
    $TV_TextBox.Font = $Box_Font
    $TV_TextBox.Left = $g.Left
    $TV_TextBox.Top = $dr_PictureBox.Top + $dr_PictureBox.Height
    $TV_TextBox.Width = $g.Width
    $TV_TextBox.Height = 560
    $TV_TextBox.ReadOnly = $true
    $TV_TextBox.BorderStyle = 0
    $TV_TextBox.BackColor = "Black"
    $TV_TextBox.ForeColor = "White"
    $TV_TextBox.WordWrap = $false
    $TV_TextBox.ScrollBars = "None"
    $TV_TextBox.TabStop = $false
$form.Controls.Add($TV_TextBox)

#endregion

Function New_Page () {
    $Url = Invoke-WebRequest ("https://www.dr.dk/cgi-bin/fttx1.exe/" + $p.page_number)
    if ($Url.ParsedHtml.getElementsByTagName("PRE") -ne $null){
        $TV_TextBox.Text = ($Url.ParsedHtml.getElementsByTagName("PRE") | select -ExpandProperty innerText).TrimEnd()
    } else {
        Page_Not_Available
    }

    $page_map = (($Url.ParsedHtml.getElementsByName("FPMap0") | Select-Object -ExpandProperty innerHTML).replace("><",">¤<").Split("¤")).substring(31,3)
    $p.page_previous = $page_map[0]
    $p.page_next = $page_map[1]
    
    $Page_TextBox.Text = ""

    if ($Url.ParsedHtml.getElementsByName("FPMap1") -ne $null){
        $sub_page_map = (($Url.ParsedHtml.getElementsByName("FPMap1") | Select-Object -ExpandProperty innerHTML).replace("><",">¤<").Split("¤")).substring(35,2).Trim('"')
        $p.sub_page_previous = $sub_page_map[1]
        $p.sub_page_next = $sub_page_map[0]
        $p.Sub_page_max = $sub_page_map[1]
        $p.Sub_page_number = "1"

        $Sub_Page_TextBox.Text = $p.Sub_page_number + "/" + $p.Sub_page_max

        If($Sub_Page_Label.Enabled -ne $true){
            $Sub_Page_Label.Enabled = $true
            $Sub_Page_TextBox.Enabled = $true
            $Sub_Page_Previous_Button.Enabled = $true
            $Sub_Page_Next_Button.Enabled = $true

            $Sub_Page_TextBox.backcolor = $p.BackColor
            $Sub_Page_Previous_Button.backcolor = $p.BackColor
            $Sub_Page_Next_Button.backcolor = $p.BackColor

            $Sub_Page_Previous_Button.Cursor = "Hand"
            $Sub_Page_Next_Button.Cursor = "Hand"
        }

    } else { 
        If($Sub_Page_Label.Enabled -ne $false){
            $Sub_Page_TextBox.Text = "" 

            $Sub_Page_Label.Enabled = $false
            $Sub_Page_TextBox.Enabled = $false
            $Sub_Page_Previous_Button.Enabled = $false
            $Sub_Page_Next_Button.Enabled = $false

            $Sub_Page_TextBox.backcolor = "#4f4f4f"
            $Sub_Page_Previous_Button.backcolor = "#4f4f4f"
            $Sub_Page_Next_Button.backcolor = "#4f4f4f"

            $Sub_Page_Previous_Button.Cursor = "Default"
            $Sub_Page_Next_Button.Cursor = "Default"
        }
    }
}

Function New_Sub_Page () {
    $Url = Invoke-WebRequest ("https://www.dr.dk/cgi-bin/fttx1.exe/" + $p.page_number + "/" + $p.Sub_page_number)
    if ($Url.ParsedHtml.getElementsByTagName("PRE") -ne $null){
        $TV_TextBox.Text = ($Url.ParsedHtml.getElementsByTagName("PRE") | select -ExpandProperty innerText).TrimEnd()
    } else {
        Page_Not_Available
    }

    if ($Url.ParsedHtml.getElementsByName("FPMap1") -ne $null){
        $sub_page_map = (($Url.ParsedHtml.getElementsByName("FPMap1") | Select-Object -ExpandProperty innerHTML).replace("><",">¤<").Split("¤")).substring(35,2).Trim('"')
        $p.sub_page_previous = $sub_page_map[1]
        $p.sub_page_next = $sub_page_map[0]
    }

    $Sub_Page_TextBox.Text = $p.Sub_page_number + "/" + $p.Sub_page_max
}

Function Page_Not_Available () {
$day = (Get-Date -Format "dddd").Substring(0,3)
$date = Get-Date -Format "dd"
$month = Get-Date -Format "MMM"
$time = Get-Date -Format "HH:mm:ss"
$TV_TextBox.Text = "        DR   S" + $p.page_number + "  " + $day + " " + $date + " " + $month + "   " + $time + "










 Denne side er desværre ikke tilgængelig"

}

#region - Page
###Page Label###
$Page_Label = New-Object System.Windows.Forms.Label
    $Page_Label.AutoSize = $p.AutoSize
    $Page_Label.Font = $Label_font
    $Page_Label.Left = $p.Left
    $Page_Label.Top = $p.Top
    $Page_Label.Width = $p.Width
    $Page_Label.Height = $p.Height
    $Page_Label.BackColor = $p.Label_BackColor
    $Page_Label.ForeColor = $p.Label_ForeColor
    $Page_Label.TextAlign = $p.TextAlign
    $Page_Label.Text = "Side"
$form.Controls.Add($Page_Label)

###Page TextBox###
$Page_TextBox = New-Object System.Windows.Forms.TextBox
    $Page_TextBox.AutoSize = $p.AutoSize
    $Page_TextBox.Font = $page_font
    $Page_TextBox.Left = $p.Left
    $Page_TextBox.Top = $Page_Label.Top + $p.Height
    $Page_TextBox.Width = $p.Width
    $Page_TextBox.Height = $p.Height
    $Page_TextBox.TextAlign = $p.Box_TextAlign
    $Page_TextBox.BorderStyle = $p.BorderStyle
    $Page_TextBox.BackColor = $p.BackColor
    $Page_TextBox.ReadOnly = $false

    # Only allow 3 numbers and no letters in $Page_TextBox
    $Page_TextBox.MaxLength = 3
    $Page_TextBox.Add_TextChanged({
        if ($this.Text -match "[^0-9]") {
            $cursorPos = $this.SelectionStart
            $this.Text = $this.Text -replace "[^0-9]",""
            $this.SelectionStart = $cursorPos - 1
            $this.SelectionLength = 0
        }
    })
$form.Add_Shown({$form.Activate(); $Page_TextBox.Focus()})
$form.Controls.Add($Page_TextBox)

###Page Search Button###
$Page_Search_Button_Event = [System.EventHandler]{
    if ($Page_TextBox.Text -ne "") {$p.page_number = $Page_TextBox.Text} else {$p.page_number = "100"}
    New_Page
}

$Page_Search_Button = New-Object System.Windows.Forms.Button
    $Page_Search_Button.AutoSize = $p.AutoSize
    $Page_Search_Button.Left = $p.Left
    $Page_Search_Button.Top = $Page_TextBox.Top + $p.Height
    $Page_Search_Button.Width = $p.Width
    $Page_Search_Button.Height = $p.Height
    $Page_Search_Button.FlatStyle = $p.FlatStyle
    $Page_Search_Button.FlatAppearance.BorderSize = $p.BorderSize
    $Page_Search_Button.BackColor = $p.BackColor
    $Page_Search_Button.Cursor = "Hand"
    $Page_Search_Button.Text = "Søg"
    $Page_Search_Button.Add_Click($Page_Search_Button_Event)
$form.AcceptButton = $Page_Search_Button
$form.Controls.Add($Page_Search_Button)

###Page Previous Button###
$Page_Previous_Button_Event = [System.EventHandler]{
    $p.page_number = $p.page_previous
    New_Page
}

$Page_Previous_Button = New-Object System.Windows.Forms.Button
    $Page_Previous_Button.AutoSize = $p.AutoSize
    $Page_Previous_Button.Left = $p.Left - $p.Width - 20
    $Page_Previous_Button.Top = $Page_Label.Top + $p.Height
    $Page_Previous_Button.Width = $p.Width
    $Page_Previous_Button.Height = $p.Height * 2
    $Page_Previous_Button.FlatStyle = $p.FlatStyle
    $Page_Previous_Button.FlatAppearance.BorderSize = $p.BorderSize
    $Page_Previous_Button.BackColor = $p.BackColor
    $Page_Previous_Button.Cursor = "Hand"
    $Page_Previous_Button.Text = "<---"
    $Page_Previous_Button.Add_Click($Page_Previous_Button_Event)
$form.Controls.Add($Page_Previous_Button)

###Page Next Button###
$Page_Next_Button_Event = [System.EventHandler]{
    $p.page_number = $p.page_Next
    New_Page
}

$Page_Next_Button = New-Object System.Windows.Forms.Button
    $Page_Next_Button.AutoSize = $p.AutoSize
    $Page_Next_Button.Left = $p.Left + $p.Width + 20
    $Page_Next_Button.Top = $Page_Label.Top + $p.Height
    $Page_Next_Button.Width = $p.Width
    $Page_Next_Button.Height = $p.Height * 2
    $Page_Next_Button.FlatStyle = $p.FlatStyle
    $Page_Next_Button.FlatAppearance.BorderSize = $p.BorderSize
    $Page_Next_Button.BackColor = $p.BackColor
    $Page_Next_Button.Cursor = "Hand"
    $Page_Next_Button.Text = "--->"
    $Page_Next_Button.Add_Click($Page_Next_Button_Event)
$form.Controls.Add($Page_Next_Button)

#endregion

#region - Sub Page
###Sub Page Label###
$Sub_Page_Label = New-Object System.Windows.Forms.Label
    $Sub_Page_Label.AutoSize = $p.AutoSize
    $Sub_Page_Label.Font = $Label_font
    $Sub_Page_Label.Left = $p.Left
    $Sub_Page_Label.Top = $Page_Search_Button.Top + $p.Height + 10
    $Sub_Page_Label.Width = $p.Width
    $Sub_Page_Label.Height = $p.Height
    $Sub_Page_Label.BackColor = $p.Label_BackColor
    $Sub_Page_Label.ForeColor = $p.Label_ForeColor
    $Sub_Page_Label.TextAlign = $p.TextAlign
    $Sub_Page_Label.Text = "Underside"
$form.Controls.Add($Sub_Page_Label)

###Sub Page TextBox###
$Sub_Page_TextBox = New-Object System.Windows.Forms.TextBox
    $Sub_Page_TextBox.AutoSize = $p.AutoSize
    $Sub_Page_TextBox.Font = $sub_page_font
    $Sub_Page_TextBox.Left = $p.Left
    $Sub_Page_TextBox.Top = $Sub_Page_Label.Top + $p.Height
    $Sub_Page_TextBox.Width = $p.Width
    $Sub_Page_TextBox.Height = $p.Height * 2
    $Sub_Page_TextBox.BorderStyle = $p.BorderStyle
    $Sub_Page_TextBox.BackColor = $p.BackColor
    $Sub_Page_TextBox.TextAlign = $p.Box_TextAlign
    $Sub_Page_TextBox.ReadOnly = $true
$form.Controls.Add($Sub_Page_TextBox)

###Sub Page Previous Button###
$Sub_Page_Previous_Button_Event = [System.EventHandler]{
    $p.Sub_page_number = $p.sub_page_previous
    New_Sub_Page
}

$Sub_Page_Previous_Button = New-Object System.Windows.Forms.Button
    $Sub_Page_Previous_Button.AutoSize = $p.AutoSize
    $Sub_Page_Previous_Button.Left = $p.Left - $p.Width - 20
    $Sub_Page_Previous_Button.Top = $Sub_Page_Label.Top + $p.Height
    $Sub_Page_Previous_Button.Width = $p.Width
    $Sub_Page_Previous_Button.Height = $p.Height * 2
    $Sub_Page_Previous_Button.FlatStyle = $p.FlatStyle
    $Sub_Page_Previous_Button.FlatAppearance.BorderSize = $p.BorderSize
    $Sub_Page_Previous_Button.BackColor = $p.BackColor
    $Sub_Page_Previous_Button.Text = "<----"
    $Sub_Page_Previous_Button.Add_Click($Sub_Page_Previous_Button_Event)
$form.Controls.Add($Sub_Page_Previous_Button)

###Sub Page Next Button###
$Sub_Page_Next_Button_Event = [System.EventHandler]{
    $p.Sub_page_number = $p.sub_page_next
    New_Sub_Page
    
}

$Sub_Page_Next_Button = New-Object System.Windows.Forms.Button
    $Sub_Page_Next_Button.AutoSize = $p.AutoSize
    $Sub_Page_Next_Button.Left = $p.Left + $p.Width + 20
    $Sub_Page_Next_Button.Top = $Sub_Page_Label.Top + $p.Height
    $Sub_Page_Next_Button.Width = $p.Width
    $Sub_Page_Next_Button.Height = $p.Height * 2
    $Sub_Page_Next_Button.FlatStyle = $p.FlatStyle
    $Sub_Page_Next_Button.FlatAppearance.BorderSize = $p.BorderSize
    $Sub_Page_Next_Button.BackColor = $p.BackColor
    $Sub_Page_Next_Button.Text = "---->"
    $Sub_Page_Next_Button.Add_Click($Sub_Page_Next_Button_Event)
$form.Controls.Add($Sub_Page_Next_Button)

#endregion

New_Page
CheckForHideConsole
$result = $form.ShowDialog()