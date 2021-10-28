@AbapCatalog.sqlViewName: 'ZCRQSTPRTVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@EndUserText.label: 'Request Priority'
define view ZYKZ_C_RequestPriorityVH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE(p_domain_name:'ZYKZ_REUQEST_PRIORITY')
{
  key cast(cast( cast( domain_name as abap.char(3) ) as abap.numc(3) ) as abap.int1 ) as Priority,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      value_low                                                                       as PriorityName
}
