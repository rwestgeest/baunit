#!/bin/bash
assert_equals() {
  expected=$1
  actual=$2
  if [[ $expected != $actual ]]
  then
    echo "Expected: $expected, but was: $actual"
    exit 1
  fi
}
run_suite() {
  local suite=$1
  source $suite
  local suite_result=0
  tests_ran=0
  tests_failed=0
  for current_test in `grep "^test_.*() {" $suite | tr -d '(){'`
  do
    (
      [[ "function" == $(type -t teardown) ]] && trap teardown exit
      [[ "function" == $(type -t setup) ]] && setup
      $current_test
    )
    local test_result=$?
    [[ $test_result != 0 ]] && (( tests_failed += 1 ))
    (( suite_result=$suite_result||$test_result ))
    (( tests_ran += 1 ))
  done
  return $suite_result
}

print_report() {
  local message=Success
  if [[ $tests_failed != 0 ]]
  then
    message=Failure
  fi
  echo "$message!; run: $tests_ran, failed: $tests_failed"
}



a_suite() {
  local suite_name=$1
  run_suite data/example_suite_${suite_name}.sh
}
single_line_log_of() {
  $@ | xargs
}
silent_run_of() {
  $@ > /dev/null
}
run_suite tests/runner_tests.sh
print_report
