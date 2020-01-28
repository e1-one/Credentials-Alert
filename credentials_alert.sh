#!/bin/bash

declare -a alerts_array
property_files_pattern=".*.yml"
false_positive_pattern="#FalsePositive"

#property_files_pattern=".*moabep-dev.yml"
dictionary_file="./dictionary/confidential-properties-keys-dictionary.txt"

IFS=$'\n' read -d '' -r -a dictionary < $dictionary_file
echo "Keys that we are analyzing: ${dictionary[@]}"

function containsKey {
  #echo "SEARCH: "$1
  for i in "${dictionary[@]}"
  do
    if [ "$i" == "$1" ] ; then
        return 0;
    fi
  done
  return 1;
}

function isFalsePositive {
  if echo $1 | grep -q $false_positive_pattern
  then
    return 0;
  else
    return 1;
  fi
}

#$1 - property key
#$2 - property value
#$3 - file name
#$4 - # line
function property_audit {
  property_key="$(echo "${1}" | xargs)" #trim trial spaces
  #echo $property_key

  if containsKey $1
  then
      #echo "DEBUG: $property_key is found!"
      if echo $2 | grep -q "{cipher}"
      then
          : #echo "DEBUG: property value is encrypted:"
      else
	      #echo "DEBUG: property value is not encrypted"
        if isFalsePositive "$2"
        then
          echo "DEBUG: $property_key value is false positive"
        else
	      alerts_array+=($3"["$4"]:"$property_key)
        fi
      fi
  else
      : #echo "DEBUG: $property_key is not confidential property"
  fi
}

# key in yml could be composite for example: '   system.module.status:'
# in such case we want to extract 'status' only.
#$1 - composite key. Example  ' level1.level2.level3'
#return - 'level3'
function getLastPartFromCompositeKey {
  IFS='.' read -r -a keys <<< "$1"
  echo ${keys[*]: -1}
}

function process_yml {
  input_file=$1
  if [ -f "$input_file" ]
  then
    : #echo "DEBUG: $input_file found."
  else
    echo "ERROR. File: $input_file not found."
    exit 1
  fi
  line_counter=0
  while IFS= read -r line
  do
    line_counter=$(( $line_counter + 1 ))
    #echo "DEGUG: processing line: $line"
    IFS=':' read -r -a key_and_value <<< "$line"
    array_size=${#key_and_value[@]}
    if [ $array_size -eq 2 ]; #only if the line contains both a key and a value
    then
      #echo "DEBUG. The line contains both key and value: $line"
      local key=$(getLastPartFromCompositeKey "${key_and_value[0]}")
      #echo "DEBUG. The last key part is: $key"
      local value="${key_and_value[1]}"
      property_audit $key "$value" $input_file $line_counter
    else
      : #echo "DEBUG: skipping this line"
    fi
  done < "$input_file"
}

function assert_alerts_array {
  echo "ALERTS COUNT: "${#alerts_array[@]}
  for key in ${alerts_array[*]}; do
  	echo "WARN: "$key
  done

  if [ ${#alerts_array[@]} -ne 0 ];
  then
    echo "Looks like we have found some unsafe credentials!"
    exit 1
  else
    echo "Unsafe credentials haven't found."
    exit 0
  fi
}

function process_ymls_in_folder {
  array_ymls_files=($(find $1 -regex $property_files_pattern));

  for file in ${array_ymls_files[@]};
  do
    echo "Analyzing file:"$file;
    process_yml $file
  done
}

function propagate_input_arguments {
  case "$1" in
  -folder)
    process_ymls_in_folder $2
  ;;
  -file)
    process_yml $2
  ;;
  *)
    echo "Usage: $0 FLAG SOURCE"
    echo "FLAG: -folder | -file"
    exit 1
  ;;
esac
}

propagate_input_arguments $@
assert_alerts_array
