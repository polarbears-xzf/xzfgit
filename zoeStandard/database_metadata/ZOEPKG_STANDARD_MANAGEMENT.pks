CREATE OR REPLACE PACKAGE ZOEMETA.ZOEPKG_STANDARD_MANAGEMENT AS 

  -- �����ݿ��л�ȡHIS5.0�����ж��󣬲��������������ɵ�������
  -- �������������м��ZOEMETA.
  -- ������ݣ���׼���ʡ���׼�������ע�͡��������͡����������ߡ�������������ע��
  PROCEDURE get_word_resolve_string_db; 
 
  --�ӱ�Ԫ���ݹ�����Ϣ�л�ȡ�������
  PROCEDURE get_create_table_sql;
  
  --��ʱ����
    --��������Ա�����е��ֶ������е����ݣ����ɹ����ֵ�������ע��
    --���ݽṹ��SYSTEM.PBCATCOL.PBC_LABL to PBC_RELATION_DICT PBC_CMNT
    --���������ֶ��������ݹ����ֶ�˵��#|�����ֵ�#|����ע�ͣ�
    ----�������򣺽���һ��#|֮��Ľ����������ֵ䣬���ڶ���#|֮��Ľ���������ע��
    PROCEDURE update_pbcatcol_relation_cmnt; 
    --���ݹ����ֵ�������ע�ͣ����ɳ���Ա�����е��ֶ������е�����
    --���ݽṹ��SYSTEM.PBCATCOL.PBC_RELATION_DICT PBC_CMNT  to PBC_LABL
    --���ɹ����ֶ��������ݹ����ֶ�˵��#|�����ֵ�#|����ע�ͣ�
    ----���ɹ��������һ��#|֮��Ϊ�գ����ҹ����ֵ�Ϊ���գ����¹����ֵ䵽��һ��#|֮��
    ----���ɹ�������ڶ���#|֮��Ϊ�գ���������ע��Ϊ���գ���������ע�͵��ڶ���#|֮��
    PROCEDURE update_pbcatcol_labl;

END ZOEPKG_STANDARD_MANAGEMENT;