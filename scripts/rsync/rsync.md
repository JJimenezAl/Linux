

## Incrementales con enlaces duros
### Primera vez:
 ```bash
rsync -avzHP root@alldapd01:/etc/* /mnt/CCD/BKP/D0
 
--Siguientes (rotando los D0, D1 .. a D1, D2 �. o con fechas mejor) en los que solo copias las diferencias� y enlazas el resto
 
rsync -avzHP --link-dest=/mnt/CCD/BKP/D0 root@alldapd01:/etc/* /mnt/CCD/BKP/D1
```

rsync -avzHP /home/python/* /backup/home/pruebas/D0


rsync -avzHP --link-dest=/backup/home/pruebas/D0 /home/python/* /mnt/CCD/BKP/D1

### Siguientes

```bash


rsync -avzHP --link-dest=/backup/home/pruebas/D0 /home/python/* /backup/home/pruebas/D1


rsync -avzHP --link-dest=/backup/home/pruebas/D0 /home/python/* /backup/home/pruebas/D1

rsync -avzHP --link-dest=/backup/home/pruebas/D0 /home/python/* /backup/home/pruebas/D3

 rsync -avzHP --link-dest=/backup/home/pruebas/D0 /home/python/* /backup/home/pruebas/D4

```

### Recover

```bash
rsync -azvHP /backup/home/pruebas/D4/ /home/python/
```

## Sicnronizacion

**ojo que borra en destino**
```bash
sync -azvh --delete /home/casa/Documents/copia/ /home/casa/backup/ --log-file=copia.txt
```

```
#ignore-existing
rsync -a -v --ignore-existing src dst
--prune-empty-dirs \
```


## Log file
Each character is a code that can be translated if you read the section for -i, --itemize-changes in man rsync

>f.st......

```bash

> - the item is received
f - it is a regular file
s - the file size is different
t - the time stamp is different

```
```bash
. - the item is not being updated (though it might have attributes 
    that are being modified)
d - it is a directory
t - the time stamp is different
```

>f+++++++++


```bash

> - the item is received
f - a regular file
+++++++++ - this is a newly created item
```


The relevant part of the rsync man page:

-i, --itemize-changes

Requests a simple itemized list of the changes that are being made to each file, including attribute changes. This is exactly the same as specifying --out-format='%i %n%L'. If you repeat the option, unchanged files will also be output, but only if the receiving rsync is at least version 2.6.7 (you can use -vv with older versions of rsync, but that also turns on the output of other verbose mes- sages).

The "%i" escape has a cryptic output that is 11 letters long. The general format is like the string YXcstpoguax, where Y is replaced by the type of update being done, X is replaced by the file-type, and the other letters represent attributes that may be output if they are being modified.

The update types that replace the Y are as follows:

    A < means that a file is being transferred to the remote host (sent).
    A > means that a file is being transferred to the local host (received).
    A c means that a local change/creation is occurring for the item (such as the creation of a directory or the changing of a symlink, etc.).
    A h means that the item is a hard link to another item (requires --hard-links).
    A . means that the item is not being updated (though it might have attributes that are being modified).
    A * means that the rest of the itemized-output area contains a message (e.g. "deleting").

The file-types that replace the X are: f for a file, a d for a directory, an L for a symlink, a D for a device, and a S for a special file (e.g. named sockets and fifos).

The other letters in the string above are the actual letters that will be output if the associated attribute for the item is being updated or a "." for no change. Three exceptions to this are: (1) a newly created item replaces each letter with a "+", (2) an identical item replaces the dots with spaces, and (3) an unknown attribute replaces each letter with a "?" (this can happen when talking to an older rsync).

The attribute that is associated with each letter is as follows:

    A c means either that a regular file has a different checksum (requires --checksum) or that a symlink, device, or special file has a changed value. Note that if you are sending files to an rsync prior to 3.0.1, this change flag will be present only for checksum-differing regular files.
    A s means the size of a regular file is different and will be updated by the file transfer.
    A t means the modification time is different and is being updated to the sender�s value (requires --times). An alternate value of T means that the modification time will be set to the transfer time, which happens when a file/symlink/device is updated without --times and when a symlink is changed and the receiver can�t set its time. (Note: when using an rsync 3.0.0 client, you might see the s flag combined with t instead of the proper T flag for this time-setting failure.)
    A p means the permissions are different and are being updated to the sender�s value (requires --perms).
    An o means the owner is different and is being updated to the sender�s value (requires --owner and super-user privileges).
    A g means the group is different and is being updated to the sender�s value (requires --group and the authority to set the group).
    The u slot is reserved for future use.
    The a means that the ACL information changed.
    The x means that the extended attribute information changed.

One other output is possible: when deleting files, the "%i" will output the string "*deleting" for each item that is being removed (assuming that you are talking to a recent enough rsync that it logs deletions instead of outputting them as a verbose message)
