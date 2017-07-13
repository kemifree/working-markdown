#dplyr使用操作
library(dplyr)

uid <- c('u001','u001','uoo2','uoo3','uoo3')
productid <- c('apple','potato','apple','tomato','watermelon')
number <- c(2,1,3,5,10)
price <-c(4,3,4,2,1)

df <- data.frame(uid,productid,number,price)

#dplyr
#需求一：统计用户购买的商品数，商品数量，数量金额
#聚合函数用法

df1 = mutate(df,cost=price*number)

df1_by_uid <- group_by(df1,uid)

summarise(df1_by_uid,total_number=sum(number),total_cost=sum(number*cost),
          count=n(),n_distinct(productid),
          n_distinct(number)) ## 计算唯一值的个数

#min(),max(),mean()…等统计量，以及IQR() #返回四分位极差 
#n() # 返回观测个数 
#n_distinct() #返回不同的观测个数 
#
#--case用法
#水果，蔬菜的数量和总金额

#case_when就是一个判断条件咯

df2 =mutate(df,class =case_when(productid == 'apple'~ "fruit",
                           productid == 'potato' ~"vegetables",
                           productid == 'watermelon'~ "fruit",
                           productid == 'tomato' ~"vegetables"))


##join用法
test_data <- data.frame(first_name = c("john", "bill", "madison", "abby", "zzz"),
                        stringsAsFactors = FALSE)


kantrowitz <- data.frame(name = c("john", "bill", "madison", "abby", "thomas"),
                             gender = c("M", "either", "M", "either", "M"),
                         stringsAsFactors = FALSE)

#join方法一 原生的
merge(test_data, kantrowitz, by.x = "first_name", by.y = "name", all.x = TRUE)
#join方法二 dplyr的
library(dplyr)
left_join(test_data, kantrowitz, by = c("first_name" = "name"))

#土建使用dplyr的join方法
