# Created in 2018.06.03 by polarbears
# Copyright (c) 20xx, CHINA and/or affiliates.
# All rights reserved.
#	Name:
# 		文件名
#	Description:
# 		基本说明
#  Relation:
#      对象关联
#	Notes:
#		基本注意事项
#	修改 - （年-月-日） - 描述
#

# 生成RSA密钥
ssh-keygen -t rsa
# 拷贝公钥到目标机器
ssh-copy-id -i .ssh/id_rsa.pub ip_address


