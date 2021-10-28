@AbapCatalog.sqlViewName: 'ZYKZ_R_REQUESTI'
@AccessControl.authorizationCheck: #CHECK

@ObjectModel:{representativeKey: 'UUID',
              semanticKey: ['ItemName'],

              usageType: {
                dataClass: #TRANSACTIONAL,
                serviceQuality: #B,
                sizeCategory: #L
              }
}

//@VDM: {
//  viewType: #TRANSACTIONAL,
//  lifecycle.contract.type: #SAP_INTERNAL_API
//}
@AbapCatalog.preserveKey: true
@EndUserText.label: 'Request Item TP'
define view ZYKZ_R_RequestItemTP
  as select from ZYKZ_R_RequestItem
  association to parent ZYKZ_R_RequestHeaderTP as _RequestHeader on $projection.HeaderUUID = _RequestHeader.UUID
{
  key UUID,
      HeaderUUID,
      Id,
      ItemName,
      Description,
      RequisitionCount,
      /* Associations */
      _RequestHeader
}
