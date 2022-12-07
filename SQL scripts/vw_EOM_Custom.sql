USE [AONCentricityDW]
GO

/****** Object:  View [dbo].[vw_EOM_Custom]    Script Date: 12/6/2022 7:55:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_EOM_Custom]
AS
SELECT        pm.DateOfEntry AS [EntryDate], pm.DateofEntryKey AS [EntryDateKey], com.ListName AS [Company], fac.ListName AS [Site], fac.Ledger AS [Region], CASE WHEN ISNULL(doc.ListName, PDoc.ListName) 
                         IN ('Montilla Soler MD, Jaime', 'zz, z') THEN 'zz-unassigned' ELSE ISNULL(doc.ListName, PDoc.ListName) END AS [Provider], ISNULL(doc.DoctorId, pdoc.DoctorId) AS [ProviderId], ISNULL(doc.Ledger, PDoc.Ledger) AS [ProviderRegion], 
                         CASE WHEN Action = 'A' THEN CASE WHEN pro.Ledger = 'Lab' THEN CASE WHEN com.ListName = 'CTC' THEN 'Lab-CTC' WHEN com.ListName = 'Pathology' THEN 'Lab-Flow-Cyto' ELSE CASE WHEN pro.Code IN ('85025', 
                         '36415', '85610', '36591', '36592', '85007', '81025', '81003', '81002', '81001', '81000', '82272', '82270') 
                         THEN 'Lab-Office' ELSE 'Lab-Central' END END ELSE pro.Ledger END WHEN Action = 'P' THEN CASE WHEN pro.Ledger = 'Lab' THEN CASE WHEN com.ListName = 'CTC' AND (pro.Code LIKE '8%' OR
                         pro.Code LIKE '02%') THEN 'Lab-CTC' WHEN com.ListName = 'Pathology' AND (pro.Code LIKE '8%' OR
                         pro.Code LIKE 'G%' OR
                         pro.Code IN ('0008M', '36415')) THEN 'Lab-Flow-Cyto' WHEN com.ListName NOT IN ('Pathology', 'CTC') THEN CASE WHEN pro.Code IN ('85025', '36415', '85610', '36591', '36592', '85007', '81025', '81003', '81002', '81001', 
                         '81000', '82272', '82270') THEN 'Lab-Office' ELSE 'Lab-Central' END END ELSE ISNULL(pro.Ledger, 'Pt Deposits') END END AS [Dept], CASE WHEN Action = 'A' THEN d .Amount ELSE 0 END AS [Adjustments], 
                         CASE WHEN Action = 'P' THEN d .Amount ELSE 0 END AS [Collections], 0 AS [Charges]
FROM            dbo.FactCenTransactions t JOIN
                         dbo.FactCenTransactionDistributions d WITH (NOLOCK) ON t .TransactionsId = d .TransactionsId JOIN
                         dbo.FactCenVisitTransactions v WITH (NOLOCK) ON t .VisitTransactionsId = v.VisitTransactionsId JOIN
                         dbo.FactCenPatientVisit pv WITH (NOLOCK) ON v.PatientVisitId = pv.PatientVisitId JOIN
                         dbo.FactCenPaymentMethod pm WITH (NOLOCK) ON v.PaymentMethodId = pm.PaymentMethodId LEFT JOIN
                         dbo.FactCenPatientVisitProcs vp WITH (NOLOCK) ON d .PatientVisitProcsId = vp.PatientVisitProcsId LEFT JOIN
                         dbo.vw_DimCenProcedure pro WITH (NOLOCK) ON vp.ProceduresId = pro.ProceduresId LEFT JOIN
                         dbo.DimCenDoctor doc WITH (NOLOCK) ON vp.OrderingDoctorId = doc.DoctorId LEFT JOIN
                         dbo.DimCenDoctor rdoc WITH (NOLOCK) ON pv.ResponsibleDoctorId = rdoc.DoctorId LEFT JOIN
                         dbo.DimCenFacility fac WITH (NOLOCK) ON pv.FacilityId = fac.FacilityId LEFT JOIN
                         dbo.DimCenCompany com WITH (NOLOCK) ON pv.CompanyId = com.CompanyId LEFT JOIN
                         dbo.DimCenPatientProfile pp WITH (NOLOCK) ON pv.PatientProfileId = pp.PatientProfileId LEFT JOIN
                         dbo.DimCenDoctor PDoc WITH (NOLOCK) ON pp.DoctorId = PDoc.DoctorId
WHERE        t .Action IN ('A', 'P') AND d .Amount <> 0
UNION ALL
SELECT        b.Entry AS [EntryDate], b.EntryDateKey AS [EntryDateKey], com.ListName AS [Company], fac.ListName AS [Site], fac.Ledger AS [Region], doc.ListName AS [Provider], doc.DoctorId AS [ProviderId], doc.Ledger AS [ProviderRegion],
                         CASE WHEN pro.Ledger = 'Lab' THEN CASE WHEN com.ListName = 'CTC' THEN 'Lab-CTC' WHEN com.ListName = 'Pathology' THEN 'Lab-Flow-Cyto' ELSE CASE WHEN pro.Code IN ('85025', '36415', '85610', '36591', '36592', 
                         '85007', '81025', '81003', '81002', '81001', '81000', '82272', '82270') THEN 'Lab-Office' ELSE 'Lab-Central' END END ELSE pro.Ledger END AS [Dept], 0 AS Adjustments, 0 AS Collections, vp.TotalFee AS Charges
FROM            dbo.FactCenPatientVisitProcs vp JOIN
                         dbo.DimCenBatch b WITH (NOLOCK) ON vp.BatchId = b.BatchId LEFT JOIN
                         dbo.vw_DimCenProcedure pro WITH (NOLOCK) ON vp.ProceduresId = pro.ProceduresId LEFT JOIN
                         dbo.FactCenPatientVisit pv WITH (NOLOCK) ON vp.PatientVisitId = pv.PatientVisitId LEFT JOIN
                         dbo.DimCenDoctor doc WITH (NOLOCK) ON vp.OrderingDoctorId = doc.DoctorId LEFT JOIN
                         dbo.DimCenFacility fac WITH (NOLOCK) ON pv.FacilityId = fac.FacilityId LEFT JOIN
                         dbo.DimCenCompany com WITH (NOLOCK) ON pv.CompanyId = com.CompanyId
WHERE        vp.TotalFee <> 0
GO

