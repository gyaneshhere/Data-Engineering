insert into Dim_Product
(
select b.*,’Y’,’2400–01–01',null from Dim_Product a right join Stg_Product b
on nvl(a.Product_ID,’-1')=nvl(b.Product_ID,’-1') and a.current_flag=’Y’
where a.Product_ID is null
)
