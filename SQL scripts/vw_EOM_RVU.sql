USE [AONCentricityDW]
GO

/****** Object:  View [dbo].[vw_EOM_RVU]    Script Date: 12/6/2022 7:54:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_EOM_RVU]
AS
SELECT        b.Entry AS EntryDate, b.EntryDateKey, ISNULL(vp.DateOfServiceFrom, pv.VisitDatetime) AS ServiceDate, ISNULL(vp.DateOfServiceFromKey, pv.VisitDateKey) AS ServiceDateKey, fac.FacilityId, fac.Ledger AS Region, 
                         ISNULL(cf.Location, 'zMisc') AS Location, com.ListName AS Company, doc.ListName AS Provider, doc.DoctorId AS ProviderId, doc.ProviderType, doc.OrgName, doc.Ledger AS DoctorRegion, ISNULL(cdd.Name, '') 
                         AS CustomDivisionName, ISNULL(cdd.Division, '') AS CustomDivision, fac.ListName AS Site, pro.Ledger AS Dept, pro.Code AS CPT, pro.[CPT Code], pro.[CPT Desc], cdg.DepartmentGroup, pp.PatientId, vp.Units, 
                         vp.TotalFee AS Charges, CASE WHEN pro.[CPT Code] IN ('A9606', 'A9543') THEN 0.00 ELSE CAST(vp.RVU AS decimal(13, 2)) END AS RVUs, CASE WHEN pro.[CPT Code] IN ('A9606', 'A9543') 
                         THEN 0.00 ELSE CAST(vp.RVU * vp.Units AS decimal(13, 2)) END AS EffectiveRVUs, rvu.Work_RVU, CAST(rvu.Work_RVU * vp.Units AS decimal(13, 2)) AS WRVU, 
                         CASE WHEN doc.Inactive = 1 THEN 'zMisc' ELSE 
								CASE WHEN doc.Specialty IN ('Hematology/Oncology', 'Medical Oncology','Hematology') THEN 'Med Onc' 
									 WHEN doc.Specialty IN ('Radiation Oncology','Radiology, Radiation Oncology') THEN 'Rad Onc' 
									 WHEN doc.Specialty = 'Urology' THEN 'Urology' 
									 WHEN doc.Specialty IN ('Physical Medicine and Rehabilitation', 'Gynecologic Oncology','Obstetrics and Gynecology, Gynecologic Oncology','Surgery','Surgery, Oncology',
															'Anatomic Pathology & Clinical Pathology','Pathology, Hematology','Radiology, Diagnostic','Radiology, Neuroradiology') THEN 'Spec'
										ELSE 'zMisc' 
										END 
									END AS SpecialtyType, vp.Voided
FROM            dbo.FactCenPatientVisitProcs AS vp INNER JOIN
                         dbo.DimCenBatch AS b WITH (NOLOCK) ON vp.BatchId = b.BatchId LEFT OUTER JOIN
                         dbo.vw_DimCenProcedure AS pro WITH (NOLOCK) ON vp.ProceduresId = pro.ProceduresId LEFT OUTER JOIN
                         dbo.CustomRVU AS rvu WITH (NOLOCK) ON pro.Code = rvu.Code LEFT OUTER JOIN
                         dbo.FactCenPatientVisit AS pv WITH (NOLOCK) ON vp.PatientVisitId = pv.PatientVisitId LEFT OUTER JOIN
                         dbo.DimCenDoctor AS doc WITH (NOLOCK) ON vp.OrderingDoctorId = doc.DoctorId LEFT OUTER JOIN
                         dbo.CustomDoctorDivision AS cdd WITH (NOLOCK) ON doc.DoctorId = cdd.AttendingProviderId LEFT OUTER JOIN
                         dbo.DimCenFacility AS fac WITH (NOLOCK) ON pv.FacilityId = fac.FacilityId LEFT OUTER JOIN
                         dbo.CustomFacility AS cf WITH (NOLOCK) ON fac.FacilityId = cf.FacilityId LEFT OUTER JOIN
                         dbo.DimCenCompany AS com WITH (NOLOCK) ON pv.CompanyId = com.CompanyId LEFT OUTER JOIN
                         dbo.CustomDepartmentGroup AS cdg ON pro.Ledger = cdg.DepartmentName LEFT OUTER JOIN
                         dbo.DimCenPatientProfile AS pp WITH (NOLOCK) ON pv.PatientProfileId = pp.PatientProfileId
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "vp"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 248
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pro"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 254
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rvu"
            Begin Extent = 
               Top = 6
               Left = 286
               Bottom = 136
               Right = 460
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pv"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 532
               Right = 284
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "doc"
            Begin Extent = 
               Top = 534
               Left = 38
               Bottom = 664
               Right = 267
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cdd"
            Begin Extent = 
               Top = 666
               Left = 38
               Bottom = 796
               Right = 234
            End
            DisplayFlags = 280
            TopColumn = 0
       ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_EOM_RVU'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'  End
         Begin Table = "fac"
            Begin Extent = 
               Top = 798
               Left = 38
               Bottom = 928
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cf"
            Begin Extent = 
               Top = 138
               Left = 277
               Bottom = 268
               Right = 447
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "com"
            Begin Extent = 
               Top = 666
               Left = 272
               Bottom = 796
               Right = 453
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cdg"
            Begin Extent = 
               Top = 930
               Left = 38
               Bottom = 1043
               Right = 223
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pp"
            Begin Extent = 
               Top = 1044
               Left = 38
               Bottom = 1174
               Right = 250
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 31
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 4275
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_EOM_RVU'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_EOM_RVU'
GO


