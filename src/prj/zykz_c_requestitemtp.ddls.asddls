@EndUserText.label: 'Request Item Projection'
@Metadata.allowExtensions: true
define view entity ZYKZ_C_RequestItemTP
  as projection on ZYKZ_R_RequestItemTP
{
  key UUID,
      HeaderUUID,
      ItemName,
      Description,
      /* Associations */
      _RequestHeader : redirected to parent  ZYKZ_C_RequestHeaderTP
}
