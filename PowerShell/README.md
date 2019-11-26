## Command Line Interface for PowerShell ##
This tool securely password-protects HTML files from the command line using PowerShell (written with v5 but will very likely work on lower versions and Core).  
Utilises .Net encryption libraries.

This implementation will also support a number of cypher changes (eg. key size and hash iterations) which the template currently does not.

### Usage ###
Add this script and the decryptTemplate.html template to a directory.  
Run with (minimum):  
. Encrypt-StaticHTML.ps1 -Text '--text to encrypt--' -Password '--encryption password--'

### Parameters ###
Mandatory:  
Password = key password  
Text = text to encrypt, or  
File = file to encrypt

Optional:  
Template = Custom template location  
OutFile = Destination file  
KeySize = AES key size (default 32 bytes)  
Iterations = Hash iterations (default 100)

### Dependencies ###
None on Windows.
