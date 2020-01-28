#!/bin/bash

function fail_test {
  echo "Test is failed."
  exit 1
}

echo -e "\nTest case 0. Expected: File not exists."
./credentials_alert.sh -file ./test-config/notExist && fail_test

echo -e "\nTest case 1. Expected: Found unsafe cred. Exit with error"
./credentials_alert.sh -file ./test-config/test-case-1-unsafe-cred.yml && fail_test

echo -e "\nTest case 2. Expected: Found unsafe cred. Exit with error"
./credentials_alert.sh -file ./test-config/test-case-2-composite-key-unsafe-cred.yml && fail_test

echo -e "\nTest case 3. Expected: Cred is safe. Exit with 0"
./credentials_alert.sh -file ./test-config/test-case-3-safe-cred.yml || fail_test

echo -e "\nTest case 4. Expected: False positive scenario. Exit with 0"
./credentials_alert.sh -file ./test-config/test-case-4-false-positive.yml || fail_test

echo -e "\n"
echo "==========================="
echo "===All tests have passed==="
echo "==========================="

exit 0
