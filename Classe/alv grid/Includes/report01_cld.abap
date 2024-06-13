*======================================================================*
CLASS lcl_main DEFINITION FINAL.
*======================================================================*

*======================================================================*
  PUBLIC SECTION.
*======================================================================*

    CLASS-METHODS: me RETURNING VALUE(ro_return) TYPE REF TO lcl_main.

    METHODS:
      initialization,
      run,
      alv_hotspot_click1 IMPORTING VALUE(is_row_id)    TYPE lvc_s_row
                                   VALUE(is_column_id) TYPE lvc_s_col,
      alv_toolbar1 CHANGING ct_toolbar TYPE ttb_button,
      alv_user_command1 IMPORTING iv_ucomm  TYPE sy-ucomm,
      pbo_alv,
      module_exit IMPORTING VALUE(iv_ucomm) TYPE sy-ucomm,
      pai_command_9002 IMPORTING VALUE(iv_ucomm) TYPE sy-ucomm
                       CHANGING  VALUE(cv_lifnr) TYPE lifnr,
      valida_okay_9002 RETURNING VALUE(rv_return) TYPE abap_bool,
      pai_command_9003 IMPORTING VALUE(iv_ucomm) TYPE sy-ucomm,
      get_alv_diag_fieldcat CHANGING ct_fieldcat TYPE lvc_t_fcat,
      get_alv_diag_events RETURNING VALUE(rt_events) TYPE zsttevents_alv,
      get_alv_diag_hotspot_click IMPORTING VALUE(iv_row_id)    TYPE lvc_s_row
                                           VALUE(iv_column_id) TYPE lvc_s_col,

*======================================================================*
  PRIVATE SECTION.
*======================================================================*

    CLASS-DATA mo_instance TYPE REF TO lcl_main.

*---------------------------------------------------------------------*
    " Constantes
*---------------------------------------------------------------------*
    CONSTANTS: BEGIN OF mc_screen,
                 s9000 TYPE d020s-dnum VALUE '9000',
                 s9001 TYPE d020s-dnum VALUE '9001',
                 s9002 TYPE d020s-dnum VALUE '9002',
                 s9003 TYPE d020s-dnum VALUE '9003',
               END OF mc_screen.

    CONSTANTS: BEGIN OF mc_acao,
                 back    TYPE sy-ucomm VALUE 'BACK',
                 cancel  TYPE sy-ucomm VALUE 'CANCEL',
                 exit    TYPE sy-ucomm VALUE 'EXIT',
                 refresh TYPE sy-ucomm VALUE 'REFRESH', " Atualizar ALV
                 x       TYPE sy-ucomm VALUE 'x',  " Aplicar
                 okay    TYPE sy-ucomm VALUE 'OKAY',    " Retornar Material
               END OF mc_acao.

    CONSTANTS: BEGIN OF mc_icon,
                 okay_name   TYPE icon-name VALUE 'ICON_OKAY',
                 cancel_name TYPE icon-name VALUE 'ICON_CANCEL',
                 refresh     TYPE icon_d    VALUE icon_refresh,
               END OF mc_icon.

*---------------------------------------------------------------------*
    " Variáveis
*---------------------------------------------------------------------*

*---------------------------------------------------------------------*
    " ALV
*---------------------------------------------------------------------*
    CONSTANTS: BEGIN OF mc_area,
                 alv1 TYPE scrfname VALUE 'AREA_ALV1',
                 alv2 TYPE scrfname VALUE 'AREA_ALV2',
                 alv3 TYPE scrfname VALUE 'AREA_ALV3',
                 slog TYPE scrfname VALUE 'AREA_SLOG',
               END OF mc_area.

    CONSTANTS: BEGIN OF mc_struc,
                 alv1 TYPE tabname VALUE 'tablename433', 
                 alv2 TYPE tabname VALUE 'tablename437', 
                 alv3 TYPE tabname VALUE 'tablename438', 
                 slog TYPE tabname VALUE 'tablename436', 
               END OF mc_struc.

    DATA: ob_con1 TYPE REF TO cl_gui_custom_container, " Objeto Contai.ALV1
          ob_con2 TYPE REF TO cl_gui_custom_container, " Objeto Contai.ALV2
          ob_con3 TYPE REF TO cl_gui_custom_container, " Objeto Contai.ALV3
          ob_alv1 TYPE REF TO cl_gui_alv_grid,         
          ob_alv2 TYPE REF TO cl_gui_alv_grid,        
          ob_alv3 TYPE REF TO cl_gui_alv_grid.         


*---------------------------------------------------------------------*
    " MÉTODOS
*---------------------------------------------------------------------*
    METHODS:
      show,
      set_alv1_display,
      set_alv2_display,
      set_alv3_display,
      set_alv_display IMPORTING iv_area  TYPE scrfname
                                iv_struc TYPE dd02l-tabname
                      CHANGING  co_con   TYPE REF TO cl_gui_custom_container
                                co_alv   TYPE REF TO cl_gui_alv_grid
                                ct_alv   TYPE ANY TABLE,
      get_fieldcat IMPORTING VALUE(iv_area)     TYPE scrfname
                             VALUE(iv_struc)    TYPE tabname
                   RETURNING VALUE(rt_fieldcat) TYPE lvc_t_fcat,
      set_events  IMPORTING VALUE(iv_area) TYPE scrfname
                  CHANGING  co_alv         TYPE REF TO cl_gui_alv_grid,
      get_variant IMPORTING VALUE(iv_area)    TYPE scrfname
                  RETURNING VALUE(rs_variant) TYPE disvariant,
      get_layout IMPORTING VALUE(iv_area)   TYPE scrfname
                 RETURNING VALUE(rs_layout) TYPE lvc_s_layo,
      get_excluding IMPORTING VALUE(iv_area)      TYPE scrfname
                    RETURNING VALUE(rt_excluding) TYPE ui_functions,
      get_alv_multiple_index IMPORTING VALUE(io_alv)      TYPE REF TO cl_gui_alv_grid
                                       VALUE(iv_validate) TYPE abap_bool DEFAULT abap_true
                             RETURNING VALUE(rt_rows)     TYPE lvc_t_row,

*======================================================================*
ENDCLASS.
*======================================================================*
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*======================================================================*
CLASS cl_event_receiver1 DEFINITION FINAL.
*======================================================================*

*======================================================================*
  PUBLIC SECTION.
*======================================================================*

    METHODS:

      handle_hotspot_click
                    FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id,

      handle_toolbar
                    FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,

      handle_user_command
                    FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm.

*======================================================================*
ENDCLASS.
*======================================================================*
