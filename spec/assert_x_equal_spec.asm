.import source "64spec.asm"

.eval config_64spec("print_immediate_result", false)
sfspec: :init_spec()

  :describe("assert_a_equal")

  :it("works for all values of X register");{
      .var x = floor(random()*256)
      .print "x = " + x + " in assert_x_equal_works_for_all_values_of_x test"
    .for (var expected = 0;expected < 256; expected++) {
      .if (x == expected) {
        ldx #x
        :assert_x_equal #expected
      } else {
        ldx #x
        :assert_x_equal #expected : _64SPEC.assertion_failed_subroutine : _64SPEC.assertion_passed_subroutine
      }
    }
  }

  :it("does not affect X register")
    .var x = floor(random()*256)
    .print "x = " + x + " in assert_x_equal_does_not_affect_x test"

    ldx #x
    .for (var expected = 0;expected < 256; expected++) {
      .if (x == expected) {
        :assert_x_equal #expected
      } else {
        :assert_x_equal #expected : _64SPEC.assertion_failed_subroutine : _64SPEC.assertion_passed_subroutine
      }
      :assert_x_equal #x
    }

  :it("does not affect Y register")
    ldy #7
    ldx #5
    :assert_x_equal #5
    :assert_x_equal #6 : _64SPEC.assertion_failed_subroutine : _64SPEC.assertion_passed_subroutine
    :assert_y_equal #7

  :it("does not affect A register")
    lda #9

    ldx #68
    :assert_x_equal #68
    :assert_x_equal #69 : _64SPEC.assertion_failed_subroutine : _64SPEC.assertion_passed_subroutine

    :assert_a_equal #9

  :it("does not affect Status register")
    php
    pla 
    sta tmp
    pha

    ldx #68

    plp

    :assert_x_equal #68
    :assert_x_equal #69 : _64SPEC.assertion_failed_subroutine : _64SPEC.assertion_passed_subroutine

    :assert_p_equal tmp

  :finish_spec()

.pc = $c000 "Data"
tmp:
  .byte 0
