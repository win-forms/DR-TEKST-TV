#parameter = -h

$Script:showWindowAsync = Add-Type -MemberDefinition @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"@ -Name "Win32ShowWindowAsync" -Namespace Win32Functions -PassThru

Function Hide-Console()
{
    $null = $showWindowAsync::ShowWindowAsync((Get-Process -Id $pid).MainWindowHandle, 0) #0 = Hide, 2 = Minimize. Hide should never be used in Powershell ISE, because the console can't be restored.
}

Function CheckForHideConsole{
    $HideConsole = $False
    for ( $i = 0; $i -lt $script:args.count; $i++ ) {
        if ($script:args[ $i ] -eq "-h"){$HideConsole = $True} #If script has been started with the parameter -h then hide the console
    }
    IF ($HideConsole -eq $True) {
        Hide-console #hide the console after PowerShell has loaded...
    }
}