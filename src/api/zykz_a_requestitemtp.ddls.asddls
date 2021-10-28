@Metadata.allowExtensions: true
@EndUserText.label: 'Request Item API'
define view entity ZYKZ_A_RequestItemTP
  as projection on ZYKZ_R_RequestItemTP
{
  key UUID,
      HeaderUUID,
      ItemName,
      Description,
      /* Associations */
      _RequestHeader : redirected to parent ZYKZ_A_RequestHeaderTP
}
