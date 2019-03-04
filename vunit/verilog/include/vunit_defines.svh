// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2015-2016, Lars Asplund lars.anders.asplund@gmail.com

`define WATCHDOG(runtime) \
   initial begin \
      __runner__.watchdog((runtime) / 1ns); \
   end

`define TEST_SUITE_FROM_PARAMETER(parameter_name) \
   parameter string parameter_name = ""; \
   import vunit_pkg::*; \
   initial \
     if (__runner__.setup(parameter_name)) \
      while (__runner__.loop)

`define TEST_SUITE `TEST_SUITE_FROM_PARAMETER(runner_cfg)
`define NESTED_TEST_SUITE `TEST_SUITE_FROM_PARAMETER(nested_runner_cfg)

`define TEST_CASE(test_name) if (__runner__.run(test_name))

`define TEST_SUITE_SETUP if (__runner__.is_test_suite_setup())
`define TEST_SUITE_CLEANUP if (__runner__.is_test_suite_cleanup())

`define TEST_CASE_SETUP if (__runner__.is_test_case_setup())
`define TEST_CASE_CLEANUP if (__runner__.is_test_case_cleanup())
`define __ERROR_FUNC(msg) $error(msg)
`define CREATE_MSG(full_msg,func_name,got,expected,msg=__none__) \
	string __none__; \
	string full_msg; \
	$sformat(full_msg, "%s failed! Got %0d expected %0d. %s", func_name, got, expected, msg); 
`define CHECK_EQUAL(got,expected,msg=__none__) \
        assert ((got) === (expected)) else \
          begin \
			 `CREATE_MSG(full_msg, "CHECK_EQUAL", got, expected, msg); \
             `__ERROR_FUNC(full_msg); \
          end
`define CHECK_NOT_EQUAL(got,expected,msg=__none__) \
        assert ((got) !== (expected)) else \
          begin \
             `CREATE_MSG(full_msg, "CHECK_NOT_EQUAL", got, expected, msg); \
             `__ERROR_FUNC(full_msg); \
          end
`define CHECK_GREATER(got,expected,msg=__none__) \
        assert ((got) > (expected)) else \
          begin \
             `CREATE_MSG(full_msg, "CHECK_GREATER", got, expected, msg); \
             `__ERROR_FUNC(full_msg); \
          end
`define CHECK_LESS(got,expected,msg=__none__) \
        assert ((got) < (expected)) else \
          begin \
             `CREATE_MSG(full_msg, "CHECK_LESS", got, expected, msg); \
             `__ERROR_FUNC(full_msg); \
          end
`define CHECK_EQUAL_VARIANCE(got,expected,variance,msg=__none__) \
        assert (((got) < ((expected) + (variance))) && ((got) > ((expected) - (variance)))) else \
          begin \
             string __none__; \
             string full_msg; \
             $sformat(full_msg, "CHECK_EQUAL_VARIANCE failed! Got %0d expected %0d +- %0d. %s", got, expected, variance, msg); \
             `__ERROR_FUNC(full_msg); \
          end