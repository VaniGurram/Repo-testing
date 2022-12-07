USE [ProcurementDW]
GO

/****** Object:  View [dbo].[AONOSSales]    Script Date: 12/6/2022 8:39:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/****** Script for SelectTopNRows command from SSMS  ******/
CREATE view [dbo].[AONOSSales] as 
SELECT ShipToBPID,[BusinessPartnerName]
      ,[SalesOrder],[InvoiceNumber]
      ,[CustomerOrder]
      ,[Orderdate]
      ,[ItemID]
      ,[DrugDescription]
      ,[NDCNUmber]
         , case when OrderedQuantity>= '1' and OrderedQuantity <> DeliveredQuantity then  DeliveredQuantity else  
	  	  [OrderedQuantity] end as OrderedQuantity
      ,[DeliveredQuantity]
      ,[OrderOrigin]
      ,[Price]
      ,[Amount1]
          ,[InvoiceDateKey]
      ,[DueDateKey]
      ,[TrackingNumber]
      ,[HCPCList]
      ,[ManufacturerBPID]
      ,[MfgName], GenericName 
      ,[ParentBPID]
      ,[Parent Name]
      ,[RouteofAdministrationCd]
      ,[RouteofAdministrationCdDesc]
      ,[SoldBYDesc],
	  Right(BusinessPartnerName,5) as clinic,case when [AONClinicFullName] is null then BusinessPartnerName else AONClinicFullName end as Clinicname,
	  MMYYYY, Quarter,Year,MonthName_Short,Month, case when DrugDescription like '%BNH'then 'BulkPurchases' else 'Dispensed sales' end as saleflag
  FROM [ProcurementDW].[dbo].[AONSales]
  left join [AONOpExDW].[dbo].[DWSmartSheetClinicProfile]
  on Right(BusinessPartnerName,5) =[LSW Site Code]
  left join ProcurementDW.dbo.Dim_Date dt
  on dt.Date =Orderdate 
  where (OrderedQuantity>= '1' and OrderedQuantity <> DeliveredQuantity and (Amount1 <>'0'))
  or (OrderedQuantity>= '1')
GO


