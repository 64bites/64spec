.import source "64spec.asm"
.import source "64core/kernal.asm"
.import source "64core/memory.asm"
.const COLOR_RAM = $d800

.eval config_64spec("change_character_set", false)
// TODO: try printing on a different screen to not screw up test results.
sfspec: :init_spec()

with_default_settings:
// TODO: capture and restore default settings
render_result_prints_success_message_in_green_when_all_tests_passed:
  :store_assertions_count 
  :store_column_and_row
  :set_assertions_count #5: #5
  :set_column_and_row #0: #0
  :render_results()
  :restore_column_and_row
  :restore_assertions_count 

.var expected_default_success_text_length = expected_default_success_text_end - expected_default_success_text
  :assert_bytes_equal #expected_default_success_text_length: expected_default_success_text: $0400 + 40*1 + 0
  :copy(expected_default_success_text_length, COLOR_RAM + 40*1 + 0, colors)
    ldy #GREEN
    ldx #expected_default_success_text_length
  !loop:
    lda colors - 1, X
    and #%00001111
    sta colors - 1, X
    tya
    sta expected_colors - 1, X
    dex
    bne !loop-
  :assert_bytes_equal #expected_default_success_text_length: colors: expected_colors
  

render_result_changes_border_color_to_green_when_all_tests_passed:
  :store_assertions_count 
  :store_column_and_row
  :set_assertions_count #5: #5
  :set_column_and_row #0: #0
  :render_results()
  lda $d020
  and #%00001111
  sta border_color
  :restore_column_and_row
  :restore_assertions_count 

  :assert_equal #GREEN: border_color

render_result_prints_partial_success_message_in_red_when_some_tests_passed:
  :store_assertions_count 
  :store_column_and_row
  :set_assertions_count #2304: #2313
  :set_column_and_row #0: #0
  :render_results()
  :restore_column_and_row
  :restore_assertions_count 

.var expected_default_partial_success_text_length = expected_default_partial_success_text_end - expected_default_partial_success_text
  :assert_bytes_equal #expected_default_partial_success_text_length: expected_default_partial_success_text: #$0400 + 40*1 + 0
  :copy(expected_default_partial_success_text_length, COLOR_RAM + 40*1 + 0, colors)
    ldy #RED
    ldx #expected_default_partial_success_text_length
  !loop:
    lda colors - 1, X
    and #%00001111
    sta colors - 1, X
    tya
    sta expected_colors - 1, X
    dex
    bne !loop-
  :assert_bytes_equal #expected_default_partial_success_text_length: colors: expected_colors

render_result_changes_border_color_to_red_when_some_tests_passed:
  :store_assertions_count 
  :store_column_and_row
  :set_assertions_count #5: #10
  :set_column_and_row #0: #0
  :render_results()
  lda $d020
  and #%00001111
  sta border_color
  :restore_column_and_row
  :restore_assertions_count 

  :assert_equal #RED: border_color

render_result_prints_failure_message_in_red_when_no_tests_passed:
  :store_assertions_count 
  :store_column_and_row
  :set_assertions_count #0: #65280
  :set_column_and_row #0: #0
  :render_results()
  :restore_column_and_row
  :restore_assertions_count 

.var expected_default_failure_text_length = expected_default_failure_text_end - expected_default_failure_text
  :assert_bytes_equal #expected_default_failure_text_length: expected_default_failure_text: #$0400 + 40*1 + 0
  :copy(expected_default_failure_text_length, COLOR_RAM + 40*1 + 0, colors)
    ldy #RED
    ldx #expected_default_failure_text_length
  !loop:
    lda colors - 1, X
    and #%00001111
    sta colors - 1, X
    tya
    sta expected_colors - 1, X
    dex
    bne !loop-
  :assert_bytes_equal #expected_default_failure_text_length: colors: expected_colors

render_result_changes_border_color_to_red_when_no_tests_passed:
  :store_assertions_count 
  :store_column_and_row
  :set_assertions_count #0: #$00ff
  :set_column_and_row #0: #0
  :render_results()
  lda $d020
  and #%00001111
  sta border_color
  :restore_column_and_row
  :restore_assertions_count 

  :assert_equal #RED: border_color
  :finish_spec()

.pc = * "Data"
column:
  .byte 0
row:
  .byte 0
passed_assertions_count:
  .word 0
total_assertions_count:
  .word 0
border_color:
  .byte 0
background_color:
  .byte 0
expected_default_success_text:
  .text "all tests passed: (5/5)"
expected_default_success_text_end:
expected_default_partial_success_text:
  .text "some tests passed: (2304/2313)"
expected_default_partial_success_text_end:
expected_default_failure_text:
  .text "all tests failed: (0/65280)"
expected_default_failure_text_end:
colors:
  .fill 50, 0
expected_colors:
  .fill 50, 0
   
.pseudocommand store_column_and_row {
  :kernal_plot_get column: row 
}
.pseudocommand set_column_and_row column: row {
  :kernal_plot_set column: row 
}
.pseudocommand restore_column_and_row {
  :kernal_plot_set column: row 
}
.pseudocommand store_assertions_count {
  :poke16 passed_assertions_count: sfspec._passed_assertions_count 
  :poke16 total_assertions_count: sfspec._total_assertions_count 
}

.pseudocommand set_assertions_count passed: total {
  :poke16 sfspec._passed_assertions_count: passed
  :poke16 sfspec._total_assertions_count: total
}

.pseudocommand restore_assertions_count {
  :poke16 sfspec._passed_assertions_count: passed_assertions_count 
  :poke16 sfspec._total_assertions_count: total_assertions_count 
}
