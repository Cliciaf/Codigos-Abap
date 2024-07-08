DATA(date) = sy-datum.
DATA(lv_exit) = ''.
WHILE lv_exit NE 'X'.
  CALL FUNCTION 'DATE_CHECK_WORKINGDAY'
    EXPORTING
      date                       = date
      factory_calendar_id        = '01'
      message_type               = 'E'
    EXCEPTIONS
      date_after_range           = 1
      date_before_range          = 2
      date_invalid               = 3
      date_no_workingday         = 4
      factory_calendar_not_found = 5
      message_type_invalid       = 6
      OTHERS                     = 7.
  CASE sy-subrc.
    WHEN 3.
      WRITE: / 'Invalid date', date.
      IF date+4(2) > 12.
        date+6(2) = 01.
        date+4(2) = 01.
        date(4) = date(4) + 1.
      ENDIF.
      date+4(2) = date+4(2) + 1.
      date+6(2) = 01.
    WHEN 4.
      WRITE: / 'Not Working Day', date.
      date+6(2) = date+6(2) + 1.
    WHEN OTHERS.
      WRITE: / 'Dia util', date.
      lv_exit = 'X'.
  ENDCASE.

ENDWHILE.