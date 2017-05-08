##关联测试---指定商品计算关联商品

##链接数据库，获取数据
library('RMySQL')
#conn <- dbConnect(RMySQL::MySQL(), username="step", password="i123456",dbname="tmall")
conn <- dbConnect(MySQL(),user='step',password='123456',dbname='boqii_xincheng',host='172.16.57.72',port= 3306)

dbSendQuery(conn,'set names gbk')
dbListTables(conn)
table = dbReadTable(conn,'xincheng_20170504')
head(table)



##调用关联分析包
library("arules")

##数据的预处理
data_values <- subset(table,select=c("uid","productid","productcode","productname"))

trans <- as(strsplit(data_values[,'productcode'],','),"transactions")

#head(strsplit(data_values[,'productcode'],','))

##查看前10行
inspect(trans[1:10])
summary(trans)

rules <- apriori(trans,parameter=list(minlen =2,support = 0.001,confidence=0.05),
                 appearance = list(lhs = '2134604',default = 'rhs'))

rules <- apriori(trans,parameter=list(minlen=2,support = 0.001,confidence=0.005))
rules
inspect(rules[1:10])
#关联分析
rules.sorted_sup <- sort(rules,by ='support')
inspect(rules.sorted_sup[1:10])

write(rules.sorted_sup ,file='C:\\Users\\Acer\\Desktop\\rules_1225643.csv',sep = ",")


library(xlsx)

workbook ='C:\\Users\\Acer\\Desktop\\xincheng_0504\\xincheng.xls'

df =read.xlsx(workbook,sheetName='sheet2',encoding ='UTF-8')

head(df)

for (i in 1: nrow(df)){
  productid <- df[i,'商品编码']
  productname <- df[i,'商品标题']
  file='C:\\Users\\Acer\\Desktop\\xincheng_0504\\rules_'
  file = paste(file,productid,productname,'.csv',sep='')
  rules <- apriori(trans,parameter=list(minlen =2,support = 0.00001,confidence=0.00000001),
                   appearance = list(lhs = productid,default = 'rhs'))
  #关联分析
  rules.sorted_sup <- sort(rules,by ='support')
  inspect(rules.sorted_sup[1:10])
  write(rules.sorted_sup ,file=file,sep=',',quote=TRUE,row.names=FALSE)
}

help(write)
