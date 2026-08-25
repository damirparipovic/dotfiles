
<############### Start of PowerTab Initialization Code ########################
    Added to profile by PowerTab setup for loading of custom tab expansion.
    Import other modules after this, they may contain PowerTab integration.
#>

$powerTabModule = Get-Module -ListAvailable -Name PowerTab |
	Sort-Object Version -Descending |
	Select-Object -First 1
if ($null -ne $powerTabModule)
{
	$powerTabConfig = Join-Path $powerTabModule.ModuleBase 'PowerTabConfig.xml'
	Import-Module $powerTabModule.Path -ArgumentList $powerTabConfig
}
################ End of PowerTab Initialization Code ##########################

#
# Aliases
function Get-AllItems
{
	Get-ChildItem -Force
}
Set-Alias -Name la -Value Get-AllItems

function UPOneLevel
{
	Set-Location ..
}
Set-Alias -Name .. -Value UPOneLevel

function Open-NvimConfig
{
	nvim $HOME\AppData\Local\nvim\.
}
Set-Alias -Name nvimconfig -Value Open-NvimConfig

function Open-WeztermConfig
{
	nvim $HOME\.config\wezterm\wezterm.lua
}
Set-Alias -Name weztermconfig -Value Open-WeztermConfig

function Open-PowershellConfig 
{
	nvim $PROFILE
}
Set-Alias -Name psconfig -Value Open-PowershellConfig

$gitIgnoreScript = Join-Path $HOME 'programs\powerscripts\git-ignore.ps1'
if (Test-Path $gitIgnoreScript)
{
	Set-Alias git-ignore $gitIgnoreScript
}

#activte zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue)
{
	Invoke-Expression (& { zoxide init powershell | Out-String })
}

