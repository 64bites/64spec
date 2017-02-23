.import source "64spec.asm"

sfspec: :init_spec()

assert_x_zero_works_for_all_values_of_x: {
  .for (var x = 0; x < 256; x++) {
    .if (x == 0) {
      ldx #x
      :assert_x_zero 
    } else {
      ldx #x
      :assert_x_zero _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    }
  }
}

assert_x_zero_does_not_affect_x:
  .for (var x = 0; x < 256; x++) {
    ldx #x
    .if (x == 0) {
      :assert_x_zero 
    } else {
      :assert_x_zero _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    }
    :assert_x_equal #x
  }

  :finish_spec()

