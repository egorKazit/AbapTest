CLASS zcl_ykz_requset_service DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_YKZ_REQUSET_SERVICE IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    TYPES:
      BEGIN OF import_structure,
        guid TYPE guid,
      END OF import_structure.
    DATA import_table TYPE TABLE OF import_structure WITH EMPTY KEY.

    CASE request->get_method( ).
      WHEN CONV string( if_web_http_client=>get ).
        SELECT *
          FROM ZYKZ_R_RequestHeader
          WHERE ReceivedFlag  = @abap_false
            AND RequestStatus = @zif_ykz_request_constants=>status-in_approval
          INTO TABLE @DATA(requests).
        DATA(json_response) = /ui2/cl_json=>serialize( data = requests pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
        response->set_text( json_response ).
      WHEN CONV string( if_web_http_client=>post ).
        DATA(lv_i) = request->get_text( ).
        /ui2/cl_json=>deserialize( EXPORTING json = request->get_text( )
                                   CHANGING  data = import_table ).

        MODIFY ENTITIES OF ZYKZ_R_RequestHeaderTP
          ENTITY RequestHeader
          EXECUTE UpdateRecieverFlag
          FROM VALUE #( FOR import_line IN import_table ( uuid = import_line-guid ) )
          REPORTED DATA(reported)
          FAILED DATA(failed)
          MAPPED DATA(mapped).
        COMMIT ENTITIES.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
