create temp table #product_temp
select a.Product_ID as Product_ID_New,
case when a.Category_Name <> b.Category_Name then ‘-Category_Name’ else ‘’ end ||
case when a.Sub_Category_Name <> b.Sub_Category_Name then ‘-Sub_Category_Name’ else ‘’ end ||
case when a.Brand <> b.Brand then ‘-Brand’ else ‘’ end ||
case when a.Feature_Desc <> b.Feature_Desc then ‘-Feature_Desc’ else ‘’ end as CHANGED_COLUMN_NEW
from Dim_Product a join Stg_Product b
on a.Product_ID=b.Product_ID and a.current_flag=’Y’
where
a.Category_Name <> b.Category_Name or
a.Sub_Category_Name <> b.Sub_Category_Name or
a.Brand <> b.Brand or
a.Feature_Desc <> b.Feature_Desc;
