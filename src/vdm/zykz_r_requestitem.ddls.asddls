@ClientHandling.algorithm: #SESSION_VARIABLE

@AbapCatalog: { sqlViewName: 'ZRRQSTITM',
                compiler.compareFilter: true,
                preserveKey: true
}

@AccessControl.authorizationCheck: #CHECK

@ObjectModel:{
               representativeKey: 'UUID',
               semanticKey: ['ItemName'],

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
@EndUserText.label: 'Request Item Basic'
define view ZYKZ_R_RequestItem
  as select from zykz_lx_reqitem
  association [0..1] to ZYKZ_R_RequestHeader as _RequestHeader on $projection.HeaderUUID = _RequestHeader.UUID
{
  key mandt            as Mandt,
  key uuid             as UUID,
      headeruuid       as HeaderUUID,
      id               as Id,
      itemname         as ItemName,
      description      as Description,
      requisitioncount as RequisitionCount,
      _RequestHeader
}
