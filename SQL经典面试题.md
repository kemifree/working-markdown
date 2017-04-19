# sql 经典题

##  行列转换
###  行列转换
问题：假设有张学生成绩表(tb)如下:
<table>
<tr>
  <td>姓名<td>课程<td>分数
<tr>
<tr>
  <td>张三<td>语文<td> 74
<tr>
<tr>
  <td>张三<td> 数学<td> 83
<tr>
  <td>张三<td> 物理<td> 93
<tr>
  <td>李四<td> 语文<td> 74
<tr>
  <td>李四<td> 数学<td> 84
<tr>
  <td>李四<td> 物理<td> 94
<tr>
<table>  
想变成(得到如下结果)：
<table>
<tr>
<td>姓名<td> 语文<td> 数学<td> 物理
<tr>
<td>李四<td> 74 <td> 84  <td> 94
<tr>
<td>张三<td> 74 <td> 83 <td> 93
<tr>
<table>

建立数据表代码如下
``` sql
drop table if exists tb;
create table tb(
姓名 varchar(10) ,
课程 varchar(10) ,
分数 int);
insert into tb values('张三' , '语文' , 74);
insert into tb values('张三' , '数学' , 83);
insert into tb values('张三' , '物理' , 93);
insert into tb values('李四' , '语文' , 74);
insert into tb values('李四' , '数学' , 84);
insert into tb values('李四' , '物理' , 94);
```

### 解法一 静态SQL
静态SQL,指课程只有语文、数学、物理这三门课程。
``` sql
select 姓名,
       max(case when 课程='语文' then 分数 end) as 语文,
       max(case when 课程='数学' then 分数 end) as 数学,
       max(case when 课程='物理' then 分数 end) as 物理
from tb
group by 姓名
```
### 解法二 动态SQL
 动态SQL,指课程不止语文、数学、物理这三门课程。
 方法二，只需要了解即可，不需要掌握
 ```SQL
 SET @sql = NULL;
SELECT
    GROUP_CONCAT(DISTINCT
    CONCAT(
      'SUM(CASE WHEN 课程 = "',课程,'" THEN 分数 end) AS ', 课程))INTO @sql
FROM  tb;
#select @sql;
SET @sql = CONCAT('SELECT 姓名, ', @sql, '
                  FROM tb GROUP BY 姓名');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
```
### 问题：计算平均分，总分
问题：在上述结果的基础上加平均分，总分，得到如下结果：
<table>
  <tr>
   <td>姓名<td> 语文<td> 数学<td> 物理<td> 平均分<td> 总分
  <tr>
    <td>李四<td> 74<td> 84<td> 94<td> 84.00<td> 252
  <tr>
   <td>张三<td> 74<td> 83<td> 93<td> 83.33<td> 250
  <tr>
<table>
----
解法： 静态SQL

```SQL
select 姓名 姓名,
max(case 课程 when '语文' then 分数 else 0 end) 语文,
max(case 课程 when '数学' then 分数 else 0 end) 数学,
max(case 课程 when '物理' then 分数 else 0 end) 物理,
cast(avg(分数*1.0) as decimal(18,2)) 平均分,
sum(分数) 总分
from tb
group by 姓名;
```
参考资料：[Mysql 列转行统计查询 、行转列统计查询](http://www.cnblogs.com/lhj588/p/3315876.html)
### 列转行
问题：如果上述两表互相换一下：即表结构和数据为：
<table>
<tr>
<td>姓名<td> 语文<td> 数学<td> 物理
<tr>
<td>李四<td> 74 <td> 84  <td> 94
<tr>
<td>张三<td> 74 <td> 83 <td> 93
<tr>
<table>

想变成(得到如下结果)：

<table>
<tr>
  <td>姓名<td>课程<td>分数
<tr>
<tr>
  <td>张三<td>语文<td> 74
<tr>
<tr>
  <td>张三<td> 数学<td> 83
<tr>
  <td>张三<td> 物理<td> 93
<tr>
  <td>李四<td> 语文<td> 74
<tr>
  <td>李四<td> 数学<td> 84
<tr>
  <td>李四<td> 物理<td> 94
<tr>
<table>  

这个方法还是用Python.unstock()
sql实现方法复杂了；
