# enpass_2_1password_ruby

Convert enpass json format to 1password format suitable for importing

# bin/enpass_secure_json.rb

Script to obfuscate values stored in an enpass json files, for example,

```
gpg -d enpass.json.gpg | ./enpass_secure_json.rb > enpass_obfus.json
```
