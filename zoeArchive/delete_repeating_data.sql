SELECT TO_CHAR(SYSDATE,'yyyy-mm-dd hh24:mi:ss') from dual;

--delete from  ZOEARCHIVE.SICK_SETTLE_DETAIL_A a
--where exists(select 1 from INPSICK.SICK_SETTLE_DETAIL@zoedblink_his b
--				 where a.SETTLE_NO=b.SETTLE_NO
--					and a.RECEIPT_CLASS=b.RECEIPT_CLASS);
--COMMIT;

--delete from  ZOEARCHIVE.DISPENSARY_PRESCRIBE_DETAIL_A a
--where exists(select 1 from OUTPSICK.DISPENSARY_PRESCRIBE_DETAIL@zoedblink_his b
--				 where a.PRESCRIPTION_NUMBER=b.PRESCRIPTION_NUMBER
--					and a.SEQUENCE_NUMBER=b.SEQUENCE_NUMBER);
--COMMIT;

--delete from  ZOEARCHIVE.APPLY_SHEET_DETAIL_A a
--where exists(select 1 from COMM.APPLY_SHEET_DETAIL@zoedblink_his b
--				 where a.APPLY_NO=b.APPLY_NO
--					and a.ITEM_SEQUENCE=b.ITEM_SEQUENCE);
--COMMIT;

delete from  ZOEARCHIVE.RESIDENCE_SICK_PRICE_ITEM_A a
where exists(select 1 from INPSICK.RESIDENCE_SICK_PRICE_ITEM@zoedblink_his b
				 where a.SEQUENCE_NO=b.SEQUENCE_NO);
COMMIT;

delete from  ZOEARCHIVE.LAY_PHYSIC_RECORDS_A a
where exists(select 1 from PHYSIC.LAY_PHYSIC_RECORDS@zoedblink_his b
				 where a.APPLY_NO=b.APPLY_NO
					and a.APPLY_SUB_NO=b.APPLY_SUB_NO);
COMMIT;

delete from  ZOEARCHIVE.DISPENSARY_SICK_PRICE_ITEM_A a
where exists(select 1 from OUTPSICK.DISPENSARY_SICK_PRICE_ITEM@zoedblink_his b
				 where a.SEQUENCE_NO=b.SEQUENCE_NO);
COMMIT;


delete from  ZOEARCHIVE.PRESCRIBE_RECORD_A a
where exists(select 1 from INPSICK.PRESCRIBE_RECORD@zoedblink_his b
				 where a.PRESCRIBE_NUMBER=b.PRESCRIBE_NUMBER
					and a.PRESCRIBE_SUB_NUMBER=b.PRESCRIBE_SUB_NUMBER);
COMMIT;

delete from  ZOEARCHIVE.SICK_SETTLE_MASTER_A a
where exists(select 1 from INPSICK.SICK_SETTLE_MASTER@zoedblink_his b
				 where a.SETTLE_NO=b.SETTLE_NO);
COMMIT;

delete from  ZOEARCHIVE.APPLY_SHEET_A a
where exists(select 1 from COMM.APPLY_SHEET@zoedblink_his b
				 where a.APPLY_NO=b.APPLY_NO);
COMMIT;

delete from  ZOEARCHIVE.PREPAYMENT_MONEY_A a
where exists(select 1 from COMM.PREPAYMENT_MONEY@zoedblink_his b
				 where a.PREPAY_NO=b.PREPAY_NO);
COMMIT;

delete from  ZOEARCHIVE.DISPENSARY_PRESCRIP_MASTER_A a
where exists(select 1 from OUTPSICK.DISPENSARY_PRESCRIP_MASTER@zoedblink_his b
				 where a.PRESCRIPTION_NUMBER=b.PRESCRIPTION_NUMBER);
COMMIT;

SELECT TO_CHAR(SYSDATE,'yyyy-mm-dd hh24:mi:ss') from dual;

