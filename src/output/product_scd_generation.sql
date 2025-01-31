sql
CREATE TABLE Stg_Product (
  Product_ID INT PRIMARY KEY,
  Category_Name VARCHAR(50),
  Sub_Category_Name VARCHAR(50),
  Brand VARCHAR(50),
  Feature_Desc VARCHAR(100),
  is_active BOOLEAN,
  scoring_class VARCHAR(50)
)

sql
CREATE TABLE Dim_Product (
  Product_ID INT,
  Category_Name VARCHAR(50),
  Sub_Category_Name VARCHAR(50),
  Brand VARCHAR(50),
  Feature_Desc VARCHAR(100),
  is_active BOOLEAN,
  scoring_class VARCHAR(50),
  current_flag CHAR(1),
  changed_column VARCHAR(200)
)

sql
INSERT INTO Dim_Product
SELECT 
  a.Product_ID,
  b.Category_Name,
  b.Sub_Category_Name,
  b.Brand,
  b.Feature_Desc,
  b.is_active,
  b.scoring_class,
  'Y' as current_flag,
  CASE 
    WHEN a.Category_Name <> b.Category_Name THEN '-Category_Name'
    WHEN a.Sub_Category_Name <> b.Sub_Category_Name THEN '-Sub_Category_Name'
    WHEN a.Brand <> b.Brand THEN '-Brand'
    WHEN a.Feature_Desc <> b.Feature_Desc THEN '-Feature_Desc'
    WHEN a.is_active <> b.is_active THEN '-is_active'
    WHEN a.scoring_class <> b.scoring_class THEN '-scoring_class'
    ELSE ''
  END as changed_column
FROM 
  product a 
JOIN 
  Stg_Product b 
ON 
  a.Product_ID = b.Product_ID 
WHERE 
  a.Category_Name <> b.Category_Name OR
  a.Sub_Category_Name <> b.Sub_Category_Name OR
  a.Brand <> b.Brand OR
  a.Feature_Desc <> b.Feature_Desc OR
  a.is_active <> b.is_active OR
  a.scoring_class <> b.scoring_class;

UPDATE Dim_Product
SET current_flag = 'N'
WHERE Product_ID IN (SELECT Product_ID FROM Stg_Product);
