# Credentials-Alert
The script scans property files for credentials and then alerts if it finds them. \
Keys for properties that need to be analysed are stored in _dictionary/confidential-properties-keys-dictionary.txt_

### Execution example
- Scan a file
> ./credentials_alert.sh -file ./test-config/test-case-1-unsafe-cred.yml 

Output:
```
Keys that we are analysing: username password bing-key salt crypto-key api-key user passwd userid
ALERTS COUNT: 1
WARN: ./test-config/test-case-1-unsafe-cred.yml[3]:password
Looks like we found some unsafe credentials!
```
- Scan A folder
> ./credentials_alert.sh -folder ./test-config \
Output:
```
Analysing file:./test-config/test-case-1-unsafe-cred.yml
Analysing file:./test-config/test-case-2-composite-key-unsafe-cred.yml
Analysing file:./test-config/test-case-3-safe-cred.yml
Analysing file:./test-config/test-case-4-false-positive.yml
DEBUG: password value is false positive
ALERTS COUNT: 2
WARN: ./test-config/test-case-1-unsafe-cred.yml[3]:password
WARN: ./test-config/test-case-2-composite-key-unsafe-cred.yml[1]:password
Looks like we found some unsafe credentials!
```

### Exit status
| Code        | Description   |
| ----------- |:-------------:|
| 0 | No error occurred and no credentials found |
| 1 |  Alerts occurred                           |

### Run unit tests for the script 
> ./test_cred_alert.sh \
Should be:
```
==========================
===All tests are Green!===
==========================
```
