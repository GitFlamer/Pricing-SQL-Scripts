BEGIN TRAN
SET XACT_ABORT ON
DECLARE @date DATE = GETDATE();
DECLARE @CatalogId INT = (SELECT CatalogueID FROM [PricingInfo].[dbo].Catalogue WHERE CatalogueName='Бампер / Накладка бампера/ Облицовка бампера')
DECLARE @CorrectionId INT = (SELECT MAX(CorrectionID)  FROM [PricingInfo].[dbo].[CalcUserCost_CorrectionPercentDescription]) + 1
DECLARE @Priority INT = (SELECT MAX([Priority])  FROM [PricingInfo].[dbo].CalcUserCost_CorrectionPercent WHERE isActive=1) + 1
SELECT @CatalogId,@CorrectionId,@Priority
IF @CatalogId IS NULL OR  @CorrectionId IS NULL  OR @Priority IS NULL
	RAISERROR ('Ошибка данных',18,1)


Insert [PricingInfo].[dbo].[CalcUserCost_CorrectionPercentDescription] (CorrectionID, Description,_modify) VALUES(@CorrectionId,'Наценка на товарную группу - Бампер / Накладка бампера/ Облицовка бампера',GETDATE());

INSERT [PricingInfo].[dbo].[CalcUserCost_CorrectionPercent] (CorrectionID, CatalogueID, BasePurchasingPriceMin, BasePurchasingPriceMax, Priority, CorrectionPercentValue, CorrectionPercentStartDate, isActive,IgnoreStdPricing,_modify) 
VALUES
(@CorrectionId,13425,0,2000,@Priority,50,@date,1,0,GETDATE()),
(@CorrectionId,13425,2000,3000,@Priority,40,@date,1,0,GetDate()),
(@CorrectionId,13425,3000,4000,@Priority,20,@date,1,0,GetDate()),
(@CorrectionId,13425,4000,1000000,@Priority,2,@date,1,0,GetDate())

DECLARE @users TABLE (UserId INT)
INSERT @users
SELECT u._row_id
FROM [PHANTOM\MAIN].ASP_MAIN.dbo.asp_partners p
JOIN [PHANTOM\MAIN].ASP_MAIN.dbo.asp_users u ON p._row_id = u.parent_id
WHERE P.GBD_ID IN
(
9
, 10
, 38
, 147
, 385
, 391
, 409
, 477
, 497
, 565
, 607
, 666
, 884
, 892
, 931
, 1110
, 1156
, 1201
, 1228
, 1418
, 1609
, 1679
, 1798
, 1978
, 2070
, 2140
, 2164
, 2170
, 2193
, 2207
, 2239
, 2264
, 2458
, 2470
, 2476
, 2504
, 2605
, 2612
, 2725
, 2740
, 2753
, 2856
, 2857
, 2861
, 2896
, 2898
, 2930
, 2956
, 2979
, 3014
, 3074
, 3087
, 3176
, 3193
, 3228
, 3238
, 3278
, 3330
, 3348
, 3384
, 3406
, 3497
, 3545
, 3608
, 3647
, 3661
, 3730
, 3872
, 3917
, 3940
, 4010
, 4040
, 4050
, 4098
, 4143
, 4261
, 4405
, 4435
, 4447
, 4500
, 4504
, 4693
, 4731
, 4833
, 4862
, 4865
, 4963
, 4966
, 4970
, 5116
, 5320
, 5476
, 5730
, 5736
, 5768
, 5836
, 5878
, 5921
, 5929
, 6017
, 6035
, 6188
, 6260
, 6316
, 6331
, 6573
, 6588
, 6598
, 6998
, 7138
, 7143
, 8386
, 8422
, 8528
, 8612
, 8993
, 9752
, 10339
, 11191
, 12457
, 12556
, 12642
, 13083
, 13136
, 14413
, 15067
, 15340
, 15394
, 15464
, 15712
, 15973
)

INSERT [PricingInfo].[dbo].[CalcUserCost_CorrectionPercent] (CorrectionID, CatalogueID, UserId, BasePurchasingPriceMin, BasePurchasingPriceMax, Priority, CorrectionPercentValue, CorrectionPercentStartDate, isActive,IgnoreStdPricing,_modify) 
SELECT @CorrectionId,@CatalogId,u.UserId,0,1000000,@Priority,0,@date,1,0,GetDate() FROM @users u

ROLLBACK
--COMMIT

--Update [PricingInfo].[dbo].[CalcUserCost_CorrectionPercent] set IsActive=0 WHERE CorrectionID=950
--Update [PricingInfo].[dbo].[CalcUserCost_CorrectionPercent] set IsActive=1 WHERE CorrectionID=950