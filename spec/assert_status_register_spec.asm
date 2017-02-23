.import source "64spec.asm"

.eval config_64spec("print_immediate_result", false)
/*.eval config_64spec("print_context_description", false)*/
sfspec: :init_spec()

  :describe("assert_p_has_masked_bits_set")
  
  :it("passes if all masked bits are set")
    php
    pla
    sta tmp
    pha
    plp

    php

    :assert_p_has_masked_bits_set tmp
  
    sei
    sec
    sed
    :assert_p_has_masked_bits_set #%00001101: _64SPEC.assertion_passed_subroutine: _64SPEC.assertion_failed_subroutine

    lda #%10101010
    pha
    plp
    :assert_p_has_masked_bits_set #%10101010: _64SPEC.assertion_passed_subroutine: _64SPEC.assertion_failed_subroutine

    plp


  :it("fails if at least one of masked bits is not set")
    php
    sei
    sec
    sed
    php

    cld
    :assert_p_has_masked_bits_set #%00001101: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    plp
    php

    clc
    :assert_p_has_masked_bits_set #%00001101: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    plp
    php

    cli
    :assert_p_has_masked_bits_set #%00001101: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    plp
    php

    cld
    clc
    :assert_p_has_masked_bits_set #%00001101: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    plp
    php

    cld
    clc
    cli
    :assert_p_has_masked_bits_set #%00001101: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    plp
    plp
  
  :describe("assert_p_has_masked_bits_cleared")
  :it("passes if all masked bits are cleared")
    php
    pla
    sta tmp
    pha
    eor #$ff
    sta tmp
    plp

    php

    :assert_p_has_masked_bits_cleared tmp
    
    cli
    clc
    cld
    :assert_p_has_masked_bits_cleared #%00001101

    lda #%10111010
    pha
    plp
    :assert_p_has_masked_bits_cleared #%01000101

    plp

// TODO: look at the case with lda #%10101010 - problems with B flag. See http://homepage.ntlworld.com/cyborgsystems/CS_Main/6502/6502.htm#FLG-B
.print "Warning: Bits cleared does not work with %10101010 being passed. B (%00010000) flag is being set anyway"


  :it("fails if at least one of masked bits is not set")
    php
    cli
    clc
    cld
    php

    sed
    :assert_p_has_masked_bits_cleared #%00001101: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    plp
    php

    sec
    :assert_p_has_masked_bits_cleared #%00001101: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    plp
    php

    sei
    :assert_p_has_masked_bits_cleared #%00001101: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    plp
    php

    sed
    sec
    :assert_p_has_masked_bits_cleared #%00001101: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    plp
    php

    sed
    sec
    sei
    :assert_p_has_masked_bits_cleared #%00001101: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    plp
    plp


  :describe("assert_p_equal")
  
  :it("passes if Status register is equal to specified value")
    php
    pla 
    sta tmp
    pha
    plp
    :assert_p_equal tmp: _64SPEC.assertion_passed_subroutine: _64SPEC.assertion_failed_subroutine

  :it("passes if Status register is not equal to specified value")
    sec
    php
    pla 
    sta tmp
    pha
    plp
    clc
    :assert_p_equal tmp: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

  :it("does not affect A register")
    php
    pla 
    sta tmp
    pha
    lda #$fe
    plp
    :assert_p_equal tmp
    :assert_a_equal #$fe
  
  :it("does not affect Status register")
    sed
    php
    pla 
    sta tmp
    pha
    plp
    :assert_p_equal tmp: _64SPEC.assertion_passed_subroutine: _64SPEC.assertion_failed_subroutine
    :assert_p_equal tmp: _64SPEC.assertion_passed_subroutine: _64SPEC.assertion_failed_subroutine
    cld



  :describe("assert_z_set")

  :it("passes when Z flag is set")
    lda #0
    :assert_z_set 

  :it("fails when Z flag is cleared")
    lda #1
    :assert_z_set _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

  :describe("assert_z_cleared")

  :it("passes when Z flag is cleared")
    lda #1
    :assert_z_cleared 

  :it("fails when Z flag is set")
    lda #0
    :assert_z_cleared _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

  :describe("assert_z_set")

  :it("passes when Carry flag is set")
    sec
    :assert_c_set 

  :it("fails when Carry flag is cleared")
    clc
    :assert_c_set _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

  :describe("assert_z_cleared")

  :it("passes when Carry flag is cleared")
    clc
    :assert_c_cleared 

  :it("fails when Carry flag is set")
    sec
    :assert_c_cleared _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

  :describe("assert_d_set")

  :it("passes when Decimal flag is set")
    sed
    :assert_d_set 
    cld

  :it("fails when Decimal flag is cleared")
    cld
    :assert_d_set _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

  :it("does not affect A register")
    lda #4
    sed
    :assert_d_set 
    :assert_a_equal #4
    cld

  :describe("assert_d_cleared")

  :it("passes when Decimal flag is cleared")
    cld
    :assert_d_cleared 

  :it("fails when Decimal flag is set")
    sed
    :assert_d_cleared _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    cld

  :it("does not affect A register")
    lda #4
    cld
    :assert_d_cleared 
    :assert_a_equal #4

  :describe("assert_i_set")

  :it("passes when I flag is set")
    sei
    :assert_i_set 
    cli

  :it("fails when I flag is cleared")
    cli
    :assert_i_set _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

  :it("does not affect A register")
    lda #4
    sei
    :assert_i_set 
    :assert_a_equal #4
    cli

  :describe("assert_i_cleared")

  :it("passes when I flag is cleared")
    cli
    :assert_i_cleared 

  :it("fails when I flag is set")
    sei
    :assert_i_cleared _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
    cli

  :it("does not affect A register")
    lda #4
    cli
    :assert_i_cleared 
    :assert_a_equal #4


  :describe("assert_n_set")

  :it("passes when N flag is set")
    lda #-1
    :assert_n_set 

  :it("fails when N flag is cleared")
    lda #1
    :assert_n_set _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

  :it("does not affect A register")
    lda #4
    ldx #-1
    :assert_n_set 
    :assert_a_equal #4

  :describe("assert_n_cleared")

  :it("passes when N flag is cleared")
    lda #1
    :assert_n_cleared 

  :it("fails when N flag is set")
    lda #-1
    :assert_n_cleared _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

  :it("does not affect A register")
    lda #-4
    ldx #1
    :assert_n_cleared 
    :assert_a_equal #-4

  :describe("assert_v_set")

  :it("passes when V flag is set")
    bit byte_with_bit_6_set
    :assert_v_set 

  :it("fails when V flag is cleared")
    clv
    :assert_v_set _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

  :it("does not affect A register")
    lda #4
    bit byte_with_bit_6_set
    :assert_v_set 
    :assert_a_equal #4

  :describe("assert_v_cleared")

  :it("passes when V flag is cleared")
    clv
    :assert_v_cleared 

  :it("fails when V flag is set")
    bit byte_with_bit_6_set
    :assert_v_cleared _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

  :it("does not affect A register")
    lda #4
    clv
    :assert_v_cleared 
    :assert_a_equal #4

  :finish_spec()

.pc = * "Subroutines"

tmp:
  .byte 0

byte_with_bit_6_set:
  .byte %01000000


