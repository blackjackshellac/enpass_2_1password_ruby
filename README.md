# enpass_2_1password_ruby

Convert enpass json format to 1password csv format suitable for importing to
1password.  The enpass data format is difficult to easily pass into 1password,
this can make it a bit easier to get most of one's data across relatively
easily. A standard ruby installation should be sufficient to run this script but
I only tested this on ruby 2.7.2.

## bin/enpass_2_1password.rb

Convert enpass json format to 1password csv format suitable for importing to
1password.

Use the --help option for argument info,

```
$ ./bin/enpass_2_1password.rb -h
enpass_2_1password ver 0.91

$ enpass_2_1password.rb [options]
    -j, --json FILE                  JSON file path or - to read from STDIN
    -d, --destdir DIR                Destination directory for csv output file, def is /home/steeve/enpass_2_1password
    -c, --csv FILE                   Output file for csv data, def is enpass_2_1password.csv
    -g, --gpg [RECIPIENT]            gpg encrypt output csv to optional recipient, def is self
    -x, --exclude NUM                Exclude labels with a row count lower than this, def is 5
    -D, --debug                      Enable debugging output
    -h, --help                       Help

```

For example, to pipe the output from a gpg encrypted enpass json file, to a gpg encrypted csv file,

```
$ gpg -d enpass.json.gpg | bin/enpass_2_1password.rb -g -j -
INFO 2020-11-20 07:50:16 -0500: Running converter
WARN 2020-11-20 07:50:16 -0500: Ignoring results for headers with fewer than 5 results [ADDITIONAL DETAILS, Phone number, One-time password, Security question, Security answer, Security type, Auth. method, Port number, Login, Access]
INFO 2020-11-20 07:50:16 -0500: csv column labels [title, subtitle, note, uuid, Password, Username, E-mail, Url, Website, Autofill Info, last name, first name, postal code]
INFO 2020-11-20 07:50:16 -0500: Working in /home/steeve/enpass_2_1password
INFO 2020-11-20 07:50:16 -0500: Piping csv to gpg -e -o enpass_2_1password.csv.gpg
File 'enpass_2_1password.csv.gpg' exists. Overwrite? (y/N) y
Results written to enpass_2_1password.csv.gpg
```

The csv output, enpass_2_1password.csv, can be imported into
1password.  Fields must still be specified in 1password during the import
process but it works well.  When testing I imported title, subtitle,
note, Password, Username, E-mail, Url. I ignored a few like uuid, and
Autofill Info.  And created new labels for some of the others.

I didn't test with totp fields so I'm not sure if that would be problematic,
I imagine you'd have to setup your totp stuff again in 1password.

## bin/enpass_secure_json.rb

Script to obfuscate values stored in an enpass json files, for example,

```
gpg -d enpass.json.gpg | ./enpass_secure_json.rb > enpass_obfus.json
```

for debugging to prevent unnecessary exposure of my unencrypted enpass data.
