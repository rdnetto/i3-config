#!/usr/bin/python3

import os
import sys
import pexpect
import subprocess


# TODO: should really just ask for password first, dump contents, then take input
# This would eliminate the need for a cache, but would require a circle of pipes


HOME = os.environ['HOME']


def escape(s):
    return s.replace(" ", r"\ ").replace("/", r"\\/")


def open_db(password):
    kpcli = pexpect.spawn("kpcli --kdb " + HOME + "/.config/keepassx/Database.kdbx --readonly")
    kpcli.expect("Please provide the master password: ")
    kpcli.sendline(password)
    kpcli.expect("kpcli:/> ")

    def run(cmd):
        kpcli.sendline(cmd)
        kpcli.expect_exact("kpcli:/> ")
        return kpcli.before.decode("utf-8").splitlines()[1:]

    def get(path):
        res = dict()

        for line in kpcli.run("show -f " + path):
            xs = line.split(": ", 1)
            xs[0] = xs[0].strip().lower()

            if(len(xs) != 1):
                res[xs[0]] = xs[1]

        return res if len(res) > 0 else None

    kpcli.run = run
    kpcli.get = get
    return kpcli


def find_entries(kpcli, prefix="Root/"):
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


def gui_error(msg):
    subprocess.check_output([
        "kdialog",
        "--title", "KeePassX",
        "--error", msg
    ])


def gui_password_prompt():
    try:
        return subprocess.check_output([
            "kdialog",
            "--title", "KeePassX",
            "--password", "Please enter the master password:"
        ]).decode('utf-8').rstrip()

    except subprocess.CalledProcessError:
        # User cancelled
        sys.exit(1)


def main():
    # Let the user specify the entry
    requested_entry = input()

    while True:
        try:
            # Get the password from the user
            master = gui_password_prompt()

            # Open the db
            kpcli = open_db(master)
            break

        except pexpect.exceptions.EOF:
            # Incorrect password
            continue

    keys = find_entries(kpcli)

    # Update cached list
    with open(HOME + "/.cache/keepass", "w") as f:
        f.writelines([k + "\n" for k in keys])

    # Output requested password
    entry = kpcli.get(requested_entry)

    if(entry is None):
        gui_error("Could not find entry '{}'".format(requested_entry))
    else:
        print(entry["pass"])

    # Close db
    kpcli.sendline("quit")


if(__name__ == "__main__"):
    main()

