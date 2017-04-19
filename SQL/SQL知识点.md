<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [SQL 知识点](#sql-知识点)
	- [sql insert into 从一张表中查询到的数据插入到另一张表](#sql-insert-into-从一张表中查询到的数据插入到另一张表)
		- [普通插入数据](#普通插入数据)
	- [insert or update 场景](#insert-or-update-场景)
	- [UPDATE 更新](#update-更新)
	- [批量修改mysql表、表、数据库的字符校对规则](#批量修改mysql表表数据库的字符校对规则)
	- [增加用户权限，修改权限；](#增加用户权限修改权限)
	- [动态建立表](#动态建立表)
	- [导入本地csv文件](#导入本地csv文件)
	- [实现rounumber组内排序](#实现rounumber组内排序)
	- [数据库join](#数据库join)
	- [sql优化](#sql优化)

<!-- /TOC -->
# SQL 知识点
##  sql insert into 从一张表中查询到的数据插入到另一张表
### 普通插入数据
``` sql
drop table if exists employee;
create table employee
(员工编号 varchar(32) DEFAULT null,
姓名 varchar(32) DEFAULT null,
公司 varchar(32) DEFAULT null,
类型 varchar(32) DEFAULT null,
记录 int(12) DEFAULT null,
updatetime date DEFAULT null);

insert into employee(员工编号,姓名,公司,类型,记录)
values ('00001','张三','北京','年假',2);
values ('00002','李四','上海','休假',2);
```
从一张表中查询到的数据插入到另一张表
```sql
INSERT INTO employee([姓名] ,[部门])  
SELECT  [name] ,[DEP]  
FROM B
where [company]='北京公司' and date= '2013-06-21'  
```

##　insert or update 场景
在平常的开发中，经常碰到这种更新数据的场景：先判断某一数据在库表中是否存在，存在则 update，不存在则 insert；

DUPLICATE KEY UPDATE 关键字
在 INSERT 语句中使用 ON DUPLICATE KEY UPDATE 关键字实现数据不存在则插入，存在则更新的操作。判断数据重复的逻辑依然是主键冲突或者唯一键冲突。
测试表
``` sql
CREATE TABLE `test_tab` (
  `name` varchar(64) NOT NULL,
  `age` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 插入一条数据
INSERT INTO `test_tab` (`name`,`age`) values ('zhangsan',24)
--
INSERT INTO `test_tab` (`name`,`age`) values ('zhangsan',50)  
ON DUPLICATE KEY UPDATE `age`=50 ;

INSERT INTO `test_tab` (`name`,`age`) values ('lisi',30)  
ON DUPLICATE KEY UPDATE `age`=30 ;
```
参考资料：
[saveOrUpdate 的法](https://www.zybuluo.com/eternity/note/363928)

## UPDATE 更新
```sql
UPDATE mytable SET myfield = 'value' WHERE other_field = 'other_value';
```
多表联动更新

```sql
UPDATE mytable a INNER JOIN  tb s ON a.id=s.id  SET
 a.attribute1=s.order_id,
 a.attribute2=s.order_id;
```

批量更新多条记录的不同值
```sql
UPDATE mytable
    SET display_order = CASE id
        WHEN 1 THEN 3
        WHEN 2 THEN 4
        WHEN 3 THEN 5
    END
WHERE id IN (1,2,3)
这句sql的意思是，更新display_order 字段，如果id=1 则display_order 的值为3，如果id=2 则 display_order 的值为4，如果id=3 则 display_order 的值为5。即是将条件语句写在了一起。
这里的where部分不影响代码的执行，但是会提高sql执行的效率。确保sql语句仅执行需要修改的行数，这里只有3条数据进行更新，而where子句确保只有3行数据执行。
```

## 批量修改mysql表、表、数据库的字符校对规则
```SQL
alter table db.table convert to character set utf8 collate utf8_unicode_ci;
```
## 增加用户权限，修改权限；
``` SQL
-- 设置root用户密码是空
GRANT ALL PRIVILEGES ON *.* TO root@'localhost' IDENTIFIED BY '' WITH GRANT OPTION;
-- 设置账户 taobao通过172.16.地址访问taobao_c数据库，且设置密码为123456;
grant all privileges on taobao_c.* to taobao@'172.16.%.%' identified by '123456';
flush privileges;
```
## 动态建立表

``` sql
drop procedure if exists load_infile;
create procedure load_infile(in dayname varchar(255))
begin
-- 建立表结构
drop table if exists base_tbCrmOrder;
create table base_tbCrmOrder
(orderid int(12) not null,
taobaotradeid text  null,
taobaoshopname varchar(32)  null,
orderstatus varchar(32)  null,
warehouse varchar(32)  null,
uid int(12)  null,
taobaousername varchar(255)  null,
ordertbcretime datetime  null,
paytime datetime null,
orderimporttime date  not null,
province varchar(32) null,
city varchar(32) null,
address text null,
payamount decimal(10,2) null,
expressfee varchar(32) null,
express varchar(32) null,
discountfee decimal(10,2) null,
productclassnum int(12) null,
productnum int(12) null,
unique  key (orderid,orderimporttime),
key (orderimporttime,uid,taobaoshopname,orderstatus),
primary key (orderid,orderimporttime)
);

--动态建立表
--删除表
set @sql_drop_table = concat('drop table if exists boqii_tbCrmOrder_', date_format(dayname,'%Y%m%d'));
    PREPARE sql_create_table FROM @sql_drop_table;
    EXECUTE sql_create_table;   
--建立
set @sql_create_table = concat(  
'CREATE TABLE IF NOT EXISTS boqii_tbCrmOrder_', date_format(dayname,'%Y%m%d'),  
" select * from base_tbCrmOrder;");  

PREPARE sql_create_table FROM @sql_create_table;     
EXECUTE sql_create_table;   

end;

call load_infile('20170419');  ######更改日期
```
## 导入本地csv文件
```sql
LOAD DATA LOCAL INFILE  'D:\\tb_orders\\btCrmData20170419-1_05525\\log\\tbCrmData\\tbCrmOrder.csv'
INTO TABLE boqii_tbCrmOrder_20170419  ######更改日期
CHARACTER SET utf8
fields terminated by ',' optionally enclosed by '"' ESCAPED BY '"'
lines terminated by '\n'
ignore 1 lines;
```
## 实现rounumber组内排序

##  数据库join
jion前确认两张表的映射关系：一对一、一对多、多对一
避免数据膨胀;

一对一情况：
left join 、right 和 inner join确认每个数据只有一条，避免数据膨胀，出现一对多现象；
如何解决？确保：join待关联字段的唯一性 ，预防记录不规范，坑了自己，胖了数据
由于数据的不确定性，因避免出现 N*M ，导致数据膨胀，其解决办法：
1.待关联数据，首先group by 维度，确保维度的唯一性，再处理，最后再截取；
2.数据关联完毕后，验证数据的有效性（检验数据，随机抽取数据验证）；

## sql优化
sql 计算顺序
```SQL
FORM: 对FROM的左边的表和右边的表计算笛卡尔积。产生虚表VT1
ON: 对虚表VT1进行ON筛选，只有那些符合<join-condition>的行才会被记录在虚表VT2中。
JOIN： 如果指定了OUTER JOIN（比如left join、 right join），那么保留表中未匹配的行就会作为外部行添加到虚拟表VT2中，产生虚拟表VT3, rug from子句中包含两个以上的表的话，那么就会对上一个join连接产生的结果VT3和下一个表重复执行步骤1~3这三个步骤，一直到处理完所有的表为止。
WHERE： 对虚拟表VT3进行WHERE条件过滤。只有符合<where-condition>的记录才会被插入到虚拟表VT4中。
GROUP BY: 根据group by子句中的列，对VT4中的记录进行分组操作，产生VT5.
CUBE | ROLLUP: 对表VT5进行cube或者rollup操作，产生表VT6.
HAVING： 对虚拟表VT6应用having过滤，只有符合<having-condition>的记录才会被 插入到虚拟表VT7中。
SELECT： 执行select操作，选择指定的列，插入到虚拟表VT8中。
DISTINCT： 对VT8中的记录进行去重。产生虚拟表VT9.
ORDER BY: 将虚拟表VT9中的记录按照<order_by_list>进行排序操作，产生虚拟表VT10.
LIMIT：取出指定行的记录，产生虚拟表VT11, 并将结果返回。
```
[sql优化](https://wenku.baidu.com/view/1070d242700abb68a882fb34.html?qq-pf-to=pcqq.group)
