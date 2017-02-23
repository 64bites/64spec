.import source "64spec.asm"

sfspec: :init_spec()

assert_y_not_equal_works_for_all_values_of_y: {
    .var y = floor(random()*256)
    .print "y = " + y + " in assert_y_not_equal_works_for_all_values_of_y test"
  .for (var expected = 0;expected < 256; expected++) {
    .if (y != expected) {
      ldy #y
      :assert_y_not_equal #expected
    } else {
      ldy #y
      :assert_y_not_equal #expected: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    }
  }
}

assert_y_not_equal_does_not_affect_y:
  .var y = floor(random()*256)
  .print "y = " + y + " in assert_y_not_equal_does_not_affect_y test"

  ldy #y
  .for (var expected = 0;expected < 256; expected++) {
    .if (y != expected) {
      :assert_y_not_equal #expected
    } else {
      :assert_y_not_equal #expected: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    }
    :assert_y_equal #y
  }

  :finish_spec()

