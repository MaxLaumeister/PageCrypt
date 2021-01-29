## Command Line Interface with Python ##
This tool securely password-protects HTML files from the command line using Python3.

### Usage ###
Run: `pip3 install -r requirements.txt` 
Run: `python3 encrypt.py filename [passphrase]`  
The first, mandatory parameter is the name of the file you want to encrypt.
It is also possible to give the passphrase as the second parameter. If there is
no passphrase provided at start, the script will ask for it while running.

### Dependencies ###
1) Python3 and Pip3
2) [pycryptodome](https://pypi.org/project/pycryptodome/) for AES. (pycrypto is [deprecated](https://github.com/pycrypto/pycrypto/issues/275))
3) Python version of [pbkdf2](https://pypi.org/project/pbkdf2/): `pip3 install pbkdf2`
