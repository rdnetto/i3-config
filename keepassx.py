#!/usr/bin/python3

import os
import sys
import pexpect
from types import SimpleNamespace


# TODO: should really just ask for password first, dump contents, then take input
# This would eliminate the need for a cache, but would require a circle of pipes


def escape(s):
    return s.replace(" ", r"\ ").replace("/", r"\\/")


def open_db(password):
    kpcli = pexpect.spawn("kpcli --kdb /home/reuben/.config/keepassx/Database.kdbx --readonly")
    kpcli.expect("Please provide the master password: ")
    kpcli.sendline(password)
    kpcli.expect("kpcli:/> ")

    def run(cmd):
        kpcli.sendline(cmd)
        kpcli.expect("kpcli:/> ")
        return kpcli.before.decode("utf-8").splitlines()[1:]

    def get(path):
        res = dict()

        for line in kpcli.run("show -f " + path):
            xs = line.split(": ", 1)
            xs[0] = xs[0].strip().lower()

            if(len(xs) == 1):
                continue

            elif(xs[0] == "pass"):
                # pass is a keyword
                xs[0] = "password"

            res[xs[0]] = xs[1]

        return SimpleNamespace(**res)

    kpcli.run = run
    kpcli.get = get
    return kpcli


def find_entries(kpcli, prefix="/"):
    mode = None
    result = []

    for row in kpcli.run("ls " + prefix):
        if(row.startswith("===")):
            # Heading
            if(row == "=== Groups ==="):
                mode = "groups"
            elif(row == "=== Entries ==="):
                mode = "entries"
            else:
                assert False, "Unknown heading: " + row

        elif(mode == "groups"):
            result.extend(find_entries(kpcli, prefix + row))

        elif(mode == "entries"):
            fields = row.split(". ", 1)
            result.append(prefix + escape(fields[1].rstrip()))

        else:
            assert False, "Unknown mode: " + repr(mode)

    return result


def main():
    # Let the user specify the entry
    requested_entry = input()

    # Get the password from the user
    # TODO: use GUI
    with open("/tmp/a", "r") as f:
        master = f.read().strip()

    kpcli = open_db(master)
    keys = find_entries(kpcli)

    # Update cached list
    with open("/home/reuben/.cache/keepass", "w") as f:
        f.writelines([k + "\n" for k in keys])

    # Output requested password
    entry = kpcli.get(requested_entry)
    print(entry.password)

    # Close db
    kpcli.sendline("quit")


if(__name__ == "__main__"):
    main()
