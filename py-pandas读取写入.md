# python --- pandas学习
###  pandas

### 读取excel数据
``` python
##读取excel 数据
def read_xlsx(path,sheet_name):
    xlsx_file = pd.ExcelFile(path) ##路径
    xlsx_table = xlsx_file.parse(sheet_name) ##选取表格
    return(xlsx_table)
## 写入 将DataFrame数据写入到excel文件中
pd.to_excel('C:\\Users\\Acer\\Desktop\\phone_query.xlsx',encoding='utf-8')
 ```
### 读取数据库mysql
``` python
##方法一：
conn = pymysql.connect(host='172.16.57.72',
                             port=3306,
                             user='step',
                             password='123456',
                             db='tb_orders',
                             charset='utf8',
                             cursorclass=pymysql.cursors.DictCursor)                   
cursor = conn.cursor()
sql =  'select * from temp'
cursor.execute(sql)
data = cursor.fetchall()
df = pd.DataFrame(data)
##读取数据方式2
from sqlalchemy import create_engine
engine = create_engine("mysql+pymysql://step:123456@172.16.57.72/tb_orders?charset=utf8")
sql = 'select * from temp'
df = pd.read_sql(sql,con=engine,chunksize=10000)
## 写入到数据库
df.to_sql('df_sql_name',con=engine,if_exists='replace',index=False,chunksize=10000)
```
### 读取mongb数据
``` python
def insert_mongb(posts):
    from pymongo import MongoClient
    client = MongoClient('localhost', 27017)
    db = client.python
    table_phone = db.phone
    result = table_phone.insert_one(posts)
    return result
```
