# Automated Server Backup

Automatically create **server backups on Linux**, encrypted with your **GPG key**, and download the encrypted backups on Windows on a weekly basis.  

---

## Requirements

- `putty.exe`  
- `puttygen.exe`  
- `pscp.exe`  
- A strong **GPG key** to encrypt the archive  
- GPG for Windows ([https://www.gpg4win.org/](https://gpg4win.org)) 
- Optional: Kleopatra 

In possible, always download the required executables from the official channel. I added the executables inside the backup folder as a private backup, including the signatures.
All official executables can be found here:

https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html

## Server installation

1. Install gpg.

```
sudo apt update
sudo apt install gnupg -y
gpg --import /path/to/public.key
```

2. Navigate to `/usr/local/bin`:

```bash
cd /usr/local/bin
sudo nano backup.sh
sudo chmod +x /usr/local/bin/backup.sh
```
Paste .sh script.

## Cron
```bash
sudo crontab -e
```

Add the following line to run backups every Sunday at 2:00 AM and log the output:
```bash
0 2 * * 0 /usr/local/bin/backup.sh >> /secret/path/backup.log 2>&1
```

Save.

## On Windows

1. Create a PuTTY private key using puttygen if you don’t have one yet.
2. Create a folder on your Desktop called /Backup/ (or somewhere else,  edit all files to set correct).
3. Then move these files into the folder:
   
```  
- pscp.exe
- Run-Backup.vbs
- Server-Backup.bat
- Your Putty private key, i.e. privatekey.ppk
```
## Run it manually, or schedule.

Manually:
To run it, click Run-Backup.vbs

Scheduled (Recommended)
Use Windows Task Scheduler:

Action → Start a program:
```
C:\Users\<USERNAME>\Desktop\Backup\Run-Backup.vbs
```

Schedule it weekly or daily as desired.

## Decryption

To decrypt the downloaded backup on Windows, open a CMD window and type:
```
gpg --decrypt backup.tar.gz.gpg > backup.tar.gz
```
  
