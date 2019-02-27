## Command Line Interface with Python ##
This tool securely password-protects HTML files from the command line using Python3.

### Usage ###
Run: `python3 encrypt.py filename [passphrase]`  
The first, mandatory parameter is the name of the file you want to encrypt.
It is also possible to give the passphrase as the second parameter. If there is
no passphrase provided at start, the script will ask for it while running.

### Dependencies ###
1) Python3
2) [pycrypto](https://pypi.org/project/pycrypto/) for AES: `pip3 install pycrypto`
3) Python version of [pbkdf2](https://pypi.org/project/pbkdf2/): `pip3 install pbkdf2`
