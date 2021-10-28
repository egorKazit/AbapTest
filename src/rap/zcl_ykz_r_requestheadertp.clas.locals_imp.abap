CLASS lhc_RequestHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR RequestHeader RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR RequestHeader RESULT result.
    METHODS setid FOR DETERMINE ON SAVE
      IMPORTING keys FOR requestheader~setid.
    METHODS approve FOR MODIFY
      IMPORTING keys FOR ACTION requestheader~approve.

    METHODS reject FOR MODIFY
      IMPORTING keys FOR ACTION requestheader~reject.

    METHODS submit FOR MODIFY
      IMPORTING keys FOR ACTION requestheader~submit RESULT result.
    METHODS setinitialstatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR requestheader~setinitialstatus.
    METHODS updaterecieverflag FOR MODIFY
      IMPORTING keys FOR ACTION requestheader~updaterecieverflag.
    METHODS earlynumbering_cba_requestitem FOR NUMBERING
      IMPORTING entities FOR CREATE requestheader\_requestitem.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE requestheader.

ENDCLASS.

CLASS lhc_RequestHeader IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF ZYKZ_R_RequestHeaderTP IN LOCAL MODE
      ENTITY RequestHeader
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(RequestHeaders).

    result = VALUE #( FOR RequestHeader IN RequestHeaders ( %tky = RequestHeader-%tky
                                                            %action-Submit = COND #( WHEN RequestHeader-RequestStatus = zif_ykz_request_constants=>status-in_preparation
                                                                                       THEN if_abap_behv=>fc-o-enabled
                                                                                     ELSE if_abap_behv=>fc-o-disabled )
                                                            %action-Approve = COND #( WHEN RequestHeader-RequestStatus =  zif_ykz_request_constants=>status-in_approval
                                                                                       THEN if_abap_behv=>fc-o-enabled
                                                                                     ELSE if_abap_behv=>fc-o-disabled )
                                                            %action-Reject = COND #( WHEN RequestHeader-RequestStatus = zif_ykz_request_constants=>status-in_approval
                                                                                       THEN if_abap_behv=>fc-o-enabled
                                                                                     ELSE if_abap_behv=>fc-o-disabled )
                                                            %action-Edit = COND #( WHEN RequestHeader-RequestStatus =  zif_ykz_request_constants=>status-in_preparation
                                                                                       THEN if_abap_behv=>fc-o-enabled
                                                                                     ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    LOOP AT entities REFERENCE INTO DATA(entity).
      APPEND INITIAL LINE TO mapped-requestheader REFERENCE INTO DATA(requestheader).
      requestheader->* = CORRESPONDING #( entity->* ).
      IF requestheader->uuid IS INITIAL.
        TRY.
            requestheader->uuid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
          CATCH cx_uuid_error.
            INSERT VALUE #( %key = entity->%key ) INTO TABLE failed-requestheader.
        ENDTRY.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_cba_Requestitem.
    LOOP AT entities REFERENCE INTO DATA(entity).
      LOOP AT  entity->%target REFERENCE INTO DATA(target).
        APPEND INITIAL LINE TO mapped-requestitem REFERENCE INTO DATA(requestitem).
        requestitem->* = CORRESPONDING #( target->* ).
        IF requestitem->uuid IS INITIAL.
          TRY.
              requestitem->uuid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
            CATCH cx_uuid_error.
              INSERT VALUE #( %key = entity->%key ) INTO TABLE failed-requestitem.
          ENDTRY.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD setId.

    READ ENTITIES OF ZYKZ_R_RequestHeaderTP IN LOCAL MODE
      ENTITY RequestHeader
      FIELDS ( uuid RequestID )
      WITH CORRESPONDING #( keys )
      RESULT DATA(RequestHeaders).

    SELECT MAX( RequestID ) FROM ZYKZ_R_RequestHeader INTO @DATA(max_request_id).
    LOOP AT RequestHeaders REFERENCE INTO DATA(RequestHeader).
      max_request_id += 1.
      RequestHeader->RequestID = max_request_id.
    ENDLOOP.

    MODIFY ENTITIES OF ZYKZ_R_RequestHeaderTP IN LOCAL MODE
      ENTITY RequestHeader
    UPDATE FIELDS ( RequestID )
    WITH VALUE #( FOR RequestHeaderLoc IN RequestHeaders
                  ( %key = RequestHeaderLoc-%key
                    RequestID = RequestHeaderLoc-RequestID
                    %control-RequestID = if_abap_behv=>mk-on ) ).

  ENDMETHOD.

  METHOD Approve.
  ENDMETHOD.

  METHOD Reject.
  ENDMETHOD.

  METHOD Submit.
    READ ENTITIES OF ZYKZ_R_RequestHeaderTP IN LOCAL MODE
      ENTITY RequestHeader
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(RequestHeaders).

    MODIFY ENTITIES OF ZYKZ_R_RequestHeaderTP IN LOCAL MODE
      ENTITY RequestHeader
    UPDATE FIELDS ( RequestStatus )
    WITH VALUE #( FOR RequestHeader IN RequestHeaders
                  ( %key = RequestHeader-%key
                    RequestStatus = zif_ykz_request_constants=>status-in_approval
                    %control-RequestStatus = if_abap_behv=>mk-on ) )
    MAPPED mapped.

    result = VALUE #( FOR RequestHeader IN RequestHeaders ( %key   = RequestHeader-%key
                                                            %param = RequestHeaders[ %key = RequestHeader-%key ] ) ).

  ENDMETHOD.

  METHOD setInitialStatus.
    READ ENTITIES OF ZYKZ_R_RequestHeaderTP IN LOCAL MODE
      ENTITY RequestHeader
      FIELDS ( uuid RequestID )
      WITH CORRESPONDING #( keys )
      RESULT DATA(RequestHeaders).

    MODIFY ENTITIES OF ZYKZ_R_RequestHeaderTP IN LOCAL MODE
      ENTITY RequestHeader
    UPDATE FIELDS ( RequestStatus )
    WITH VALUE #( FOR RequestHeader IN RequestHeaders
                  ( %key = RequestHeader-%key
                    RequestStatus = '01'
                    %control-RequestStatus = if_abap_behv=>mk-on ) ).
  ENDMETHOD.

  METHOD UpdateRecieverFlag.

    READ ENTITIES OF ZYKZ_R_RequestHeaderTP IN LOCAL MODE
      ENTITY RequestHeader
      FIELDS ( uuid ReceivedFlag )
      WITH CORRESPONDING #( keys )
      RESULT DATA(RequestHeaders).

    MODIFY ENTITIES OF ZYKZ_R_RequestHeaderTP IN LOCAL MODE
      ENTITY RequestHeader
    UPDATE FIELDS ( ReceivedFlag )
    WITH VALUE #( FOR RequestHeader IN RequestHeaders
                  ( %key = RequestHeader-%key
                    ReceivedFlag = abap_true
                    %control-ReceivedFlag = if_abap_behv=>mk-on ) )
    FAILED failed
    REPORTED reported
    MAPPED mapped.

  ENDMETHOD.

ENDCLASS.
