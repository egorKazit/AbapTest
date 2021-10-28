INTERFACE zif_ykz_request_constants
  PUBLIC .

  CONSTANTS:
    BEGIN OF status,
      Initial        TYPE zykz_reuqest_status VALUE  '00',
      In_Preparation TYPE zykz_reuqest_status VALUE  '01',
      In_Approval    TYPE zykz_reuqest_status VALUE  '02',
      Approved       TYPE zykz_reuqest_status VALUE  '03',
      Rejected       TYPE zykz_reuqest_status VALUE  '04',
      Completed      TYPE zykz_reuqest_status VALUE  '05',
    END OF status.

ENDINTERFACE.
