.import source "64spec.asm"

/*.eval config_64spec("change_context_description_color", true)*/
/*.eval config_64spec("change_example_description_color", true)*/
/*.eval config_64spec("print_immediate_result", false)*/

/*.eval config_64spec("print_context_description", false)*/
/*.eval config_64spec("print_example_description", false)*/
/*.eval config_64spec("print_immediate_result", true)*/
sfspec: :init_spec()
  
:describe("assert_pass")
  :it("always passes")
    :assert_pass
    :assert_pass _64SPEC.assertion_passed_subroutine: _64SPEC.assertion_failed_subroutine

  :it("does not affect A register")
    lda #4
    :assert_pass
    :assert_a_equal #4 

  :it("does not affect X register")
    ldx #4
    :assert_pass
    :assert_x_equal #4 

  :it("does not affect Y register")
    ldy #4
    :assert_pass
    :assert_y_equal #4 

  :it("does not affect Status register")
    sed
    php
    pla 
    sta tmp
    pha
    plp

    :assert_pass
    :assert_p_equal tmp
    cld

  :describe("assert_fail")

  :it("always fails")
    :assert_fail _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

  :it("does not affect A register")
    lda #4
    :assert_fail _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    :assert_a_equal #4 

  :it("does not affect X register")
    ldx #4
    :assert_fail _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    :assert_x_equal #4 

  :it("does not affect Y register")
    ldy #4
    :assert_fail _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    :assert_y_equal #4 

  :it("does not affect Status register")
    sed
    php
    pla 
    sta tmp
    pha
    plp

    :assert_fail _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    cld

  :finish_spec()

.pc = * "Data"
tmp:
  .byte 0

