.import source "64spec.asm"

.eval config_64spec("print_immediate_result", false)
sfspec: :init_spec()
  :describe("assert_a_zero")

  :it("works for all values of A register");{
    .for (var a = 0; a < 256; a++) {
      .if (a == 0) {
        lda #a
        :assert_a_zero 
      } else {
        lda #a
        :assert_a_zero _64SPEC.assertion_failed_subroutine : _64SPEC.assertion_passed_subroutine
      }
    }
  }

  :it("does not affect A register");{
    .for (var a = 0; a < 256; a++) {
      lda #a
      .if (a == 0) {
        :assert_a_zero 
      } else {
        :assert_a_zero _64SPEC.assertion_failed_subroutine : _64SPEC.assertion_passed_subroutine
      }
      :assert_a_equal #a
    }
  }

  :finish_spec()

