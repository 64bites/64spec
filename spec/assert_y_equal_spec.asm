.import source "64spec.asm"

sfspec: :init_spec()

assert_y_equal_works_for_all_values_of_y: {
    .var y = floor(random()*256)
    .print "y = " + y + " in assert_y_equal_works_for_all_values_of_y test"
  .for (var expected = 0;expected < 256; expected++) {
    .if (y == expected) {
      ldy #y
      :assert_y_equal #expected
    } else {
      ldy #y
      :assert_y_equal #expected: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    }
  }
}

assert_y_equal_does_not_affect_y:
  .var y = floor(random()*256)
  .print "y = " + y + " in assert_y_equal_works_for_all_values_of_y test"

  ldy #y
  .for (var expected = 0;expected < 256; expected++) {
    .if (y == expected) {
      :assert_y_equal #expected
    } else {
      :assert_y_equal #expected: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    }
    :assert_y_equal #y
  }

assert_y_equal_does_not_affect_x:
  ldx #7
  ldy #5
  :assert_y_equal #5
  :assert_y_equal #6: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
  :assert_x_equal #7

assert_y_equal_does_not_affect_a:
  lda #9
  ldy #68
  :assert_y_equal #68
  :assert_y_equal #69: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
  :assert_a_equal #9

  :finish_spec()

