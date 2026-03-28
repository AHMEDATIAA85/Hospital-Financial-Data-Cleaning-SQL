--Step 1: Preview the first 1000 rows to ensure data integrity after Excel import

SELECT TOP (1000) *
FROM dbo.[Hospital Data ROW Project]

-- Step 2: Start Renaming columns to follow "Best Practices" (No spaces, No Arabic)
-- 1. Rename [الشهر] to [Month_Name]

EXEC SP_RENAME  "[Hospital Data Row Project ].[الشهر]","Month_Name","Column" ;

-- 2. Rename [الخدمة] to [Service_type]

EXEC SP_RENAME  "[Hospital Data Row Project ].[الخدمة]","Service_type","Column" ;

-- 3. Rename [التصنيف ] to [Payment_type]

EXEC SP_RENAME"[Hospital Data Row Project].[التصنيف]","Payment_type","COLUMN" ;

-- 4. Rename [Patient_Filenum ] to [Patient_ID]

EXEC SP_RENAME "[Hospital Data Row Project].[Patient_Filenum]","Patient_ID","Column" ;

-- 5. Rename [التصنيف ] to [Payment_type]

EXEC SP_RENAME "[Hospital Data Row Project].[Patient]","Patient_Name","Column" ;

-- This is just a PREVIEW, it doesn't change the data yet
SELECT 
Patient_ID AS [OLD_ID],
(Patient_id+54321) as [NEW_ID]
FROM [Hospital Data Row Project];

--Data Anonymization & Privacy Protection

UPDATE [Hospital Data Row Project]
SET Patient_ID = Patient_id+54321

-- This is just a PREVIEW, it doesn't change the data yet

SELECT TOP (100)
Patient_Name AS [old_name],
'patient-' + cast (patient_id as nvarchar(20)) as [masked_name]
FROM [Hospital Data Row Project] 

--Patient Name Masking

UPDATE [Hospital Data Row Project]
SET Patient_Name = 'patient-' + cast (patient_id as nvarchar(20));

-- This is just a PREVIEW, it doesn't change the data yet

SELECT TOP (500)
DOCTOR_NAME AS [OLD_NAME],
'MEDICALSTAFF-' + CAST(ABS(CHECKSUM(DOCTOR_NAME)) %100  as nvarchar(20)) AS [DOCTOR_ID]
FROM[Hospital Data Row Project];

--Doctor Name Masking & Staff Anonymization

UPDATE [Hospital Data Row Project]
SET DOCTOR_NAME='Medical_staff-' + cast(abs(checksum(doctor_name))%100 as nvarchar (50))

--Insurance & Cash Categorization (Data Masking)

update [Hospital Data Row Project]
    set Insurance_Company_Name=
        case when Insurance_Company_Name ='10' then 'cash_patient'
        else 'insurer-' + cast(abs(checksum(Insurance_Company_Name)) %50 as nvarchar (50))
        end;

--Data Standardization & Translation (Months & Services)

UPDATE [Hospital Data Row Project]
SET Month_Name = 
    CASE 
        WHEN Month_Name LIKE N'%يناير%' THEN 'January'
        WHEN Month_Name LIKE N'%فبراير%' THEN 'February'
        WHEN Month_Name LIKE N'%مارس%' THEN 'March'
        WHEN Month_Name LIKE N'%ابريل%' OR Month_Name LIKE N'%أبريل%' THEN 'April'
        WHEN Month_Name LIKE N'%مايو%' THEN 'May'
        WHEN Month_Name LIKE N'%يونيو%' THEN 'June'
        WHEN Month_Name LIKE N'%يوليو%' THEN 'July'
        ELSE Month_Name 
    END;

UPDATE [Hospital Data Row Project]
SET Service_type = 
    CASE 
        WHEN Service_type LIKE N'%اشعة%' OR Service_type LIKE N'%أشعة%' THEN 'Radiology'
        WHEN Service_type LIKE N'%مختبر%' THEN 'Laboratory'
        WHEN Service_type LIKE N'%طوارئ%' OR Service_type LIKE N'%طوارئ%' THEN 'Emergency'
        WHEN Service_type LIKE N'%عيادة%' OR Service_type LIKE N'%العيادة%' THEN 'Clinic'
        WHEN Service_type LIKE N'%كشفيات%' THEN 'Consultations'
        ELSE Service_type 
    END;

   --Hospital Financial Data Cleaning & Professional Structuring

SELECT 
    'Hospital Data Row Project' AS Table_Name,
    Column_Name AS [Column],
    (SELECT COUNT(*) FROM [Hospital Data Row Project]) AS Total_Rows,
    (SELECT COUNT(*) FROM [Hospital Data Row Project] WHERE [Column_Name] IS NULL) AS Null_Count
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'Hospital Data Row Project';

--Monthly Revenue Trend

SELECT 
    Month_Name, 
    COUNT(Patient_ID) AS Total_Visits,
    SUM(Gross_Amount) AS Total_Gross_Revenue,
    ROUND(SUM(Patient_Total), 2) AS Net_Collection
FROM [Hospital Data Row Project]
GROUP BY Month_Name
ORDER BY CASE 
    WHEN Month_Name = 'January' THEN 1 
    WHEN Month_Name = 'February' THEN 2 
    WHEN Month_Name = 'March' THEN 3 
    WHEN Month_Name = 'April' THEN 4 
    WHEN Month_Name = 'May' THEN 5 
    WHEN Month_Name = 'June' THEN 6 
    WHEN Month_Name = 'July' THEN 7 
    ELSE 8 END;

    --Service Line Profitability

 SELECT 
    Service_type,
    COUNT(*) AS Number_of_Services,
    SUM(Gross_Amount) AS Total_Revenue,
    ROUND(AVG(Gross_Amount), 2) AS Average_Service_Price,
    ROUND((SUM(Discount_Amount) / SUM(Gross_Amount)) * 100, 2) AS Discount_Percentage
FROM [Hospital Data Row Project]
GROUP BY Service_type
ORDER BY Total_Revenue DESC;

--Cash vs Insurance Analysis

SELECT 
    CASE WHEN Insurance_Company_Name = 'Cash_Patient' THEN 'Cash' ELSE 'Insurance' END AS Payment_Category,
    COUNT(*) AS Transaction_Count,
   round (SUM(Patient_Total),2) AS Total_Collected,
    round (AVG(Patient_Total),2) AS Avg_Transaction_Value
FROM [Hospital Data Row Project]
GROUP BY CASE WHEN Insurance_Company_Name = 'Cash_Patient' THEN 'Cash' ELSE 'Insurance' END;



       
