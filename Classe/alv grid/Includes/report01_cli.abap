*&---------------------------------------------------------------------*
*&  Include           ZSTMMR296_CLI
*&---------------------------------------------------------------------*
*======================================================================*
CLASS lcl_main IMPLEMENTATION.
*======================================================================*
*&---------------------------------------------------------------------*
*&      METHOD ME
*&---------------------------------------------------------------------*
  METHOD me.

    IF mo_instance IS NOT BOUND.
      CREATE OBJECT mo_instance.
    ENDIF.

    ro_return = mo_instance.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD INITIALIZATION
*&---------------------------------------------------------------------*
  METHOD initialization.

[autority check]
[initial checks]
    IF sy-subrc <> 0.
      LEAVE PROGRAM.
    ENDIF.


  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD RUN
*&---------------------------------------------------------------------*
  METHOD run.

    IF mo_armazem_gt->cockpit_run( sy-repid ) .
      me->show( ).
    ENDIF.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD SHOW
*&---------------------------------------------------------------------*
  METHOD show.

    mt_alv1 = mo_armazem_gt->cockpit_get_data( ).

    IF  p_fiori IS NOT INITIAL.

      "Processo Fiori

    ELSE.

      IF mt_alv1 IS NOT INITIAL.
        CALL SCREEN mc_screen-s9000.
      ELSE.
        MESSAGE i000 WITH TEXT-i01.
      ENDIF.

    ENDIF.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD SET_ALV1_DISPLAY
*&---------------------------------------------------------------------*
  METHOD set_alv1_display.

    me->set_alv_display( EXPORTING
                           iv_area  = mc_area-alv1
                           iv_struc = mc_struc-alv1
                         CHANGING
                           co_con   = ob_con1
                           co_alv   = ob_alv1
                           ct_alv   = mt_alv1 ).

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD SET_ALV2_DISPLAY
*&---------------------------------------------------------------------*
  METHOD set_alv2_display.

    me->set_alv_display( EXPORTING
                           iv_area  = mc_area-alv2
                           iv_struc = mc_struc-alv2
                         CHANGING
                           co_con   = ob_con2
                           co_alv   = ob_alv2
                           ct_alv   = mt_alv2 ).

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD SET_ALV3_DISPLAY
*&---------------------------------------------------------------------*
  METHOD set_alv3_display.

    me->set_alv_display( EXPORTING
                           iv_area  = mc_area-alv3
                           iv_struc = mc_struc-alv3
                         CHANGING
                           co_con   = ob_con3
                           co_alv   = ob_alv3
                           ct_alv   = mt_alv3 ).

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD SET_ALV_DISPLAY
*&---------------------------------------------------------------------*
  METHOD set_alv_display.

    IF co_con IS INITIAL.

      CREATE OBJECT co_con
        EXPORTING
          container_name = iv_area.

      CREATE OBJECT co_alv
        EXPORTING
          i_appl_events = abap_true
          i_parent      = co_con.

      DATA(lt_fieldcat) = me->get_fieldcat( iv_area = iv_area iv_struc = iv_struc ).

      co_alv->set_table_for_first_display(
                 EXPORTING
                   i_default            = abap_on
                   i_save               = 'A'
                   is_variant           = me->get_variant( iv_area )
                   is_layout            = me->get_layout( iv_area )
                   it_toolbar_excluding = me->get_excluding( iv_area )
                 CHANGING
                   it_outtab            = ct_alv[]
                   it_fieldcatalog      = lt_fieldcat ).

      me->set_events( EXPORTING iv_area = iv_area CHANGING co_alv = co_alv ).

    ENDIF. " End Container is active

    "Diferenciar Botão Standard de Z
    IF v_ucomm(1) <> '%'.
      co_alv->refresh_table_display( EXPORTING is_stable = VALUE #( row = abap_on col = abap_on ) ).
    ENDIF.

    CASE iv_area.
      WHEN mc_area-alv1.
        IF mt_alv1_rows IS NOT INITIAL.
          co_alv->set_selected_rows( it_index_rows = mt_alv1_rows ).
          FREE mt_alv1_rows.
        ENDIF.
    ENDCASE.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD GET_FIELDCAT
*&---------------------------------------------------------------------*
  METHOD get_fieldcat.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = iv_struc
      CHANGING
        ct_fieldcat      = rt_fieldcat
      EXCEPTIONS
        OTHERS           = 1.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    LOOP AT rt_fieldcat ASSIGNING FIELD-SYMBOL(<fs_fcat>).

      CASE iv_area.

        WHEN mc_area-alv1.

          CASE <fs_fcat>-fieldname.
          
            WHEN colunm.
              IF <fs_fcat>-fieldname(6) = 'STATUS'.
                <fs_fcat>-icon       = abap_on.
                <fs_fcat>-hotspot    = abap_on.
                <fs_fcat>-fix_column = abap_on.
          ENDCASE.


        WHEN mc_area-alv2.

        WHEN mc_area-alv3.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD SET_EVENTS
*&---------------------------------------------------------------------*
  METHOD set_events.

    CASE iv_area.

      WHEN mc_area-alv1.

        DATA ob_event_receiver1 TYPE REF TO cl_event_receiver1.

        CREATE OBJECT ob_event_receiver1.

        SET HANDLER ob_event_receiver1->handle_toolbar       FOR co_alv.
        SET HANDLER ob_event_receiver1->handle_user_command  FOR co_alv.
        SET HANDLER ob_event_receiver1->handle_hotspot_click FOR co_alv.

        co_alv->set_ready_for_input( 0 ).

      WHEN mc_area-alv2.

        co_alv->set_ready_for_input( 0 ).

      WHEN mc_area-alv3.

        co_alv->set_ready_for_input( 1 ).

    ENDCASE.

  ENDMETHOD.
  *&---------------------------------------------------------------------*
*&      METHOD GET_VARIANT
*&---------------------------------------------------------------------*
  METHOD get_variant.

    CASE iv_area.
      WHEN mc_area-alv1.
        rs_variant-report  = sy-repid.
*        rs_variant-variant = .
        rs_variant-handle  = 'ALV1'.
    ENDCASE.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD GET_LAYOUT
*&---------------------------------------------------------------------*
  METHOD get_layout. "para cada area, um layout diferente

    CASE iv_area.
      WHEN mc_area-alv1.
        rs_layout-zebra      = abap_on.
        rs_layout-cwidth_opt = abap_false.
        rs_layout-sel_mode   = 'A'.
      WHEN mc_area-alv2
        OR mc_area-alv3.
        rs_layout-zebra      = abap_on.
        rs_layout-cwidth_opt = abap_off.
        rs_layout-no_rowmark = abap_on.
      WHEN mc_area-slog.
        rs_layout-zebra      = abap_on.
        rs_layout-cwidth_opt = abap_on.
        rs_layout-no_rowmark = abap_on.
    ENDCASE.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD GET_EXCLUDING
*&---------------------------------------------------------------------*
  METHOD get_excluding. "insere botões do alv que serão excluidos

    FREE rt_excluding.

    CASE iv_area.
      WHEN mc_area-alv1.
        INSERT cl_gui_alv_grid=>mc_fc_graph             INTO TABLE rt_excluding.
        INSERT cl_gui_alv_grid=>mc_fc_info              INTO TABLE rt_excluding.
      WHEN mc_area-alv2
        OR mc_area-alv3
        OR mc_area-slog.
        INSERT cl_gui_alv_grid=>mc_fc_loc_append_row    INTO TABLE rt_excluding.
        INSERT cl_gui_alv_grid=>mc_fc_loc_copy          INTO TABLE rt_excluding.
        INSERT cl_gui_alv_grid=>mc_fc_loc_copy_row      INTO TABLE rt_excluding.
        INSERT cl_gui_alv_grid=>mc_fc_loc_cut           INTO TABLE rt_excluding.
        INSERT cl_gui_alv_grid=>mc_fc_refresh           INTO TABLE rt_excluding.
    ENDCASE.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD FREE_ALV1
*&---------------------------------------------------------------------*
  METHOD free_alv1.

    ob_alv1->free( ).
    ob_con1->free( ).

    FREE: ob_alv1, ob_con1.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD ALV_HOTSPOT_CLICK1
*&---------------------------------------------------------------------*
  METHOD alv_hotspot_click1.

    ASSIGN mt_alv1[ is_row_id-index ] TO FIELD-SYMBOL(<fs_alv>).

    CHECK sy-subrc = 0.

    CASE is_column_id-fieldname.
      WHEN 'STATUS_ENV'.
        IF <fs_alv>-status_env IS NOT INITIAL.
          me->show_status_mt( iv_werks = <fs_alv>-werks iv_charg = <fs_alv>-charg iv_acao = CONV #( zstgt_acao-env_mat ) ).
        ENDIF.
      WHEN 'VBELN_OV'.
        me->call_va03( <fs_alv>-vbeln_ov ).
      WHEN 'VBELN_ESTQ_OV'.
        me->call_va03( <fs_alv>-vbeln_estq_ov ).
      WHEN 'MBLNR_ENV'.
        me->call_migo( iv_mblnr = <fs_alv>-mblnr_env iv_mjahr = <fs_alv>-mjahr_env ).
      WHEN 'DOCNUM_ENV'.
        me->call_j1b3n( <fs_alv>-docnum_env ).
      WHEN 'NFENUM_ENV'.
        me->call_j1bnfe( <fs_alv>-docnum_env ).
      WHEN 'DOCCON_ENV'.
        me->call_fb03( <fs_alv>-doccon_env ).
      WHEN 'STATUS_RET'.
        IF <fs_alv>-status_ret IS NOT INITIAL.
          me->show_status_mt( iv_werks = <fs_alv>-werks iv_charg = <fs_alv>-charg iv_acao = CONV #( zstgt_acao-ret_mat ) ).
        ENDIF.
      WHEN 'MBLNR_RET'.
        me->call_migo( iv_mblnr = <fs_alv>-mblnr_ret iv_mjahr = <fs_alv>-mjahr_ret ).
      WHEN 'DOCNUM_RET'.
        me->call_j1b3n( <fs_alv>-docnum_ret ).
      WHEN 'NFENUM_RET'.
        me->call_j1bnfe( <fs_alv>-docnum_ret ).
      WHEN 'DOCCON_RET'.
        me->call_fb03( <fs_alv>-doccon_ret ).
    ENDCASE.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD ALV_TOOLBAR1
*&---------------------------------------------------------------------*
  METHOD alv_toolbar1.

    FREE ct_toolbar.

    " Todas as Ações
    ct_toolbar = VALUE #( " Refresh
                          ( function  = mc_acao-refresh
                            icon      = mc_icon-refresh
                            butn_type = 0
                            quickinfo = TEXT-b00 )
                          " Separador
                          ( butn_type = 3 )
                          " Enviar Material
                          ( function  = 
                            icon      = 
                            butn_type = 0
                            quickinfo = TEXT-b01
                            text      = TEXT-b01 )

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD ALV_USER_COMMAND1
*&---------------------------------------------------------------------*
  METHOD alv_user_command1.

    " Necessário para o método 'set_alv_display':
    " Diferenciar Botão Standard de Z
    FREE v_ucomm.

    CASE iv_ucomm.

    ENDCASE.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD PBO_ALV
*&---------------------------------------------------------------------*
  METHOD pbo_alv.

    CASE sy-dynnr.
      WHEN mc_screen-s9001.
        me->set_alv1_display( ).
      WHEN mc_screen-s9002.
        me->set_alv2_display( ).
      WHEN mc_screen-s9003.
        me->set_alv3_display( ).
    ENDCASE.

  ENDMETHOD.
  *&---------------------------------------------------------------------*
*&      METHOD GET_ALV_MULTIPLE_INDEX
*&---------------------------------------------------------------------*
  METHOD get_alv_multiple_index.

    io_alv->get_selected_rows(
          IMPORTING
            et_index_rows = DATA(lt_rows) ).

    IF iv_validate = abap_true.
      " Valida seleção de linha
      IF lines( lt_rows ) = 0.
        " Selecione pelo menos uma linha!
        MESSAGE i000 WITH TEXT-i02.
        RETURN.
      ENDIF.
    ENDIF.

    rt_rows = lt_rows.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD MODULE_EXIT
*&---------------------------------------------------------------------*
  METHOD module_exit.

    CASE iv_ucomm.

      WHEN mc_acao-back
        OR mc_acao-exit
        OR mc_acao-cancel.

        CASE sy-dynnr.
          WHEN mc_screen-s9000.
          WHEN mc_screen-s9002.
            FREE: mt_alv2.
          WHEN mc_screen-s9003.
            FREE: mt_alv3.
        ENDCASE.

        LEAVE TO SCREEN 0.

    ENDCASE.

  ENDMETHOD.
  *&---------------------------------------------------------------------*
*&      METHOD PAI_COMMAND_9002
*&---------------------------------------------------------------------*
  METHOD pai_command_9002.

    CASE iv_ucomm.

      WHEN mc_acao-okay.

        ob_alv2->check_changed_data( ).

          LEAVE TO SCREEN 0.

    ENDCASE.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD PAI_COMMAND_9003
*&---------------------------------------------------------------------*
  METHOD pai_command_9003.

    CASE iv_ucomm.

      WHEN mc_acao-okay.
          LEAVE TO SCREEN 0.
    ENDCASE.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD GET_ALV_DIAG_FIELDCAT
*&---------------------------------------------------------------------*
  METHOD get_alv_diag_fieldcat.

    LOOP AT ct_fieldcat ASSIGNING FIELD-SYMBOL(<fs>).
      CASE <fs>-fieldname.
        WHEN 'x'
          <fs>-hotspot = abap_on.
        WHEN 'y'
          <fs>-no_out = abap_on.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD GET_ALV_DIAG_EVENTS
*&---------------------------------------------------------------------*
  METHOD get_alv_diag_events.

    rt_events = VALUE #( ( 'HOTSPOT_CLICK' ) ).

  ENDMETHOD.
*&---------------------------------------------------------------------*
*&      METHOD GET_ALV_DIAG_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
  METHOD get_alv_diag_hotspot_click.

    ASSIGN table[ iv_row_id-index ] TO FIELD-SYMBOL(<fs>).

    CHECK sy-subrc = 0.

    CASE iv_column_id-fieldname.
      WHEN 'x'.
      WHEN 'y'.
    ENDCASE.

  ENDMETHOD.
  
*======================================================================*
CLASS cl_event_receiver1 IMPLEMENTATION.
*======================================================================*

  METHOD handle_hotspot_click.
    lcl_main=>me( )->alv_hotspot_click1( is_row_id    = e_row_id
                                         is_column_id = e_column_id ).
  ENDMETHOD.                    " handle_hotspot_click

  METHOD handle_toolbar.
    DATA lt_toolbar TYPE ttb_button.
    lcl_main=>me( )->alv_toolbar1( CHANGING ct_toolbar = lt_toolbar ).
    INSERT LINES OF lt_toolbar INTO TABLE e_object->mt_toolbar.
  ENDMETHOD.                    " handle_toolbar

  METHOD handle_user_command.
    lcl_main=>me( )->alv_user_command1( e_ucomm ).
  ENDMETHOD.                    " handle_user_command

*======================================================================*
ENDCLASS.
*======================================================================*