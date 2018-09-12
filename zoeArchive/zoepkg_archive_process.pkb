CREATE OR REPLACE PACKAGE BODY ZOEARCHIVE.ZOEPKG_ARCHIVE_PROCESS
AS
  e_parm_notvalid EXCEPTION;
  e_process_error EXCEPTION;

-- ===================================================
-- 归档处理任务数据准备
  --生成归档处理数据
  --初始化归档处理记录
-- ===================================================
FUNCTION arc_process_task_prepay(in_task_id IN NUMBER, id_archive_date IN DATE,  od_archive_exec_date OUT DATE)
RETURN VARCHAR2
AS
  ld_archive_exec_date DATE;
  ln_return       NUMBER;
  ln_process_task_exist_flag        NUMBER;
  ln_process_task_unend_flag        NUMBER;
  lv_task_data_sql              VARCHAR2(32766);
BEGIN
  --强制限制不允许归档1年内数据
  ln_return := ZOEARCHIVE.ZOEPKG_ARCHIVE_COMM.ARCHIVE_DATE_LIMIT(id_archive_date);
  IF ln_return = -1 THEN
    RETURN -1;  --'不允许归档1年内数据'
  END IF;
  --通过归档处理任务记录表获取当前归档日期，如第一次归档通过归档处理任务参数表获取系统上线时间作为初始归档时间基准
  SELECT COUNT(*)
  INTO ln_process_task_exist_flag
  FROM ZOEARCHIVE.ARC_PROCESS_TASK_RECORD
  WHERE TASK_ID = in_task_id AND ROWNUM = 1;
  IF ln_process_task_exist_flag = 0 THEN
    SELECT TO_DATE(PARAM_VALUE,'YYYY-MM-DD') INTO ld_archive_exec_date 
    FROM ZOEARCHIVE.ARC_PROCESS_TASK_PARAM 
    WHERE TASK_ID = in_task_id AND PARAM_NAME = 'LAUNCH_DATE';
  ELSE 
    SELECT MAX(ARCHIVE_DATE) INTO ld_archive_exec_date 
    FROM ZOEARCHIVE.ARC_PROCESS_TASK_RECORD
    WHERE TASK_ID = in_task_id AND ROWNUM = 1;
  END IF;
  --判断是否存在正在处理的归档处理任务
    SELECT COUNT(1) INTO ln_process_task_unend_flag 
    FROM ZOEARCHIVE.ARC_PROCESS_TASK_RECORD
    WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = ld_archive_exec_date
      AND (INSERT_COMPLETED_FLAG = 'N' OR DELETE_COMPLETED_FLAG =  'N');
    IF ln_process_task_unend_flag > 0 THEN
      od_archive_exec_date := ld_archive_exec_date;
      RETURN 1;  --'存在未完成归档处理任务'
    ELSE 
      INSERT INTO ZOEARCHIVE.ARC_PROCESS_TASK_DATA_RECORD 
        SELECT * FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE 
        WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = ld_archive_exec_date;
      DELETE FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE 
        WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = ld_archive_exec_date;
      COMMIT;
    END IF;
  --生成归档日期
    ld_archive_exec_date := TRUNC(last_day(ld_archive_exec_date)+1);
    IF ld_archive_exec_date > id_archive_date THEN
      RETURN -1;  --超出归档日期
    END IF;
    --生成归档任务记录
    INSERT INTO ZOEARCHIVE.ARC_PROCESS_TASK_RECORD 
      (TASK_ID , ARCHIVE_DATE , TABLE_OWNER , TABLE_NAME , PROCESS_ORDER, INSERT_COMPLETED_FLAG, DELETE_COMPLETED_FLAG)
      SELECT in_task_id, ld_archive_exec_date, TABLE_OWNER, TABLE_NAME, PROCESS_ORDER, 'N' , 'N'
        FROM ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG 
        WHERE TASK_ID = in_task_id ORDER BY PROCESS_ORDER;
    CASE 
      WHEN in_task_id = 1 THEN 
        lv_task_data_sql := '';
        lv_task_data_sql := lv_task_data_sql||'INSERT INTO ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE ';
        lv_task_data_sql := lv_task_data_sql||' (SEQ_NO,TASK_ID, ARCHIVE_DATE, ARCHIVE_CONDITION_VALUE1, ARCHIVE_CONDITION_VALUE2) ';
        lv_task_data_sql := lv_task_data_sql||' SELECT ZOEARCHIVE.SEQ_ARC_PROC_TASK_DATA_CACHE.nextval,'||in_task_id||', '||to_date(to_char(to_date(to_char(ld_archive_exec_date,'yyyy-mm-dd'),'yyyy-mm-dd'),'yyyy-mm-dd'),'yyyy-mm-dd')||', SETTLE_NO, 0 ';
        lv_task_data_sql := lv_task_data_sql||' FROM SICK_SETTLE_MASTER WHERE SETTLE_DATE < to_date('''||to_char(ld_archive_exec_date,'yyyy-mm-dd')||''',''yyyy-mm-dd'') AND SETTLE_MODE = 0 ';
        EXECUTE IMMEDIATE lv_task_data_sql;
      WHEN in_task_id = 2 THEN 
        lv_task_data_sql := '';
        lv_task_data_sql := lv_task_data_sql||'INSERT INTO ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE ';
        lv_task_data_sql := lv_task_data_sql||' ( SEQ_NO,TASK_ID, ARCHIVE_DATE, ARCHIVE_CONDITION_VALUE1, ARCHIVE_CONDITION_VALUE2, ARCHIVE_CONDITION_VALUE3) ';
        lv_task_data_sql := lv_task_data_sql||'  SELECT ZOEARCHIVE.SEQ_ARC_PROC_TASK_DATA_CACHE.nextval, '||in_task_id||', to_date('''||to_char(ld_archive_exec_date,'yyyy-mm-dd')||''',''yyyy-mm-dd''), SICK_ID, VISIT_NUMBER, RESIDENCE_NO ';
        lv_task_data_sql := lv_task_data_sql||'  FROM (SELECT  '||in_task_id||', to_date('''||to_char(ld_archive_exec_date,'yyyy-mm-dd')||''',''yyyy-mm-dd''), a.SICK_ID, a.VISIT_NUMBER, b.RESIDENCE_NO ';
        lv_task_data_sql := lv_task_data_sql||'    FROM SICK_VISIT_INFO a, SICK_SETTLE_MASTER b ';
        lv_task_data_sql := lv_task_data_sql||'    WHERE a.SICK_ID              = b.SICK_ID ';
        lv_task_data_sql := lv_task_data_sql||'      AND a.RESIDENCE_NO         = b.RESIDENCE_NO ';
        lv_task_data_sql := lv_task_data_sql||'      AND b.SETTLE_DATE          < to_date('''||to_char(ld_archive_exec_date,'yyyy-mm-dd')||''',''yyyy-mm-dd'') ';
        lv_task_data_sql := lv_task_data_sql||'      AND b.SETTLE_MODE          = ''1'' ';
        lv_task_data_sql := lv_task_data_sql||'      AND b.OUT_WARD_SETTLE_TYPE = ''1'' ';
        lv_task_data_sql := lv_task_data_sql||'      AND b.settle_type          = ''1'' ';
        lv_task_data_sql := lv_task_data_sql||'      AND b.back_receipt_no     IS NULL ';
        lv_task_data_sql := lv_task_data_sql||'      AND a.STATE                = ''9'' ';
        lv_task_data_sql := lv_task_data_sql||'      AND NOT EXISTS ';
        lv_task_data_sql := lv_task_data_sql||'        (SELECT   1 ';
        lv_task_data_sql := lv_task_data_sql||'          FROM (SELECT SICK_ID,VISIT_NUMBER ';
        lv_task_data_sql := lv_task_data_sql||'                FROM prepayment_money ';
        lv_task_data_sql := lv_task_data_sql||'                WHERE OPERATION_DATE < to_date('''||to_char(ld_archive_exec_date,'yyyy-mm-dd')||''',''yyyy-mm-dd'') AND VISIT_NUMBER > 0 ';
        lv_task_data_sql := lv_task_data_sql||'                  AND settle_receipt_no IS NULL AND receipt_no IS NOT NULL AND operation_type = ''1'' ';
        lv_task_data_sql := lv_task_data_sql||'                GROUP BY SICK_ID,VISIT_NUMBER) c ';
        lv_task_data_sql := lv_task_data_sql||'          WHERE a.sick_id        = c.sick_id ';
        lv_task_data_sql := lv_task_data_sql||'            AND a.visit_number   = c.visit_number ';
        lv_task_data_sql := lv_task_data_sql||'        ) ';
        lv_task_data_sql := lv_task_data_sql||'      GROUP BY '||in_task_id||', to_date('''||to_char(ld_archive_exec_date,'yyyy-mm-dd')||''',''yyyy-mm-dd''), a.SICK_ID, a.VISIT_NUMBER, b.RESIDENCE_NO) '; 
        EXECUTE IMMEDIATE lv_task_data_sql;
      WHEN in_task_id = 3 THEN 
        lv_task_data_sql := '';
        lv_task_data_sql := lv_task_data_sql||'INSERT INTO ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE ';
        lv_task_data_sql := lv_task_data_sql||'  (SEQ_NO,TASK_ID, ARCHIVE_DATE, ARCHIVE_CONDITION_VALUE1, ARCHIVE_CONDITION_VALUE2) ';
        lv_task_data_sql := lv_task_data_sql||'  SELECT ZOEARCHIVE.SEQ_ARC_PROC_TASK_DATA_CACHE.nextval, '||in_task_id||', to_date('''||to_char(ld_archive_exec_date,'yyyy-mm-dd')||''',''yyyy-mm-dd''), SICK_ID, 0 ';
        lv_task_data_sql := lv_task_data_sql||'  FROM (SELECT  '||in_task_id||', to_date('''||to_char(ld_archive_exec_date,'yyyy-mm-dd')||''',''yyyy-mm-dd''), SICK_ID, 0 ';
        lv_task_data_sql := lv_task_data_sql||'  FROM SICK_SETTLE_MASTER WHERE SETTLE_DATE < to_date('''||to_char(ld_archive_exec_date,'yyyy-mm-dd')||''',''yyyy-mm-dd'') AND SETTLE_MODE = 0 AND SICK_ID IS NOT NULL ';
        lv_task_data_sql := lv_task_data_sql||'  GROUP BY '||in_task_id||', to_date('''||to_char(ld_archive_exec_date,'yyyy-mm-dd')||''',''yyyy-mm-dd''), SICK_ID, 0) ';
       EXECUTE IMMEDIATE lv_task_data_sql;
      WHEN in_task_id = 4 THEN 
        lv_task_data_sql := '';
        lv_task_data_sql := lv_task_data_sql||'INSERT INTO ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE ';
        lv_task_data_sql := lv_task_data_sql||'  (SEQ_NO,TASK_ID, ARCHIVE_DATE, ARCHIVE_CONDITION_VALUE1, ARCHIVE_CONDITION_VALUE2) ';
        lv_task_data_sql := lv_task_data_sql||'  SELECT ZOEARCHIVE.SEQ_ARC_PROC_TASK_DATA_CACHE.nextval, '||in_task_id||', to_date('''||to_char(ld_archive_exec_date,'yyyy-mm-dd')||''',''yyyy-mm-dd''), PATIENT_ID, EVENT_NO ';
        lv_task_data_sql := lv_task_data_sql||'  FROM ZEMR.ZEMR_VISIT_RECORD WHERE ARCHIVE_TIME < to_date('''||to_char(ld_archive_exec_date,'yyyy-mm-dd')||''',''yyyy-mm-dd'') ';
        lv_task_data_sql := lv_task_data_sql||'  AND ARCHIVE_TIME >= (SELECT DECODE(MAX(ARCHIVE_DATE),NULL,TO_DATE(''2000-01-01'',''yyyy-mm-dd''),MAX(ARCHIVE_DATE)) FROM ZOEARCHIVE.ARC_PROCESS_TASK_RECORD WHERE INSERT_COMPLETED_FLAG=''Y'') ';
      EXECUTE IMMEDIATE lv_task_data_sql;
    END CASE;
    COMMIT;
    od_archive_exec_date := ld_archive_exec_date;
    RETURN 1;
  EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RETURN -1;
END arc_process_task_prepay;


-- ===================================================
-- 获取归档处理任务条件
-- ===================================================
    --in_task_id：      传入参数-数字型，归档处理任务ID，关联ZOEARCHIVE.ARC_PROCESS_TASK。
    --ot_arc_process_task_condition：   传出参数-集合，归档处理任务条件
    --返回值：
      /* 
      {returnValue: [
        {
          "code": "-1",
          "message": "失败"
        },
        {
          "code": "1",
          "message": "成功"
        }
        ]
      }
      */

FUNCTION get_arc_process_task_condition(
    in_task_id NUMBER,
    ot_arc_process_task_condition OUT NOCOPY gt_arc_process_task_config)
  RETURN NUMBER
AS
  lt_arc_process_task_condition  gt_arc_process_task_config;
BEGIN
  SELECT *
  BULK COLLECT INTO lt_arc_process_task_condition
  FROM ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG
  WHERE TASK_ID = in_task_id
  ORDER BY PROCESS_ORDER;
  ot_arc_process_task_condition := lt_arc_process_task_condition;
  RETURN 0;
EXCEPTION
WHEN OTHERS THEN
  RAISE;
END get_arc_process_task_condition;
  
FUNCTION get_archive_sql(ir_task_condition IN gr_arc_proc_task_config_data,ov_insert_sql OUT NOCOPY VARCHAR2,ov_delete_sql OUT NOCOPY VARCHAR2)
 RETURN NUMBER
AS
  lv_insert_sql           VARCHAR2(4000);
  lv_delete_sql           VARCHAR2(4000);
  lv_archive_condition_c2 VARCHAR2(64);
  lv_db_link              VARCHAR2(64);
  lv_archive_date         VARCHAR2(10);
  ld_archive_date         DATE;
  ln_has_xmltype          NUMBER;
BEGIN
  lv_db_link := ir_task_condition.ARCHIVE_DB_LINK;
  ld_archive_date := ir_task_condition.ARCHIVE_DATE_VALUE;
  --归档日期与当前日期差异小于一年不允许归档
    IF ld_archive_date > sysdate - 366 THEN
      raise e_parm_notvalid;
    END IF;
  --细表关联条件非空判断
  IF ir_task_condition.DETAIL_TABLE_FLAG   = '1' THEN     --细表
    IF ir_task_condition.RELATE_MASTER_TABLE_NAME IS NULL THEN
      raise e_parm_notvalid;
    END IF;
    IF ir_task_condition.RELATE_MASTER_TABLE_COLUMN IS NULL THEN
      raise e_parm_notvalid;
    END IF;
    IF ir_task_condition.RELATE_DETAIL_TABLE_COLUMN IS NULL THEN
      raise e_parm_notvalid;
    END IF;
  END IF;
  --源表与归档表的结构一致性判断
  
    lv_archive_date  := TO_CHAR(ld_archive_date,'yyyy-mm-dd');
    SELECT COUNT(*) INTO ln_has_xmltype FROM SYS.DBA_TAB_COLUMNS
    WHERE OWNER = ir_task_condition.TABLE_OWNER
      AND TABLE_NAME = ir_task_condition.TABLE_NAME
      AND DATA_TYPE = 'XMLTYPE';
    --包含XMLTYPE类型字段的表，发送到远程数据库执行
    IF ln_has_xmltype > 0 THEN  
      IF ir_task_condition.ARCHIVE_TABLE_C2 IS NULL THEN
        --生成Insert SQL语句
        IF ir_task_condition.DETAIL_TABLE_FLAG = '1' THEN --细表
          lv_insert_sql := 'insert into /*+ APPEND */ '||ir_task_condition.ARCHIVE_TABLE_NAME||' nologging ';
          lv_insert_sql := lv_insert_sql||' select a.* from '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||'@'||lv_db_link||' a, '|| ir_task_condition.RELATE_MASTER_TABLE_NAME||'@'||lv_db_link||' b';
          lv_insert_sql := lv_insert_sql||' where  b.'||ir_task_condition.RELATE_MASTER_TABLE_COLUMN||' = a.'|| ir_task_condition.RELATE_DETAIL_TABLE_COLUMN;
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_insert_sql := lv_insert_sql||' and b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'')';
          END IF;
          lv_insert_sql := lv_insert_sql||' and EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE@'||lv_db_link||' c WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1||')';
        ELSE
          lv_insert_sql := 'insert into /*+ APPEND */ '||ir_task_condition.ARCHIVE_TABLE_NAME||' nologging ';
          lv_insert_sql := lv_insert_sql||' select b.* from '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||'@'||lv_db_link||' b';
          lv_insert_sql := lv_insert_sql||' where  ';
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_insert_sql := lv_insert_sql||' b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'') and ';
          END IF;
          lv_insert_sql := lv_insert_sql||' EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE@'||lv_db_link||' c WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1||')';
        END IF;
        --生成Delete SQL语句
        IF ir_task_condition.DETAIL_TABLE_FLAG = '1' THEN --细表
          lv_delete_sql := 'delete from  '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||'@'||lv_db_link||' a';
          lv_delete_sql := lv_delete_sql||' where exists ( select 1 from '|| ir_task_condition.RELATE_MASTER_TABLE_NAME||'@'||lv_db_link||' b';
          lv_delete_sql := lv_delete_sql||' where  b.'||ir_task_condition.RELATE_MASTER_TABLE_COLUMN||' = a.'|| ir_task_condition.RELATE_DETAIL_TABLE_COLUMN;
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_delete_sql := lv_delete_sql||' and b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'')';
          END IF;
          lv_delete_sql := lv_delete_sql||' and EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE@'||lv_db_link||' c WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1||'))';
        ELSE
          lv_delete_sql                     := lv_delete_sql||'delete from '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||'@'||lv_db_link||' b';
          lv_delete_sql := lv_delete_sql||' where  ';
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_delete_sql := lv_delete_sql||' b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'') and ';
          END IF;
          lv_delete_sql := lv_delete_sql||' EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE@'||lv_db_link||' c WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1||')';
        END IF;
      ELSE
        --生成Insert SQL语句
        IF ir_task_condition.DETAIL_TABLE_FLAG = '1' THEN --细表
          lv_insert_sql := 'insert into /*+ APPEND */ '||ir_task_condition.ARCHIVE_TABLE_NAME||' nologging ';
          lv_insert_sql := lv_insert_sql||' select a.* from '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||'@'||lv_db_link||' a, '|| ir_task_condition.RELATE_MASTER_TABLE_NAME||'@'||lv_db_link||' b';
          lv_insert_sql := lv_insert_sql||' where  b.'||ir_task_condition.RELATE_MASTER_TABLE_COLUMN||' = a.'|| ir_task_condition.RELATE_DETAIL_TABLE_COLUMN;
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_insert_sql := lv_insert_sql||' and b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'')';
          END IF;
          lv_insert_sql := lv_insert_sql||' and EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE@'||lv_db_link||' c ';
          lv_insert_sql := lv_insert_sql||' WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1;
          lv_insert_sql := lv_insert_sql||' AND c.'||ir_task_condition.ARCHIVE_CONDITION_C2|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C2||')';
        ELSE
          lv_insert_sql := 'insert into /*+ APPEND */ '||ir_task_condition.ARCHIVE_TABLE_NAME||' nologging ';
          lv_insert_sql := lv_insert_sql||' select b.* from '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||'@'||lv_db_link||' b';
          lv_insert_sql := lv_insert_sql||' where  ';
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_delete_sql := lv_delete_sql||'   b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'') and ';
          END IF;
          lv_insert_sql := lv_insert_sql||' EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE@'||lv_db_link||' c ';
          lv_insert_sql := lv_insert_sql||' WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1;
          lv_insert_sql := lv_insert_sql||' AND c.'||ir_task_condition.ARCHIVE_CONDITION_C2|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C2||')';
        END IF;
        --生成Delete SQL语句
        IF ir_task_condition.DETAIL_TABLE_FLAG = '1' THEN --细表
          lv_delete_sql                  := 'delete from  '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||'@'||lv_db_link||' a';
          lv_delete_sql                  := lv_delete_sql||' where exists ( select 1 from '|| ir_task_condition.RELATE_MASTER_TABLE_NAME||'@'||lv_db_link||' b';
          lv_delete_sql := lv_delete_sql||' where  b.'||ir_task_condition.RELATE_MASTER_TABLE_COLUMN||' = a.'|| ir_task_condition.RELATE_DETAIL_TABLE_COLUMN;
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_delete_sql := lv_delete_sql||' and b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'')';
          END IF;
          lv_delete_sql := lv_delete_sql||' and EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE@'||lv_db_link||' c ';
          lv_delete_sql := lv_delete_sql||' WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1;
          lv_delete_sql := lv_delete_sql||' AND c.'||ir_task_condition.ARCHIVE_CONDITION_C2|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C2||'))';
        ELSE
          lv_delete_sql                     := lv_delete_sql||'delete from '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||'@'||lv_db_link||' b';
          lv_delete_sql := lv_delete_sql||' where  ';
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_delete_sql := lv_delete_sql||'   b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'') and ';
          END IF;
          lv_delete_sql := lv_delete_sql||' EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE@'||lv_db_link||' c ';
          lv_delete_sql := lv_delete_sql||' WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1;
          lv_delete_sql := lv_delete_sql||' AND c.'||ir_task_condition.ARCHIVE_CONDITION_C2|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C2||')';
        END IF;
      END IF;
    --不包含XMLTYPE类型字段的表，本地数据库执行
    ELSE
    --处理归档条件2
      IF ir_task_condition.ARCHIVE_TABLE_C2 IS NULL THEN
        --生成Insert SQL语句
        IF ir_task_condition.DETAIL_TABLE_FLAG = '1' THEN --细表
          lv_insert_sql := 'insert into /*+ APPEND */ '||ir_task_condition.ARCHIVE_TABLE_NAME||'@'||lv_db_link||' nologging ';
          lv_insert_sql := lv_insert_sql||' select a.* from '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||' a, '|| ir_task_condition.RELATE_MASTER_TABLE_NAME||' b';
          lv_insert_sql := lv_insert_sql||' where  b.'||ir_task_condition.RELATE_MASTER_TABLE_COLUMN||' = a.'|| ir_task_condition.RELATE_DETAIL_TABLE_COLUMN;
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_insert_sql := lv_insert_sql||' and b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'')';
          END IF;
          lv_insert_sql := lv_insert_sql||' and EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE c WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1||')';
        ELSE
          lv_insert_sql := 'insert into /*+ APPEND */ '||ir_task_condition.ARCHIVE_TABLE_NAME||'@'||lv_db_link||' nologging ';
          lv_insert_sql := lv_insert_sql||' select b.* from '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||' b';
          lv_insert_sql := lv_insert_sql||' where  ';
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_insert_sql := lv_insert_sql||' b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'') and ';
          END IF;
          lv_insert_sql := lv_insert_sql||' EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE c WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1||')';
        END IF;
        --生成Delete SQL语句
        IF ir_task_condition.DETAIL_TABLE_FLAG = '1' THEN --细表
          lv_delete_sql := 'delete from  '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||' a';
          lv_delete_sql := lv_delete_sql||' where exists ( select 1 from '|| ir_task_condition.RELATE_MASTER_TABLE_NAME||' b';
          lv_delete_sql := lv_delete_sql||' where  b.'||ir_task_condition.RELATE_MASTER_TABLE_COLUMN||' = a.'|| ir_task_condition.RELATE_DETAIL_TABLE_COLUMN;
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_delete_sql := lv_delete_sql||' and b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'')';
          END IF;
          lv_delete_sql := lv_delete_sql||' and EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE c WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1||'))';
        ELSE
          lv_delete_sql                     := lv_delete_sql||'delete from '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||' b';
          lv_delete_sql := lv_delete_sql||' where  ';
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_delete_sql := lv_delete_sql||' b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'') and ';
          END IF;
          lv_delete_sql := lv_delete_sql||' EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE c WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1||')';
        END IF;
      ELSE
        --生成Insert SQL语句
        IF ir_task_condition.DETAIL_TABLE_FLAG = '1' THEN --细表
          lv_insert_sql := 'insert into /*+ APPEND */ '||ir_task_condition.ARCHIVE_TABLE_NAME||'@'||lv_db_link||' nologging ';
          lv_insert_sql := lv_insert_sql||' select a.* from '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||' a, '|| ir_task_condition.RELATE_MASTER_TABLE_NAME||' b';
          lv_insert_sql := lv_insert_sql||' where  b.'||ir_task_condition.RELATE_MASTER_TABLE_COLUMN||' = a.'|| ir_task_condition.RELATE_DETAIL_TABLE_COLUMN;
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_insert_sql := lv_insert_sql||' and b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'')';
          END IF;
          lv_insert_sql := lv_insert_sql||' and EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE c ';
          lv_insert_sql := lv_insert_sql||' WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1;
          lv_insert_sql := lv_insert_sql||' AND c.'||ir_task_condition.ARCHIVE_CONDITION_C2|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C2||')';
        ELSE
          lv_insert_sql := 'insert into /*+ APPEND */ '||ir_task_condition.ARCHIVE_TABLE_NAME||'@'||lv_db_link||' nologging ';
          lv_insert_sql := lv_insert_sql||' select b.* from '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||' b';
          lv_insert_sql := lv_insert_sql||' where  ';
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_delete_sql := lv_delete_sql||'   b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'') and ';
          END IF;
          lv_insert_sql := lv_insert_sql||' EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE c ';
          lv_insert_sql := lv_insert_sql||' WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1;
          lv_insert_sql := lv_insert_sql||' AND c.'||ir_task_condition.ARCHIVE_CONDITION_C2|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C2||')';
        END IF;
        --生成Delete SQL语句
        IF ir_task_condition.DETAIL_TABLE_FLAG = '1' THEN --细表
          lv_delete_sql                  := 'delete from  '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||' a';
          lv_delete_sql                  := lv_delete_sql||' where exists ( select 1 from '|| ir_task_condition.RELATE_MASTER_TABLE_NAME||' b';
          lv_delete_sql := lv_delete_sql||' where  b.'||ir_task_condition.RELATE_MASTER_TABLE_COLUMN||' = a.'|| ir_task_condition.RELATE_DETAIL_TABLE_COLUMN;
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_delete_sql := lv_delete_sql||' and b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'')';
          END IF;
          lv_delete_sql := lv_delete_sql||' and EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE c ';
          lv_delete_sql := lv_delete_sql||' WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1;
          lv_delete_sql := lv_delete_sql||' AND c.'||ir_task_condition.ARCHIVE_CONDITION_C2|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C2||'))';
        ELSE
          lv_delete_sql                     := lv_delete_sql||'delete from '||ir_task_condition.TABLE_OWNER||'.'||ir_task_condition.TABLE_NAME||' b';
          lv_delete_sql := lv_delete_sql||' where  ';
          IF ir_task_condition.ARCHIVE_DATE_COLUMN IS NOT NULL THEN
            lv_delete_sql := lv_delete_sql||'   b.'||ir_task_condition.ARCHIVE_DATE_COLUMN||' < to_date('''||lv_archive_date|| ''',''yyyy-mm-dd'') and ';
          END IF;
          lv_delete_sql := lv_delete_sql||' EXISTS (SELECT 1 FROM ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE c ';
          lv_delete_sql := lv_delete_sql||' WHERE c.'||ir_task_condition.ARCHIVE_CONDITION_C1|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C1;
          lv_delete_sql := lv_delete_sql||' AND c.'||ir_task_condition.ARCHIVE_CONDITION_C2|| ' = b.'|| ir_task_condition.ARCHIVE_TABLE_C2||')';
        END IF;
      END IF;
    END IF;
    ov_insert_sql := lv_insert_sql;
    ov_delete_sql := lv_delete_sql;
    RETURN 0;
END get_archive_sql;  


FUNCTION arc_process_task_exec(in_task_id IN NUMBER, in_exec_flag IN NUMBER DEFAULT NULL)
    RETURN VARCHAR2
  AS
    lr_task_condition           gr_arc_proc_task_config_data;
    lt_arc_process_task_config  gt_arc_process_task_config;
    lv_insert_sql     VARCHAR2(4000);
    lv_delete_sql     VARCHAR2(4000);
    lv_remote_insert_sql     VARCHAR2(4000);
    lv_remote_delete_sql     VARCHAR2(4000);
    ln_return         NUMBER;
    lv_return         VARCHAR2(128);
    lv_db_link        VARCHAR2(128);
    lv_archive_key_seq NUMBER;
    lv_archive_condition_c1 VARCHAR2(64);
    lv_archive_condition_c2 VARCHAR2(64);
    ld_archive_date   DATE;
    ld_archive_exec_date   DATE;
    ln_i              NUMBER;
    ln_j              NUMBER;
    ln_insert_count   NUMBER;
    ln_delete_count   NUMBER;
    lv_now_time        VARCHAR2(8);
    lv_run_time_begin  VARCHAR2(8);
    lv_run_time_end    VARCHAR2(8);
    lv_run_stop_time   VARCHAR2(19);
    ln_has_xmltype     NUMBER;
    
    
 BEGIN
    lv_archive_key_seq := 0;
    --获取归档日期
      SELECT TO_DATE(PARAM_VALUE,'YYYY-MM-DD HH24:MI:SS') INTO ld_archive_date 
        FROM ZOEARCHIVE.ARC_PROCESS_TASK_PARAM 
        WHERE TASK_ID = in_task_id AND PARAM_NAME =  'ARCHIVE_DATE';
    --强制限制不允许归档1年内数据
      ln_return := ZOEARCHIVE.ZOEPKG_ARCHIVE_COMM.ARCHIVE_DATE_LIMIT(ld_archive_date);
      IF ln_return = -1 THEN
        RETURN '不允许归档1年内数据';
      END IF;
    --获取数据库链路
      SELECT PARAM_VALUE INTO lv_db_link
      FROM ZOEARCHIVE.ARC_PROCESS_TASK_PARAM WHERE TASK_ID = in_task_id AND PARAM_NAME='DB_LINK';
    --获取归档处理任务各个表的条件
      ln_return := get_arc_process_task_condition(in_task_id,lt_arc_process_task_config);
    --执行归档处理任务
      LOOP
      --归档运行时间控制
        lv_now_time :=TO_CHAR(sysdate,'hh24:mi:ss');
        SELECT PARAM_VALUE INTO lv_run_stop_time  FROM ZOEARCHIVE.ARC_PROCESS_TASK_PARAM WHERE TASK_ID = 0 AND PARAM_NAME = 'RUN_STOP_TIME';
        SELECT PARAM_VALUE INTO lv_run_time_begin FROM ZOEARCHIVE.ARC_PROCESS_TASK_PARAM WHERE TASK_ID = 0 AND PARAM_NAME = 'RUN_TIME_BEGIN';
        SELECT PARAM_VALUE INTO lv_run_time_end   FROM ZOEARCHIVE.ARC_PROCESS_TASK_PARAM WHERE TASK_ID = 0 AND PARAM_NAME = 'RUN_TIME_END';
        IF SYSDATE > TO_DATE(lv_run_stop_time,'YYYY-MM-DD HH24:MI:SS') THEN 
          DBMS_OUTPUT.PUT_LINE('超过设定停止时间：'||lv_run_stop_time);
          RETURN -1;
        ELSE 
          IF  lv_now_time > lv_run_time_end AND lv_now_time < lv_run_time_begin THEN
            DBMS_OUTPUT.PUT_LINE('超过允许运行时间范围：'||lv_run_time_begin||'::'||lv_run_time_end);
            RETURN -1;
          END IF;
        END IF;
        --生成归档处理任务数据缓存
         lv_return := arc_process_task_prepay(in_task_id,ld_archive_date,ld_archive_exec_date);
        IF lv_return = 1 THEN
          lr_task_condition.ARCHIVE_DB_LINK    := lv_db_link;
          lr_task_condition.ARCHIVE_DATE_VALUE := ld_archive_exec_date;
        --依次处理归档表
          FOR i IN 1..lt_arc_process_task_config.COUNT 
          LOOP 
            lr_task_condition.TABLE_OWNER := lt_arc_process_task_config(i).TABLE_OWNER;
            lr_task_condition.TABLE_NAME := lt_arc_process_task_config(i).TABLE_NAME;
            lr_task_condition.ARCHIVE_TABLE_OWNER := lt_arc_process_task_config(i).ARCHIVE_TABLE_OWNER;
            lr_task_condition.ARCHIVE_TABLE_NAME := lt_arc_process_task_config(i).ARCHIVE_TABLE_NAME;
            lr_task_condition.DETAIL_TABLE_FLAG := lt_arc_process_task_config(i).DETAIL_TABLE_FLAG;
            lr_task_condition.RELATE_MASTER_TABLE_NAME := lt_arc_process_task_config(i).RELATE_MASTER_TABLE_NAME;
            lr_task_condition.RELATE_MASTER_TABLE_COLUMN := lt_arc_process_task_config(i).RELATE_MASTER_TABLE_COLUMN;
            lr_task_condition.RELATE_DETAIL_TABLE_COLUMN := lt_arc_process_task_config(i).RELATE_DETAIL_TABLE_COLUMN;
            lr_task_condition.ARCHIVE_DATE_COLUMN := lt_arc_process_task_config(i).ARCHIVE_DATE_COLUMN;
            lr_task_condition.ARCHIVE_CONDITION_C1 := lt_arc_process_task_config(i).ARCHIVE_CONDITION_C1;
            lr_task_condition.ARCHIVE_CONDITION_C2 := lt_arc_process_task_config(i).ARCHIVE_CONDITION_C2;
            lr_task_condition.ARCHIVE_TABLE_C1 := lt_arc_process_task_config(i).ARCHIVE_TABLE_C1;
            lr_task_condition.ARCHIVE_TABLE_C2 := lt_arc_process_task_config(i).ARCHIVE_TABLE_C2;
      
            IF lr_task_condition.ARCHIVE_CONDITION_C1 IS NULL OR lr_task_condition.ARCHIVE_TABLE_C1 IS NULL THEN
              RETURN -1;
            ELSE IF lr_task_condition.ARCHIVE_TABLE_C2 IS NULL THEN
                   SELECT KEY_SEQ INTO lv_archive_key_seq FROM ARC_PROCESS_TASK_DATA_KEY WHERE TASK_ID = in_task_id AND KEY_NAME = lr_task_condition.ARCHIVE_CONDITION_C1;
                   CASE 
                     WHEN lv_archive_key_seq=1 THEN lv_archive_condition_c1 := 'ARCHIVE_CONDITION_VALUE1';
                     WHEN lv_archive_key_seq=2 THEN lv_archive_condition_c1 := 'ARCHIVE_CONDITION_VALUE2';
                     WHEN lv_archive_key_seq=3 THEN lv_archive_condition_c1 := 'ARCHIVE_CONDITION_VALUE3';
                   ELSE
                    RETURN -1;
                   END CASE;
                   lr_task_condition.ARCHIVE_CONDITION_C1 := lv_archive_condition_c1;
                 ELSE
                    lv_archive_key_seq := 0;
                   SELECT KEY_SEQ INTO lv_archive_key_seq FROM ARC_PROCESS_TASK_DATA_KEY WHERE TASK_ID = in_task_id AND KEY_NAME = lr_task_condition.ARCHIVE_CONDITION_C1;
                   CASE 
                     WHEN lv_archive_key_seq=1 THEN lv_archive_condition_c1 := 'ARCHIVE_CONDITION_VALUE1';
                     WHEN lv_archive_key_seq=2 THEN lv_archive_condition_c1 := 'ARCHIVE_CONDITION_VALUE2';
                     WHEN lv_archive_key_seq=3 THEN lv_archive_condition_c1 := 'ARCHIVE_CONDITION_VALUE3';
                   ELSE
                    RETURN -1;
                   END CASE;
                    lv_archive_key_seq := 0;
                   SELECT KEY_SEQ INTO lv_archive_key_seq FROM ARC_PROCESS_TASK_DATA_KEY WHERE TASK_ID = in_task_id AND KEY_NAME = lr_task_condition.ARCHIVE_CONDITION_C2;
                   CASE 
                     WHEN lv_archive_key_seq=1 THEN lv_archive_condition_c2 := 'ARCHIVE_CONDITION_VALUE1';
                     WHEN lv_archive_key_seq=2 THEN lv_archive_condition_c2 := 'ARCHIVE_CONDITION_VALUE2';
                     WHEN lv_archive_key_seq=3 THEN lv_archive_condition_c2 := 'ARCHIVE_CONDITION_VALUE3';
                   ELSE
                    RETURN -1;
                   END CASE;
                   lr_task_condition.ARCHIVE_CONDITION_C1 := lv_archive_condition_c1;
                   lr_task_condition.ARCHIVE_CONDITION_C2 := lv_archive_condition_c2;
                 END IF;
            END IF;
            
            ln_return := get_archive_sql(lr_task_condition ,lv_insert_sql ,lv_delete_sql );
            IF in_exec_flag = 110 THEN
              SELECT COUNT(1) INTO ln_i
              FROM ZOEARCHIVE.ARC_PROCESS_TASK_RECORD
              WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                AND INSERT_COMPLETED_FLAG = 'N';
              IF ln_i = 1 THEN
                UPDATE ZOEARCHIVE.ARC_PROCESS_TASK_RECORD 
                SET INSERT_START_TIME = SYSDATE
                WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                  AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                  AND INSERT_COMPLETED_FLAG = 'N';
                SELECT COUNT(*) INTO ln_has_xmltype FROM SYS.DBA_TAB_COLUMNS
                WHERE OWNER = lr_task_condition.TABLE_OWNER
                  AND TABLE_NAME = lr_task_condition.TABLE_NAME
                  AND DATA_TYPE = 'XMLTYPE';
                IF ln_has_xmltype > 0 THEN
                  lv_remote_insert_sql := 'begin zoeprc_archive_execsql@'||lv_db_link||'('''||lv_insert_sql||'''); end;';
                  EXECUTE IMMEDIATE lv_remote_insert_sql; 
                ELSE
                  EXECUTE IMMEDIATE lv_insert_sql;
                END IF;  
                ln_insert_count := SQL%ROWCOUNT;
                UPDATE ZOEARCHIVE.ARC_PROCESS_TASK_RECORD 
                SET INSERT_END_TIME = SYSDATE, INSERT_COUNT = ln_insert_count, INSERT_COMPLETED_FLAG = 'Y' ,INSERT_SQL = lv_insert_sql
                WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                  AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                  AND INSERT_COMPLETED_FLAG = 'N';
                COMMIT;                
              END IF;
              ln_i := 0;
              SELECT COUNT(1) INTO ln_j
              FROM ZOEARCHIVE.ARC_PROCESS_TASK_RECORD
              WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                AND INSERT_COMPLETED_FLAG = 'Y';
              IF ln_j = 1 THEN
                SELECT COUNT(1) INTO ln_i
                FROM ZOEARCHIVE.ARC_PROCESS_TASK_RECORD
                WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                  AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                  AND DELETE_COMPLETED_FLAG = 'N';
                IF ln_i = 1 THEN
                  UPDATE ZOEARCHIVE.ARC_PROCESS_TASK_RECORD 
                  SET DELETE_START_TIME = SYSDATE
                  WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                    AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                    AND DELETE_COMPLETED_FLAG = 'N';
                SELECT COUNT(*) INTO ln_has_xmltype FROM SYS.DBA_TAB_COLUMNS
                WHERE OWNER = lr_task_condition.TABLE_OWNER
                  AND TABLE_NAME = lr_task_condition.TABLE_NAME
                  AND DATA_TYPE = 'XMLTYPE';
                IF ln_has_xmltype > 0 THEN
                  lv_remote_delete_sql := 'begin zoeprc_archive_execsql@'||lv_db_link||'('''||lv_delete_sql||'''); end;';
                  EXECUTE IMMEDIATE lv_remote_delete_sql; 
                ELSE
                   EXECUTE IMMEDIATE lv_delete_sql;
                END IF;
                  ln_delete_count := SQL%ROWCOUNT;
                  UPDATE ZOEARCHIVE.ARC_PROCESS_TASK_RECORD 
                  SET DELETE_END_TIME = SYSDATE, DELETE_COUNT = ln_delete_count, DELETE_COMPLETED_FLAG = 'Y', DELETE_SQL = lv_delete_sql
                  WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                    AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                    AND DELETE_COMPLETED_FLAG = 'N';
                  COMMIT;                
                END IF;
              END IF;
            --模拟测试执行
            ELSE
             SELECT COUNT(1) INTO ln_i
              FROM ZOEARCHIVE.ARC_PROCESS_TASK_RECORD
              WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                AND INSERT_COMPLETED_FLAG = 'N';
              IF ln_i = 1 THEN
                UPDATE ZOEARCHIVE.ARC_PROCESS_TASK_RECORD 
                SET INSERT_START_TIME = SYSDATE
                WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                  AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                  AND INSERT_COMPLETED_FLAG = 'N';
                SELECT COUNT(*) INTO ln_has_xmltype FROM SYS.DBA_TAB_COLUMNS
                WHERE OWNER = lr_task_condition.TABLE_OWNER
                  AND TABLE_NAME = lr_task_condition.TABLE_NAME
                  AND DATA_TYPE = 'XMLTYPE';
                IF ln_has_xmltype > 0 THEN
                  lv_remote_insert_sql := 'begin zoeprc_archive_execsql@'||lv_db_link||'('''||lv_insert_sql||'''); end;';
                  DBMS_OUTPUT.PUT_LINE(lv_remote_insert_sql); 
                ELSE
                  DBMS_OUTPUT.PUT_LINE(lv_insert_sql);
                END IF;
                ln_insert_count := SQL%ROWCOUNT;
                UPDATE ZOEARCHIVE.ARC_PROCESS_TASK_RECORD 
                SET INSERT_END_TIME = SYSDATE, INSERT_COUNT = ln_insert_count, INSERT_COMPLETED_FLAG = 'Y', INSERT_SQL = lv_insert_sql
                WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                  AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                  AND INSERT_COMPLETED_FLAG = 'N';
                COMMIT;                
              END IF;
              ln_i := 0;
              SELECT COUNT(1) INTO ln_j
              FROM ZOEARCHIVE.ARC_PROCESS_TASK_RECORD
              WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                AND INSERT_COMPLETED_FLAG = 'Y';
              IF ln_j = 1 THEN
                SELECT COUNT(1) INTO ln_i
                FROM ZOEARCHIVE.ARC_PROCESS_TASK_RECORD
                WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                  AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                  AND DELETE_COMPLETED_FLAG = 'N';
                IF ln_i = 1 THEN
                  UPDATE ZOEARCHIVE.ARC_PROCESS_TASK_RECORD 
                  SET DELETE_START_TIME = SYSDATE
                  WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                    AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                    AND DELETE_COMPLETED_FLAG = 'N';
                SELECT COUNT(*) INTO ln_has_xmltype FROM SYS.DBA_TAB_COLUMNS
                WHERE OWNER = lr_task_condition.TABLE_OWNER
                  AND TABLE_NAME = lr_task_condition.TABLE_NAME
                  AND DATA_TYPE = 'XMLTYPE';
                IF ln_has_xmltype > 0 THEN
                  lv_remote_delete_sql := 'begin zoeprc_archive_execsql@'||lv_db_link||'('''||lv_delete_sql||'''); end;';
                  DBMS_OUTPUT.PUT_LINE(lv_remote_delete_sql); 
                ELSE
                  DBMS_OUTPUT.PUT_LINE(lv_delete_sql);
                END IF;
                  ln_delete_count := SQL%ROWCOUNT;
                  UPDATE ZOEARCHIVE.ARC_PROCESS_TASK_RECORD 
                  SET DELETE_END_TIME = SYSDATE, DELETE_COUNT = ln_delete_count, DELETE_COMPLETED_FLAG = 'Y', DELETE_SQL = lv_delete_sql
                  WHERE TASK_ID = in_task_id AND ARCHIVE_DATE = lr_task_condition.ARCHIVE_DATE_VALUE
                    AND TABLE_OWNER = lr_task_condition.TABLE_OWNER AND TABLE_NAME = lr_task_condition.TABLE_NAME
                    AND DELETE_COMPLETED_FLAG = 'N';
                  COMMIT;                
                END IF;
              END IF;
            END IF;
          END LOOP;
        ELSE 
          RETURN -1;
        END IF;
      END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RETURN SQLERRM;
  END arc_process_task_exec;

END ZOEPKG_ARCHIVE_PROCESS;
/

