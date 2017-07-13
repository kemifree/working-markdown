# -*- coding: utf-8 -*-
"""
Created on Mon Jun 26 09:58:22 2017
交易交易构成--类目构成
@author: Acer
"""


import sys
import time
from datetime import datetime, timedelta
import urllib.parse as urlparse
from urllib.parse import urlencode

python_path = 'C:\\Users\\Acer\\Desktop\\import_scripy\\taobao_script'
sys.path.append(python_path)
from base_file import Base_file
base  = Base_file() 

username=u'波奇网旗舰店:zjq'
password=u'a123456'
login_info,driver = base.login_taobao(username,password)

path='C:\\downloads_taobao'
business_name='波奇网旗舰店'
source = '类目构成'



url_base = 'https://sycm.taobao.com/bda/download/excel/tradinganaly/constitute/CategoryExcel.do?'

yesterday = (datetime.date(datetime.now()) - timedelta(days=1)).strftime('%Y-%m-%d')
params = {
'dateRange':yesterday+'|'+yesterday, #默认选择昨天
'dateType':'day'
}

def url_day_download(driver=driver,path=path,url_base=url_base,params=params,date_range=1):
    #默认取前1天数据：    
    date_range = date_range
    for day in range(date_range):
        date_value = datetime.date(datetime.now()) -timedelta(days=1) - timedelta(days=day) #默认取昨天的数据
        date_value = date_value.strftime('%Y-%m-%d')
        dateRange = {'dateRange':date_value+'|'+date_value} 
        params.update(dateRange)

        #下载数据，并存放到数据库中
        download(driver=driver,url_base=url_base,params=params,path=path)

def download(driver=driver,url_base=url_base,params=params,path=path):
    try:
        ##删除存在的文件
        info  = base.delete_xlsfile(path=path) 
        #------------------------------
        #-------下载数据---------
        #url_base = 'https://sycm.taobao.com/bda/download/excel/items/effect/ItemEffectExcel.do?'
        for i in range(5):
            try:
                url_download = url_base + urlencode(params)
                driver.get(url_download)
                time.sleep(3)
                break
            except:
                print('chrome文件url地址解析失败，下载失败,请检测失败原因')
        #检测文件是否下载完成
        base.xls_crdownload(path)
        #------------------------------
        #读取数据
        for i in range(5):
            try:
                info_read,sheet=base.read_table(path=path,sheetname=0,skiprows=3)
                break
            except:
                print('文件正在下载中ing-----正在等待----'+str(i)+'-----请稍等')
            
        sheet[u'店铺']=business_name
        datetype ='自然日'
        sheet[u'日期类型']=datetype
        #sheet[platform] = platform #表中已经自带渠道
        sever_table_name =business_name+source+datetype                                 
        info = base.to_mysql(local_table=sheet,server_table= sever_table_name)
        #info = u'数据预处理成功'
        print('第----------' +info)
    except:
        info = u'数据预处理失败'
        print('第----------'+ info) 

if __name__ == "__main__":
    url_day_download(driver=driver,path=path,url_base=url_base,params=params,date_range=3)

