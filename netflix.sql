/****** SSMS 中 SelectTopNRows 命令的指令碼  ******/

--近10年Netflix平台電視、電影分析
--資料範圍: 2011-2021
--資料來源:Kaggle
--作者: Sherlin
--
SELECT 
	  [show_id]  
      ,[type] 類型
      ,[title] 標題
      ,[director] 導演
      ,[cast] 卡司
      ,[country] 國家
      ,[date_added]  平台上架日期
      ,[release_year]   實際發行日期
      ,[rating]   級數
      ,[duration] 期間
      ,[listed_in]  類型
      ,[description] 描述
	  ,rating_name 級數名稱
  FROM [SQL Project].[dbo].[netflix_titles]
  where 1=1
  --and title like 'You%'
  order by release_year desc

  --地區
  update [SQL Project].[dbo].[netflix_titles]
  set [country] =''
    where 1=1
  and [country] is null

  --資料未有發行日期
  --依上架日期的數量
 ;with tmp as (
select
	count([show_id]) [show_id],
	year(date_added) as date_added
from  [SQL Project].[dbo].[netflix_titles]
group by date_added
 )

select 
	sum([show_id]),
	date_added
from tmp
group by date_added
order by date_added desc

--依分級的節目數量
select
	 --Year(date_added) as date_added,
		rating,
		count(show_id) as show_id_cnt
from [SQL Project].[dbo].[netflix_titles]
where 1=1
	and date_added >= '2011-01-01'
group by rating


--清洗資料，統一名稱
update [SQL Project].[dbo].[netflix_titles]
	set  rating = 
		case 
			when rating ='74 min' then 'TV-MA'
			when rating ='84 min' then 'TV-MA'
			when rating ='66 min' then 'TV-MA'
			when rating ='TV-Y7-FV' then 'TV-Y7'
			else rating
		end 
from [SQL Project].[dbo].[netflix_titles]

--null 以空白代替

update [SQL Project].dbo.netflix_titles
set rating = ''
from [SQL Project].dbo.netflix_titles
where rating is null

--新增欄位
ALTER TABLE [SQL Project].[dbo].[netflix_titles]  add    [rating_name] nvarchar(255)

--分級代號的描述

UPDATE  [SQL Project].[dbo].[netflix_titles]
set rating_name =
	case	
				 when rating = 'PG-13'  then 'Teens - age above 12'
                 when rating = 'TV-MA' then 'Adults'
                 when rating ='PG' then 'kids with parental guidance'
                  when rating = 'TV-14' then 'Teens with age above 14'
              when rating = 'TV-PG' then 'kids with parental guidance'
                when rating =  'TV-Y' then 'kids'
               when rating =  'TV-Y7'then 'kids-age above 7'
               when rating =  'R'then'Adults'
                when rating =  'TV-G'then'kids'
                when rating ='G'then'General '
                 when rating = 'NC-17'then'Adults'
                 when rating = 'NR'then'NR'
                when rating =  'UR'then'UR'
		else rating
	end 
from [SQL Project].dbo.netflix_titles



