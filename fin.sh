#!/bin/bash


appdata=~/Library/Application\ Support/Fin
data=$appdata/Fin
tmp_tar=$appdata/fin.tar
gpg=$appdata/Fin.gpg


decrypt_n_decompress() {
        echo "Decrypting..."
        gpg --decrypt --cipher-algo AES256 --output "$tmp_tar" "$gpg"

        echo "Decompressing..."
        mkdir -p "$data"
        tar xzfP "$tmp_tar"

        rm "$tmp_tar"
        rm "$gpg"
}

compress_n_encrypt() {
        echo "Compressing..."
        echo $data
        tar cfzP "$tmp_tar" "$data"

        echo "Encrypting...."
        gpg --symmetric --cipher-algo AES256 --output "$gpg" "$tmp_tar"

        rm "$tmp_tar"
        rm -rf "$data"
}

echo $appdata

if [ ! -d "$appdata" ]; then
        echo "Application Data doesn't exist. Running first time setup"
        mkdir -p "$appdata"

        mkdir -p "$data"
        cd "$data"
        vim .
        compress_n_encrypt
else
        decrypt_n_decompress
        cd "$data"
        vim .
        compress_n_encrypt
fi
