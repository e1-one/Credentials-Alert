# Credentials Alert
This script finds unencrypted credentials. \
Example of unsafe property: `password: 'password'` \
Example of encrypted property: `password: '{cipher}dlk7sasd54a13sda895da5ads3daxv3'` 

__The script scans property files for credentials and then alerts if it finds them.__ \
Keys for properties that need to be analyzed are stored in _dictionary/confidential-properties-keys-dictionary.txt_

### Execution example
- Scan a file
> ./credentials_alert.sh -file ./test-config/test-case-1-unsafe-cred.yml 

Output:
```
Keys that we are analyzing: username password bing-key salt crypto-key api-key user passwd userid
ALERTS COUNT: 1
WARN: ./test-config/test-case-1-unsafe-cred.yml[3]:password
Looks like we found some unsafe credentials!
```
- Scan A folder
> ./credentials_alert.sh -folder ./test-config \
Output:
```
Analyzing file:./test-config/test-case-1-unsafe-cred.yml
Analyzing file:./test-config/test-case-2-composite-key-unsafe-cred.yml
Analyzing file:./test-config/test-case-3-safe-cred.yml
Analyzing file:./test-config/test-case-4-false-positive.yml
DEBUG: password value is false positive
ALERTS COUNT: 2
WARN: ./test-config/test-case-1-unsafe-cred.yml[3]:password
WARN: ./test-config/test-case-2-composite-key-unsafe-cred.yml[1]:password
Looks like we found some unsafe credentials!
```
### Handling false positive cases
If a property value contains _#FalsePositive_ its content will be ignored during analyze \
Example of ignored property: `password: 'this is fake password' #FalsePositive`

### Exit status
| Code        | Description   |
| ----------- |:-------------:|
| 0 | No error occurred and no credentials found |
| 1 |  Alerts occurred                           |

### Run unit tests for the script 
> ./test_cred_alert.sh

Should see in output:
```
===All tests are Green!===
```