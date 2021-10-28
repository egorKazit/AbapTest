@ClientHandling.algorithm: #SESSION_VARIABLE

@AbapCatalog: { sqlViewName: 'ZRRQST',
                compiler.compareFilter: true,
                preserveKey: true
}

@AccessControl.authorizationCheck: #CHECK

@ObjectModel:{
               representativeKey: 'UUID',
               semanticKey: ['RequestID'],

               usageType: {
                 dataClass: #TRANSACTIONAL,
                 serviceQuality: #B,
                 sizeCategory: #M
              }
}

//@VDM: {
//  viewType: #BASIC,
//  lifecycle.contract.type: #SAP_INTERNAL_API
//}
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Request Basic'
define view ZYKZ_R_RequestHeader
  as select from zykz_lx_request
  association [0..*] to ZYKZ_R_RequestItem as _RequestItem on $projection.UUID = _RequestItem.HeaderUUID
{
  key mandt              as Mandt,
  key uuid               as UUID,
      requestid          as RequestID,
      requestname        as RequestName,
      description        as Description,
      requeststatus      as RequestStatus,
      priority           as Priority,
      receivedflag       as ReceivedFlag,

      _RequestItem
}
