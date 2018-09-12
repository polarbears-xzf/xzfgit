--  用于会话上下文记录信息
CREATE OR REPLACE TYPE ZOESECURITY.zoetyp_aud_session_context AS OBJECT
(USERNAME                  VARCHAR2(128) ,
OS_USERNAME               VARCHAR2(255) ,
HOST                      VARCHAR2(255) ,
TERMINAL                  VARCHAR2(255) ,
IP_ADDRESS                VARCHAR2(64)  ,
CURRENT_USER              VARCHAR2(64)  
);
/

--  用于DDL审计日志
CREATE OR REPLACE TYPE ZOESECURITY.zoetyp_aud_log AS OBJECT
(LOG_ID                   VARCHAR2(64) , 
USERNAME                  VARCHAR2(128) ,
OS_USERNAME               VARCHAR2(255) ,
HOST                      VARCHAR2(255) ,
TERMINAL                  VARCHAR2(255) ,
IP_ADDRESS                VARCHAR2(64)  ,
CURRENT_USER              VARCHAR2(64)  ,
OBJECT_OWNER              VARCHAR2(128) ,
OBJECT_NAME               VARCHAR2(128) ,
OBJECT_TYPE               VARCHAR2(64)  ,
NEW_OBJECT_OWNER          VARCHAR2(128) ,
NEW_OBJECT_NAME           VARCHAR2(128) ,
OPERATION_TYPE            VARCHAR2(64)  ,
OPERATION_TIME            DATE          ,
RETURNCODE                NUMBER        ,
SQL_ID                    VARCHAR2(64)  ,
SQL_TEXT                  VARCHAR2(32767) 
);
/

--用于安全访问控制要素
CREATE OR REPLACE TYPE ZOESECURITY.zoetyp_aud_firewall AS OBJECT
(FACTOR_WHO                VARCHAR2(128) ,
FACTOR_WHERE               VARCHAR2(128) ,
FACTOR_WHEN                DATE ,
FACTOR_WHAT                VARCHAR2(128) 
);
/
