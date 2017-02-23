.import source "64spec.asm"
.import source "64core/memory.asm"
.import source "64core/math.asm"

.eval config_64spec("print_immediate_result", false)
sfspec: :init_spec()
  
  :describe("assert_bytes_equal")

  :it("passes when comparing empty arrays")
    :assert_bytes_equal 0: a: b
  :it("passes when comparing arrays with same elements")
    :assert_bytes_equal 1: a: b
  :it("fails if arrays have different values")
    :assert_bytes_equal 2: a: b: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine

  :it("can compare large arrays") 
    :assert_bytes_equal 3*256: ascending1: ascending2
  :it("fails if any element is different"); {
    .var bytes_count = 256*2 +47
      :poke ascending1+bytes_count: #23
      :poke ascending2+bytes_count: #32
    {
    loop:
      :inc16 dec_value
      :inc16 inc_value
      :cmp_eq16 dec_value: #[ascending2 + bytes_count]
      beq end
      .label dec_value = * + 1
      dec ascending2 - 1
      :assert_bytes_equal bytes_count: ascending1: ascending2: _64SPEC.assertion_failed_subroutine: _64SPEC.assertion_passed_subroutine
      ldx pos
      .label inc_value = * + 1
      inc ascending2 - 1, X
      jmp loop
    end:
    } 
    :poke ascending1+bytes_count: #256
    :poke ascending2+bytes_count: #256
  }
  
  
  :finish_spec()

.pc = * "Data"
  .byte 23
a:
  .byte 5
  .byte 24
b:
  .byte 5
  .byte 25
pos:
  .word 0

  .byte 26
ascending1:
  .fill 3*256, i
  .byte 27
ascending2:
  .fill 3*256, i
  .byte 28
