.import source "64spec.asm"

.eval config_64spec("print_immediate_result", false)
sfspec: :init_spec()

  :describe("assert_unsigned_less_or_equal")

  :it("works for edge cases"); {
    :assert_unsigned_less #0: #1
    :assert_unsigned_less #1: #0: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

    :assert_unsigned_less #1: #2
    :assert_unsigned_less #2: #1: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

    :assert_unsigned_less #0: #255
    :assert_unsigned_less #255: #0: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

    :assert_unsigned_less #0: #0: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    :assert_unsigned_less #5: #5: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    :assert_unsigned_less #255: #255: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
  }

  :it("works for same values"); {
    .for (var b = 0;b < 256; b++) {
      :assert_unsigned_less #b: #b: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    }
  }
  :it("works for different values"); {
    .var a = floor(random()*256)
    .print "a = " + a + " in assert_equal test"
    .for (var b = 0;b < 256; b++) {
      .if (a < b) {
        :assert_unsigned_less #a: #b
        :assert_unsigned_less #b: #a: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
      } else .if (a > b) {
        :assert_unsigned_less #a: #b: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
        :assert_unsigned_less #b: #a
      }
    }
  }

  :it("does not affect A register") 
    lda #5

    :assert_unsigned_less #4: #6
    :assert_unsigned_less #6: #4: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    :assert_unsigned_less #6: #6: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

    :assert_a_equal #5

  :it("does not affect X register")
    ldx #5

    :assert_unsigned_less #4: #6
    :assert_unsigned_less #6: #4: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    :assert_unsigned_less #6: #6: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

    :assert_x_equal #5

  :it("does not affect Y register") 
    ldy #5

    :assert_unsigned_less #4: #6
    :assert_unsigned_less #6: #4: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    :assert_unsigned_less #6: #6: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

    :assert_y_equal #5

  :it("does not affect Status register")
    php
    pla 
    sta tmp
    pha
    plp

    :assert_unsigned_less #4: #6
    :assert_unsigned_less #6: #4: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    :assert_unsigned_less #6: #6: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

    :assert_p_equal tmp

  :finish_spec()

.pc = * "Data"
tmp:
  .byte 0
