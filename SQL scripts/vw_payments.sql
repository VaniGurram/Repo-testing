USE [AONCentricityDW]
GO

/****** Object:  View [dbo].[vw_payments]    Script Date: 12/6/2022 7:56:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[vw_payments] as 

SELECT TransactionDistributionsId ,cast(month([Entry]) as varchar) month,  CAST(YEAR([Entry]) AS varchar) year,SUM(FactCenTransactionDistributions.Amount) payments,CPTCode
          FROM      AONCentricityDW.dbo.FactCenTransactions Transactions
                    INNER JOIN AONCentricityDW.dbo.FactCenTransactionDistributions ON Transactions.TransactionsId = FactCenTransactionDistributions.TransactionsId
                    INNER JOIN AONCentricityDW.dbo.FactCenVisitTransactions ON Transactions.VisitTransactionsId = FactCenVisitTransactions.VisitTransactionsId
                    INNER JOIN AONCentricityDW.dbo.FactCenPatientVisit ON FactCenVisitTransactions.PatientVisitId = FactCenPatientVisit.PatientVisitId
                    INNER JOIN AONCentricityDW.dbo.FactCenPaymentMethod ON FactCenVisitTransactions.PaymentMethodId = FactCenPaymentMethod.PaymentMethodId
                    INNER JOIN AONCentricityDW.dbo.DimCenBatch ON FactCenPaymentMethod.BatchId = DimCenBatch.BatchId
                    LEFT JOIN AONCentricityDW.dbo.FactCenPatientVisitProcs ON FactCenPatientVisitProcs.PatientVisitProcsId = FactCenTransactionDistributions.PatientVisitProcsId
          WHERE     Transactions.[Action] = 'P' --and FactCenPatientVisitProcs.CPTCode<>'ADVPAY'
                    --AND (FactCenPatientVisitProcs.CalculatedUnits <> 0
                    --                        OR ISNULL(FactCenTransactionDistributions.PatientVisitProcsID, 0) = 0)
                    --                     )
                    --AND CAST(DimCenBatch.[Entry] as DATE) BETWEEN CONVERT(CHAR(8), DATEADD(m, -1,DATEADD(d,1 - DATEPART(d,GETDATE()),GETDATE())), 112)
                    --                                                                     AND     CONVERT(CHAR(8), DATEADD(dd,-DATEPART(dd,GETDATE()),GETDATE()), 112)
																						 group by cast(month([Entry]) as varchar),  CAST(YEAR([Entry]) AS varchar),CPTCode,TransactionDistributionsId
GO


