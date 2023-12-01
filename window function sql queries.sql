Select * from dbo.bookings
--average price
Select id,name,host_id,price,
Avg(price) Over ()as Average_price
from dbo.bookings

--Average,min,max price
Select id,name,neighbourhood_group,price,
Avg(price) Over ()as Average_price,
Min(price) over() as min_price,
Max(price) over () as max_price
from dbo.bookings

--difference from average price with over
Select id,name,neighbourhood_group,price,
Round(avg(price) over(),2)as avg_price,
Round((price - avg(price)over()),2)as diff_from_avg
from dbo.bookings

--percentage of average price
Select id,name,neighbourhood_group,price,
Round(avg(price) over(),2),
Round((price / avg(price)over())*100,2) as percentage_of_average
from dbo.bookings

--percentage difference from average price with over
Select id,name,neighbourhood_group,price,
Round(avg(price) over(),2)as avg_price,
Round((price / avg(price)over()-1)*100,2)as percent_diff_from_avg
from dbo.bookings;

--partition by neighbourhood group
Select id,name,neighbourhood_group,neighbourhood,price,
Avg(price) over(partition by neighbourhood_group)as avgprice_per_neighbourhood_group
from dbo.bookings;

Select distinct neighbourhood_group from bookings;
Select distinct neighbourhood from bookings;

--partition by neighbourhood group and neighbourhood
Select id,name,neighbourhood_group,neighbourhood,price,
Avg(price) over(partition by neighbourhood_group)as avgprice_per_neighbourhood_group,
Avg(price) over(partition by neighbourhood_group,neighbourhood)as avgprice_per_neighbourhood_group_neighbourhood
from dbo.bookings;

--partition by neighbourhood group and neighbourhood and neighhood_delta
Select id,name,neighbourhood_group,neighbourhood,price,
Avg(price) over(partition by neighbourhood_group)as avgprice_per_neighbourhood_group,
Avg(price) over(partition by neighbourhood_group,neighbourhood)as avgprice_per_neighbourhood_group_neighbourhood,
Round(price- avg(price) over (partition by neighbourhood_group),2)as neigh_group_delta,
Round(price-avg(price)over (partition by  neighbourhood_group,neighbourhood),2)as neigh_delta
from bookings

--overall price rank
Select id,name,neighbourhood_group,neighbourhood,price,
row_number() over (order by price desc)as overall_price_rank
from bookings

--neighbourhood price rank
Select id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	row_number() over (order by price desc)as overall_price_rank,
	row_number() over (partition by neighbourhood_group order by price desc)as neighbourhood_group_price_rank
	from bookings

--top 3
Select id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	row_number() over (order by price desc)as overall_price_rank,
	row_number() over (partition by neighbourhood_group order by price desc)as neighbourhood_group_price_rank,
	Case 
	when row_number() over (partition by neighbourhood_group order by price desc) <= 3 then 'yes'
	else 'no' end as top3flag
	from bookings

	--rank 
	Select id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	row_number() over (order by price desc)as overall_price_rank,
	rank() over (order by price desc) as rank,
	row_number() over (partition by neighbourhood_group order by price desc)as neighbourhood_group_price_row_num,
	rank() over (partition by neighbourhood_group order by price desc)as neighbourhood_group_price_rank
	from bookings


	-- dense_rank
	Select id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	row_number() over (order by price desc)as overall_price_rank,
	rank() over (order by price desc) as rank,
	Dense_rank() over (order by price desc)as dense_rank,
	row_number() over (partition by neighbourhood_group order by price desc)as neighbourhood_group_price_row_num,
	rank() over (partition by neighbourhood_group order by price desc)as neighbourhood_group_price_rank,
	dense_rank() over (partition by neighbourhood_group order by price desc) as neigh_grp_dense_rank
	from bookings

Select * from bookings
	--lag by 1 period
	Select id,
	name,
	host_name,
	last_review,
	price,
	lag(price)over (partition by host_name order by last_review)as lag
	from bookings

	--lag 2 period
	Select id,
	name,
	host_name,
	last_review,
	price,
	lag(price,2)over (partition by host_name order by last_review)as lag
	from bookings

	--lead 1 period
	Select id,
	name,
	host_name,
	last_review,
	price,
	lead(price)over (partition by host_name order by last_review)as lag
	from bookings

	--lead 2 periods
	Select id,
	name,
	host_name,
	last_review,
	price,
	lead(price,2)over (partition by host_name order by last_review)as lag
	from bookings

	--top3flag

	Select * from 
	(Select id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	row_number() over (order by price desc)as overall_price_rank,
	row_number() over (partition by neighbourhood_group order by price desc)as neighbourhood_group_price_rank,
	Case 
	when row_number() over (partition by neighbourhood_group order by price desc) <= 3 then 'yes'
	else 'no' end as top3flag
	from bookings)a
	where top3flag='yes'