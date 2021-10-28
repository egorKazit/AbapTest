@EndUserText.label: 'Request Projection'
@Metadata.allowExtensions: true
define root view entity ZYKZ_C_RequestHeaderTP
  as projection on ZYKZ_R_RequestHeaderTP
{
      @UI.hidden: true
  key UUID,
      RequestID,
      RequestName,
      Description,
      RequestStatus,
      Priority,
      /* Associations */
      _RequestItem : redirected to composition child ZYKZ_C_RequestItemTP
}
