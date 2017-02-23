.import source "64spec.asm"

.eval config_64spec("print_immediate_result", false)
sfspec: :init_spec()

  :describe("assert_a_equal")

  :it("works for all values of A register");{
    .var a = floor(random()*256)
    .print "a = " + a + " in assert_a_equal_works_for_all_values_of_a test"
    .for (var expected = 0;expected < 256; expected++) {
      .if (a == expected) {
        lda #a
        :assert_a_equal #expected
      } else {
        lda #a
        :assert_a_equal #expected: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
      }
    }
  }

  :it("does not affect A register")
    .var a = floor(random()*256)
    .print "a = " + a + " in assert_a_equal_does_not_affect_a test"

    lda #a
    .for (var expected = 0;expected < 256; expected++) {
      .if (a == expected) {
        :assert_a_equal #expected
      } else {
        :assert_a_equal #expected: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
      }
      :assert_a_equal #a
    }

  :it("does not affect X register")
    ldx #7
    lda #5
    :assert_a_equal #5
    :assert_a_equal #6: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    :assert_x_equal #7


  :it("does not affect Y register")
    ldy #9

    lda #68
    :assert_a_equal #68
    :assert_a_equal #69: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

    :assert_y_equal #9


  :it("does not affect Status register")
    php
    pla 
    sta tmp
    pha

    lda #68

    plp

    :assert_a_equal #68
    :assert_a_equal #69: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

    :assert_p_equal tmp

  :finish_spec()

.pc = $c000 "Data"
tmp:
  .byte 0

