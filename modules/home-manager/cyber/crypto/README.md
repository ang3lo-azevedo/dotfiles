# Crypto Tools

This module contains various cryptography, steganography, and reverse engineering tools for cracking hashes, decrypting ciphers, and analyzing crypto implementations.

## Cryptanalysis & Decryption

### [Ciphey](./cryptanalysis/ciphey.nix)
**What it is:** Fully automated decryption/decoding/cracking tool.
**When to use:** You have a blob of text (e.g., base64, hex, morse code, vigenere) and you don't know what encryption or encoding was used. Ciphey uses NLP and AI to figure it out automatically.

### [RsaCtfTool](./cryptanalysis/rsactftool.nix)
**What it is:** RSA attack tool used in CTFs to recover private keys from public keys and/or ciphertexts.
**When to use:** You are given an RSA public key (`.pem` or `.pub`) and a ciphertext, and you need to crack the key using known attacks (Wiener's attack, Fermat's factorization, etc.).

## Mathematics & Tooling

### [SageMath](./math/sage.nix)
**What it is:** Open-source mathematics software system built on top of many existing open-source packages (NumPy, SciPy, matplotlib, Sympy, Maxima, GAP, FLINT, R).
**When to use:** You are solving complex cryptography CTF challenges that require advanced mathematics like elliptic curve operations, lattice reductions (LLL), or polynomial factoring that standard Python cannot handle.
