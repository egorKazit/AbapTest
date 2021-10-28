@AbapCatalog.sqlViewName: 'ZYKZ_R_REQUESTH'
@AccessControl.authorizationCheck: #CHECK

@ObjectModel:{representativeKey: 'UUID',
              semanticKey: ['RequestID'],

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
@EndUserText.label: 'Request TP'
define root view ZYKZ_R_RequestHeaderTP
  as select from ZYKZ_R_RequestHeader
  composition [*] of ZYKZ_R_RequestItemTP as _RequestItem
{
  key UUID,
      RequestID,
      RequestName,
      Description,
      RequestStatus,
      Priority,
      ReceivedFlag,
      /* Associations */
      _RequestItem
}
