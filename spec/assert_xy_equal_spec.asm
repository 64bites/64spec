.import source "64spec.asm"

.eval config_64spec("print_immediate_result", false)
sfspec: :init_spec()

  :describe("assert_xy_equal")

  :it("works for all values of X and Y register") 
  {
    .var x = floor(random()*256)
    .print "x = " + x + " in assert_xy_equal works for all values of y test"
    ldx #x
    .for (var expected = 0;expected < 256; expected++) {
      ldy #expected
      .if (x == expected) {
        :assert_xy_equal
      } else {
        :assert_xy_equal _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
      }
    }
  }

  :it("does not affect X register")
    .var x = floor(random()*256)
    .print "x = " + x + " in assert_xy_equal_does_not_affect_x test"

    ldx #x
    ldy #x
    :assert_xy_equal
    ldy #x + 1
    :assert_xy_equal _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    :assert_x_equal #x

  :it("does not affect Y register")
    .var y = floor(random()*256)
    .print "y = " + y + " in assert_xy_equal_does_not_affect_y test"

    ldy #y
    ldx #y
    :assert_xy_equal
    ldx #y + 1
    :assert_xy_equal _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    :assert_y_equal #y

  :it("does not affect A register")
    lda #5
    ldx #7
    ldy #7
    :assert_xy_equal
    ldy #6
    :assert_xy_equal _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    :assert_a_equal #5

  :it("does not affect Status register")
    php
    pla 
    sta tmp
    pha

    ldy #68
    ldx #68

    plp

    :assert_xy_equal
    :assert_p_equal tmp
    php
    pla 
    sta tmp
    pha
    ldx #69
    plp
    :assert_xy_equal _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine


  :finish_spec()

.pc = $c000 "Data"
tmp:
  .byte 0

