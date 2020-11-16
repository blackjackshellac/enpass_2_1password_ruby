## enpass_2_1password_ruby

Convert enpass json format to 1password format suitable for importing.

# bin/enpass_2_1password.rb

Use the --help option for argument info,

```
$ ./bin/enpass_2_1password.rb -h

enpass_2_1password.rb [options]
    -j, --json FILE                  JSON file path or - to read from STDIN
    -c, --csv FILE                   Output file for csv data, def is enpass_2_1password.csv
    -x, --exclude NUM                Exclude labels with a row count lower than this, def is 5
    -D, --debug                      Enable debugging output
    -h, --help                       Help
```

For example, to pipe the output from a gpg encrypted enpass json file,

```
$ gpg -d enpass.json.gpg | bin/enpass_2_1password.rb -j - -x 4
INFO 2020-11-16 14:49:05 -0500: Running converter
WARN 2020-11-16 14:49:05 -0500: Ignoring results for headers with fewer than 4 results [ADDITIONAL DETAILS, Phone number, One-time password, Security question, Security answer, Security type, Auth. method, Port number, Login, Access]
INFO 2020-11-16 14:49:05 -0500: csv column labels [title, subtitle, note, uuid, Password, Username, E-mail, Url, Website, Autofill Info, last name, first name, postal code]
INFO 2020-11-16 14:49:05 -0500: Writing results to enpass_2_1password.csv
```

The csv output, enpass_2_1password.csv, can be imported into
1password.  Fields must still be specified in 1password during the import
process but it works well.  When testing I imported title, subtitle,
note, Password, Username, E-mail, Url. I ignored a few like uuid, and
Autofill Info.  And created new labels for some of the others.

I didn't test with totp fields so I'm not sure if that would be problematic,
I imagine you'd have to setup your totp stuff again in 1password.

# bin/enpass_secure_json.rb

Script to obfuscate values stored in an enpass json files, for example,

```
gpg -d enpass.json.gpg | ./enpass_secure_json.rb > enpass_obfus.json
```
