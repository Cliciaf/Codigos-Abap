*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
MODULE exit INPUT.

  lcl_main=>me( )->module_exit( v_ucomm ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
MODULE pai_command_9002 INPUT.

  lcl_main=>me( )->pai_command_9002( EXPORTING iv_ucomm = v_ucomm
                                      CHANGING cv_lifnr = v_scr-lifnr ).

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  PAI_COMMAND_9003  INPUT
*&---------------------------------------------------------------------*
MODULE pai_command_9003 INPUT.

  lcl_main=>me( )->pai_command_9003( iv_ucomm = v_ucomm ).

ENDMODULE.

