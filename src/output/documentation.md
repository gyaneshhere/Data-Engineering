# Pipeline Documentation

This pipeline is designed to generate a temporary table `#product_temp` that identifies the changes in the product details from the staging table `Stg_Product` to the dimension table `Dim_Product`.

## Input Schema

The input schema for this pipeline is the `product` table with the following columns:

- `Product_ID`: An integer that uniquely identifies each product. This is the primary key of the table.
- `Category_Name`: A string that represents the category of the product.
- `Category_Sub_Name`: A string that represents the sub-category of the product.
- `Brand`: A string that represents the brand of the product.
- `Feature_Desc`: A string that describes the features of the product.

## Pipeline Steps

1. The pipeline starts by creating a temporary table `#product_temp` that will store the new product ID and the changed columns.

2. It then performs a join operation between the `Dim_Product` and `Stg_Product` tables based on the `Product_ID` and the `current_flag` field.

3. The pipeline identifies the columns that have changed by comparing the values in the `Dim_Product` and `Stg_Product` tables. If a change is detected, the column name is appended to the `CHANGED_COLUMN_NEW` field in the `#product_temp` table.

## Example Query

```sql
SELECT Product_ID_New, CHANGED_COLUMN_NEW
FROM #product_temp
WHERE CHANGED_COLUMN_NEW LIKE '%-Category_Name%'
```

This query will return all the products that have changes in the `Category_Name` field.

## Column Comments

- `Product_ID_New`: This is the new product ID after the changes have been made.
- `CHANGED_COLUMN_NEW`: This field stores the names of the columns that have changed. If multiple columns have changed, their names are concatenated with a '-'.

## Created Types

No new types are created in this pipeline. All the types used are standard SQL types.

## Note

This pipeline assumes that the `current_flag` field in the `Dim_Product` table is used to indicate the current version of the product details. If your implementation is different, you may need to adjust the join condition accordingly.