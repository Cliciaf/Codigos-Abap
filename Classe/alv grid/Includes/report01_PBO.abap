*&---------------------------------------------------------------------*
*&      Module  PBO_STATUS  OUTPUT
*&---------------------------------------------------------------------*
MODULE pbo_status OUTPUT.
  SET PF-STATUS sy-dynnr.
  SET TITLEBAR sy-dynnr.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_ALV  OUTPUT
*&---------------------------------------------------------------------*
MODULE pbo_alv OUTPUT.

  lcl_main=>me( )->pbo_alv( ).

ENDMODULE.
