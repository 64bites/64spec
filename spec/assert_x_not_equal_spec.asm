.import source "64spec.asm"

sfspec: :init_spec()

assert_x_not_equal_works_for_all_values_of_x: {
    .var x = floor(random()*256)
    .print "x = " + x + " in assert_x_not_equal_works_for_all_values_of_x test"
  .for (var expected = 0;expected < 256; expected++) {
    .if (x != expected) {
      ldx #x
      :assert_x_not_equal #expected
    } else {
      ldx #x
      :assert_x_not_equal #expected: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    }
  }
}

assert_x_not_equal_does_not_affect_x:
  .var x = floor(random()*256)
  .print "x = " + x + " in assert_x_not_equal_works_for_all_values_of_x test"

  ldx #x
  .for (var expected = 0;expected < 256; expected++) {
    .if (x != expected) {
      :assert_x_not_equal #expected
    } else {
      :assert_x_not_equal #expected: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    }
    :assert_x_equal #x
  }

  :finish_spec()

