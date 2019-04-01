#!/bin/bash

function fail_test {
  echo "Test is failed."
  exit 1
}

echo -e "\nTest case 0. File not exists."
./credentials_alert.sh -file ./test-config/notExist && fail_test

echo -e "\nTest case 1. Found unsafe cred. Exit with error"
./credentials_alert.sh -file ./test-config/test-case-1-unsafe-cred.yml && fail_test

echo -e "\nTest case 2. Found unsafe cred. Exit with error"
./credentials_alert.sh -file ./test-config/test-case-2-composite-key-unsafe-cred.yml && fail_test

echo -e "\nTest case 3. Cred is safe. Exit with 0"
./credentials_alert.sh -file ./test-config/test-case-3-safe-cred.yml || fail_test 

echo -e "\nTest case 4. False positive. Exit with 0"
./credentials_alert.sh -file ./test-config/test-case-4-false-positive.yml || fail_test

echo -e "\n"
echo "=========================="
echo "===All tests are Green!==="
echo "=========================="

exit 0
