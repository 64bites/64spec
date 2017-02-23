.import source "64spec.asm"

.eval config_64spec("print_immediate_result", false)
sfspec: :init_spec()

  :describe("assert_a_equal")

  :it("works for all values of A register");{
    .var a = floor(random()*256)
    .print "a = " + a + " in assert_equal test"
    .for (var b = 0;b < 256; b++) {
      .if (a == b) {
        :assert_equal #a: #b
        :assert_equal #b: #a
      } else {
        :assert_equal #a: #b: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
        :assert_equal #b: #a: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
      }
    }
  }

  :it("does not affect A register"); {
    lda #5
    :assert_equal #3: #3
    :assert_equal #4: #6: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

    :assert_a_equal #5
  }

  :it("does not affect X register")
    ldx #5
    :assert_equal #3: #3
    :assert_equal #4: #6: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

    :assert_x_equal #5

  :it("does not affect Y register") 
    ldy #5
    :assert_equal #3: #3
    :assert_equal #4: #6: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

    :assert_y_equal #5

  :it("does not affect Status register")
    php
    pla 
    sta tmp
    pha
    plp
    :assert_equal #3: #3
    :assert_p_equal tmp

  :finish_spec()

.pc = * "Data"
tmp:
  .byte 0
