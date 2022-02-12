#### PowerShell PageCrypt Encryptor
## v1.0 - 26/11/2019
## Nial Francis - https://nialfrancis.tech/

[cmdletbinding()]
Param(
 [string]$Text,
 [string]$File,
 [string]$Password,
 [string]$Template,
 [string]$OutFile,
 [int]$KeySize = 32,
 [int]$Iterations = 100
)

#### FUNCTIONS

function Encrypt-StaticHTMLData ($sec,$data) {
	$ibytes = [System.Text.Encoding]::UTF8.GetBytes($data)
	Write-Verbose $ibytes.Length
	if ( $ibytes.Length % 16 -eq 0 ) { $ibytes = $ibytes + 0 }
	Write-Verbose ($sec | Out-String)
	
	$AES = New-Object Security.Cryptography.RijndaelManaged
	$AES.Padding = 'Zeros'
	
	$enc = $AES.CreateEncryptor($sec.key,$sec.iv)
	$encdata = $enc.TransformFinalBlock($ibytes, 0, $ibytes.Length)
	
	$AES.Dispose()
	Clear-Variable enc
	return $encdata
}

function GenerateKey {
	$salt = new-object byte[] 32
	$iv = new-object byte[] 16
	(new-object Random).NextBytes($salt)
	(new-object Random).NextBytes($iv)
	
	$PBKDF2 = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($Password, $salt)
	$PBKDF2.IterationCount = $Iterations
	
	$secrets = @{
		salt = $salt
		key = $PBKDF2.GetBytes($KeySize)
		iv = $iv
	}
	
	$PBKDF2.Dispose()
	return $secrets
}

#### MAIN

if ($Template -eq '') { $Template = Join-Path $PSScriptRoot 'decryptTemplate-legacy.html' }
if ($Password.Length -lt 8) { Write-Warning 'Password is very poor quality' }

if ($File) {
	$data = Get-Content -Raw -Encoding UTF8 $File
	if (!$OutFile) { $OutFile = $File + '.enc.html' }
} elseif ($Text) {
	$data = $Text
	if (!$OutFile) { $OutFile = (Get-Date -Format 'ddMMyy-HHmmss') + '.enc.html' }
} else {
	throw "Nothing to encrypt"
}

$sec = GenerateKey
$encbytes = Encrypt-StaticHTMLData $sec $data
$json = @{
	data = [System.Convert]::ToBase64String($encbytes)
	iv = [System.Convert]::ToBase64String($sec.iv)
	salt = [System.Convert]::ToBase64String($sec.salt)
} | ConvertTo-Json -Compress
Clear-Variable sec

$Template = Get-Content -Raw $Template
$newfile = $Template -replace '/\*{{ENCRYPTED_PAYLOAD}}\*/""',$json
$newfile | Out-File -Encoding utf8 $OutFile
