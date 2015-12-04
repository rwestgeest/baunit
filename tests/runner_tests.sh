# ======================= runnner testss ===========
test_runs_multiple_tests_in_a_suite() {
  assert_equals "wasRun 2wasRun" "$(single_line_log_of a_suite with_2_tests)"
}
test_runs_all_tests_even_if_one_fails() {
  assert_equals "2wasRun" "$(single_line_log_of a_suite where_first_fails)"
}
test_returns_1_on_failure() {
  assert_equals 1 $(silent_run_of a_suite where_first_fails)$? 
}
test_returns_0_on_success() {
  assert_equals 0 $(silent_run_of a_suite with_2_tests)$? 
}

test_runs_setup_before_each_test_if_available() {
  assert_equals "setup wasRun setup 2wasRun" "$(single_line_log_of a_suite with_2_tests_and_setup)"
}
test_runs_teardown_after_each_test_if_available() {
  assert_equals "wasRun teardown 2wasRun teardown" "$(single_line_log_of a_suite with_2_tests_and_teardown)"
}
test_runs_teardown_even_if_test_fails() {
  assert_equals "failureWasRun teardown" "$(single_line_log_of a_suite with_failing_test_and_teardown)"
}

test_fails_on_error() {
  assert_equals 1 $(silent_run_of a_suite with_an_error)$?
  assert_equals "Failure!; run: 1, failed: 1" "$(
      silent_run_of a_suite with_an_error
      print_report
    )"
}

# ================= report tests ================
test_print_report_shows_number_of_tests_run_and_failed_on_success() {
  assert_equals "Success!; run: 2, failed: 0" "$(
      silent_run_of a_suite with_2_tests
      print_report
    )"
}
test_print_report_shows_number_of_tests_run_and_failed_on_failure() {
  assert_equals "Failure!; run: 2, failed: 1" "$(
      silent_run_of a_suite where_first_fails
      print_report
    )"
}


# =================== assert tests ====================
test_assert_equals_shows_a_message_on_failure() {
  assert_equals "Expected: 1, but was: 0" "$(assert_equals 1 0)"
  assert_equals "Expected: 0, but was: 1" "$(assert_equals 0 1)"
}
test_assert_equals_is_silent_on_success() {
  assert_equals "" "$(assert_equals 0 0)"
}
test_assert_equals_exits_with_1_on_failure() {
  assert_equals 1 $(silent_run_of assert_equals 1 0)$? 
}
test_assert_equals_exits_with_0_on_success() {
  assert_equals 0 $(silent_run_of assert_equals 0 0)$?
}
test_assert_equals_works_with_multi_line_strings() {
  assert_equals 0 $(assert_equals "my string" "my string")$? 
}
